import httpx
from fastapi import HTTPException, status

from app.core.config import settings
from app.providers.base import AiProvider


class GeminiProvider(AiProvider):
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


def _require_api_key() -> str:
    if not settings.gemini_api_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="GEMINI_API_KEY is required when AI_PROVIDER=gemini",
        )
    return settings.gemini_api_key


def _gemini_url(model: str, action: str) -> str:
    return f"{settings.gemini_base_url}/models/{model}:{action}"


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
