import asyncio
import base64
import json
from typing import Any

import httpx
from fastapi import HTTPException, status
from pydantic import ValidationError

from app.core.config import settings
from app.providers.base import AiProvider, VisionSolverProvider
from app.schemas.solver import MathSolutionRequestContext, MathSolutionResponse


class GeminiProvider(AiProvider, VisionSolverProvider):
    async def embed(self, text: str) -> list[float]:
        api_key = _require_api_key()
        payload = {
            "model": f"models/{settings.gemini_embedding_model}",
            "content": {"parts": [{"text": text}]},
        }
        try:
            async with httpx.AsyncClient(timeout=60) as client:
                response = await client.post(
                    _gemini_url(settings.gemini_embedding_model, "embedContent"),
                    headers={"x-goog-api-key": api_key},
                    json=payload,
                )
                response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            raise _to_provider_error("Gemini embedding request failed", exc) from exc
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail=_http_error_detail("Gemini embedding service is unavailable", exc),
            ) from exc

        data = response.json()
        values = data.get("embedding", {}).get("values")
        if not isinstance(values, list):
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Gemini returned an invalid embedding payload",
            )
        return values

    async def chat(self, messages: list[dict[str, str]]) -> str:
        api_key = _require_api_key()
        system_instruction, contents = _to_gemini_messages(messages)
        payload: dict[str, object] = {
            "contents": contents,
            "generationConfig": {
                "temperature": 0.2,
                "topP": 0.9,
            },
        }
        if system_instruction:
            payload["systemInstruction"] = {"parts": [{"text": system_instruction}]}

        try:
            async with httpx.AsyncClient(timeout=120) as client:
                response = await client.post(
                    _gemini_url(settings.gemini_chat_model, "generateContent"),
                    headers={"x-goog-api-key": api_key},
                    json=payload,
                )
                response.raise_for_status()
        except httpx.HTTPStatusError as exc:
            raise _to_provider_error("Gemini chat request failed", exc) from exc
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail=_http_error_detail("Gemini chat service is unavailable", exc),
            ) from exc

        text = _extract_text(response.json())
        if not text:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Gemini returned an empty chat response",
            )
        return text

    async def solve_math_image(
        self,
        *,
        image_bytes: bytes,
        mime_type: str,
        context: MathSolutionRequestContext,
    ) -> MathSolutionResponse:
        _require_api_key()

        payload = self._build_vision_payload(
            image_bytes=image_bytes,
            mime_type=mime_type,
            context=context,
            include_schema=True,
        )

        try:
            response_json = await self._request_vision_with_retry(payload)
        except HTTPException as exc:
            if exc.status_code != status.HTTP_400_BAD_REQUEST:
                raise
            fallback_payload = self._build_vision_payload(
                image_bytes=image_bytes,
                mime_type=mime_type,
                context=context,
                include_schema=False,
            )
            response_json = await self._request_vision_with_retry(fallback_payload)

        text = _extract_text(response_json)
        data = _parse_json_text(text)
        data["model"] = settings.solver_model

        try:
            return MathSolutionResponse.model_validate(data)
        except ValidationError as exc:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail=f"AI returned JSON that does not match solver schema: {exc.errors()}",
            ) from exc

    def _build_vision_payload(
        self,
        *,
        image_bytes: bytes,
        mime_type: str,
        context: MathSolutionRequestContext,
        include_schema: bool,
    ) -> dict[str, Any]:
        generation_config: dict[str, Any] = {
            "temperature": 0.2,
            "topP": 0.9,
            "maxOutputTokens": 4096,
            "responseMimeType": "application/json",
        }
        if include_schema:
            generation_config["responseSchema"] = _solver_response_schema()

        return {
            "contents": [
                {
                    "role": "user",
                    "parts": [
                        {"text": _build_solver_prompt(context)},
                        {
                            "inlineData": {
                                "mimeType": mime_type,
                                "data": base64.b64encode(image_bytes).decode("ascii"),
                            }
                        },
                    ],
                }
            ],
            "generationConfig": generation_config,
        }

    async def _request_vision_with_retry(self, payload: dict[str, Any]) -> dict[str, Any]:
        url = _gemini_url(settings.solver_model, "generateContent")
        retry_statuses = {429, 500, 502, 503, 504}
        last_error: str | None = None

        async with httpx.AsyncClient(timeout=settings.gemini_timeout_seconds) as client:
            for attempt in range(settings.gemini_max_retries + 1):
                try:
                    response = await client.post(
                        url,
                        headers={"x-goog-api-key": _require_api_key()},
                        json=payload,
                    )
                except httpx.TimeoutException as exc:
                    last_error = f"ReadTimeout; url={url}"
                    if attempt >= settings.gemini_max_retries:
                        raise HTTPException(
                            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                            detail=f"Gemini vision service is unavailable: {last_error}",
                        ) from exc
                    await asyncio.sleep(2**attempt)
                    continue
                except httpx.HTTPError as exc:
                    raise HTTPException(
                        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                        detail=_http_error_detail("Gemini vision service is unavailable", exc),
                    ) from exc

                if response.status_code < 400:
                    return response.json()

                last_error = _response_error_message(response)
                if response.status_code == 400:
                    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=last_error)

                if response.status_code not in retry_statuses or attempt >= settings.gemini_max_retries:
                    raise HTTPException(
                        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                        detail=f"Gemini vision request failed: {last_error}",
                    )

                await asyncio.sleep(2**attempt)

        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Gemini vision request failed: {last_error or 'unknown error'}",
        )


def _require_api_key() -> str:
    if not settings.gemini_api_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="GEMINI_API_KEY is required when AI_PROVIDER=gemini",
        )
    return settings.gemini_api_key


def _gemini_url(model: str, action: str) -> str:
    return f"{settings.gemini_base_url.rstrip('/')}/models/{model}:{action}"


def _to_gemini_messages(messages: list[dict[str, str]]) -> tuple[str | None, list[dict[str, object]]]:
    system_parts: list[str] = []
    contents: list[dict[str, object]] = []
    for message in messages:
        role = message.get("role", "user")
        content = message.get("content", "")
        if role == "system":
            system_parts.append(content)
            continue
        gemini_role = "model" if role == "assistant" else "user"
        contents.append({"role": gemini_role, "parts": [{"text": content}]})
    return "\n\n".join(system_parts) or None, contents


def _extract_text(data: dict) -> str:
    candidates = data.get("candidates") or []
    if not candidates:
        return ""
    parts = candidates[0].get("content", {}).get("parts") or []
    return "\n".join(str(part.get("text", "")).strip() for part in parts).strip()


def _parse_json_text(text: str) -> dict[str, Any]:
    cleaned = text.strip()
    if cleaned.startswith("```"):
        cleaned = cleaned.removeprefix("```json").removeprefix("```").strip()
        cleaned = cleaned.removesuffix("```").strip()

    try:
        data = json.loads(cleaned)
    except json.JSONDecodeError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"AI did not return valid JSON: {exc}",
        ) from exc

    if not isinstance(data, dict):
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="AI returned JSON but root value is not an object.",
        )
    return data


def _build_solver_prompt(context: MathSolutionRequestContext) -> str:
    grade = context.grade_level or "THPT"
    subject_hint = context.subject or "auto"
    lesson_hint = ""
    if context.lesson_id or context.course_id:
        lesson_hint = (
            f"\nNgu canh LMS: course_id={context.course_id or 'unknown'}, "
            f"lesson_id={context.lesson_id or 'unknown'}."
        )

    return f"""
Ban la tro ly hoc tap da mon cho hoc sinh {grade} o Viet Nam.
Hay doc anh da crop, anh nen chi chua 1 cau hoi/bai tap. Mon hoc goi y: {subject_hint}.
Neu subject la "auto" hoac khong khop voi anh, hay tu nhan dien mon hoc va dang bai tu noi dung trong anh.
Tra loi bang {context.language}.
{lesson_hint}

Yeu cau nghiem ngat:
- Chi giai neu doc duoc de bai tu anh.
- Neu anh mo, bi cat mat du kien, co nhieu cau hoi, hoac khong chac de bai, dat needs_clarification=true va khong bia dap an.
- detected_question phai la de bai doc duoc tu anh.
- Hay huong dan cach lam theo tung buoc, khong chi dua dap an.
- Loi giai phai phu hop chuong trinh pho thong Viet Nam va trinh do {grade}.
- Voi Toan, Ly, Hoa, Sinh, Tin hoc: cong thuc, phuong trinh, don vi, ky hieu phai viet bang LaTeX khi can. Inline dung \\(...\\), display dung \\[...\\].
- Voi Ngu van, Lich su, Dia ly, GDCD: trinh bay dan y/lap luan/nguyen nhan-ket qua/y chinh ro rang.
- Voi Tieng Anh/ngoai ngu: giai thich ngu phap, tu vung, dau hieu nhan biet va dap an.
- Voi cau hoi trac nghiem, answer nen ghi dap an chu cai va noi dung neu doc duoc.
- topic_tags nen gom mon hoc va dang bai, vi du ["vat ly", "dien xoay chieu"] hoac ["tieng anh", "relative clause"].
- Chi tra JSON hop le theo schema, khong them markdown.
""".strip()


def _solver_response_schema() -> dict[str, Any]:
    return {
        "type": "object",
        "properties": {
            "detected_question": {"type": "string"},
            "answer": {"type": "string"},
            "steps": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "title": {"type": "string"},
                        "explanation": {"type": "string"},
                        "latex": {"type": "string"},
                    },
                    "required": ["title", "explanation", "latex"],
                },
            },
            "topic_tags": {"type": "array", "items": {"type": "string"}},
            "confidence": {"type": "number"},
            "needs_clarification": {"type": "boolean"},
            "warnings": {"type": "array", "items": {"type": "string"}},
        },
        "required": [
            "detected_question",
            "answer",
            "steps",
            "topic_tags",
            "confidence",
            "needs_clarification",
            "warnings",
        ],
    }


def _response_error_message(response: httpx.Response) -> str:
    try:
        body = response.json()
    except ValueError:
        return response.text[:500]
    error = body.get("error")
    if isinstance(error, dict):
        return error.get("message") or str(error)
    return str(body)


def _to_provider_error(message: str, exc: httpx.HTTPStatusError) -> HTTPException:
    detail = message
    try:
        body = exc.response.json()
        error_message = body.get("error", {}).get("message")
        if error_message:
            detail = f"{message}: {error_message}"
    except ValueError:
        detail = f"{message}: {exc.response.text}"
    return HTTPException(status_code=exc.response.status_code, detail=detail)


def _http_error_detail(message: str, exc: httpx.HTTPError) -> str:
    detail = str(exc) or exc.__class__.__name__
    request = getattr(exc, "request", None)
    if request is not None:
        detail = f"{detail}; url={request.url}"
    return f"{message}: {detail}"
