import json
import re
from io import BytesIO
from typing import Any

from fastapi import HTTPException, UploadFile, status
from pypdf import PdfReader

from app.schemas.exam_extraction import ExtractExamResponse, ExtractedQuestion
from app.services.llm_service import LlmService


MAX_EXAM_TEXT_CHARS = 45000


class ExamPdfExtractionService:
    def __init__(self) -> None:
        self.llm_service = LlmService()

    async def extract(
        self,
        *,
        file: UploadFile,
        exam_id: str | None,
        subject: str | None,
        grade_level: int | None,
        profile: str,
    ) -> ExtractExamResponse:
        if file.content_type not in {"application/pdf", "application/octet-stream"}:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Only PDF files are supported",
            )

        pdf_bytes = await file.read()
        text = _extract_pdf_text(pdf_bytes)
        if len(text) < 50:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=(
                    "Could not extract enough text from PDF. The file may be scanned; "
                    "OCR/vision extraction is not implemented yet."
                ),
            )

        clipped_text = text[:MAX_EXAM_TEXT_CHARS]
        response_text = await self.llm_service.chat(
            _build_messages(
                exam_id=exam_id,
                subject=subject,
                grade_level=grade_level,
                profile=profile,
                extracted_text=clipped_text,
            )
        )
        payload = _parse_json_response(response_text)
        questions = [
            ExtractedQuestion.model_validate(_normalize_question(item, exam_id))
            for item in payload.get("questions", [])
        ]

        warnings = list(payload.get("warnings", []))
        warnings.append("Admin should review extracted questions and answers before saving to Postgres.")
        if len(text) > MAX_EXAM_TEXT_CHARS:
            warnings.append("PDF text was truncated before AI extraction; split the PDF for better accuracy.")

        return ExtractExamResponse(
            exam_id=exam_id,
            subject=subject,
            profile=profile,
            question_count=len(questions),
            warnings=warnings,
            questions=questions,
        )


def _extract_pdf_text(pdf_bytes: bytes) -> str:
    try:
        reader = PdfReader(BytesIO(pdf_bytes))
        pages = [page.extract_text() or "" for page in reader.pages]
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=f"Could not read PDF: {exc}",
        ) from exc
    return "\n\n".join(page.strip() for page in pages if page.strip()).strip()


def _build_messages(
    *,
    exam_id: str | None,
    subject: str | None,
    grade_level: int | None,
    profile: str,
    extracted_text: str,
) -> list[dict[str, str]]:
    system = """You extract Vietnamese high-school exam questions from raw PDF text.
Return ONLY valid JSON. Do not wrap in Markdown.
The JSON must match this shape:
{
  "warnings": ["..."],
  "questions": [
    {
      "examId": "string-or-null",
      "questionType": "MULTIPLE_CHOICE|TRUE_FALSE|SHORT_ANSWER",
      "paperPart": "PART_I|PART_II|PART_III",
      "content": "question content",
      "orderIndex": 1,
      "score": 0.25,
      "correctAnswer": null,
      "options": [{"content": "A. ...", "correct": false, "orderIndex": 1}]
    }
  ]
}

Rules:
- Use Spring Boot enum values exactly.
- PART_I usually maps to MULTIPLE_CHOICE with one correct option.
- PART_II usually maps to TRUE_FALSE with 4 statements/options.
- PART_III usually maps to SHORT_ANSWER with correctAnswer if available.
- If answer key is missing, set all option correct=false and add a warning.
- Normalize every mathematical expression to LaTeX.
- Inline formulas must use `\\(...\\)`, for example `\\(f'(x)=3x^2-3\\)`.
- Display formulas may use `\\[...\\]` only when the formula is long.
- Because the output is JSON, every LaTeX backslash must be escaped as `\\\\`.
- Example JSON string: `"content": "Cau 1. Tinh dao ham cua \\\\(y=x^2\\\\)."`
- Fractions, roots, powers, limits, integrals, intervals, vectors, matrices, and systems must be LaTeX.
- Keep Vietnamese explanatory text as normal text; only math symbols/expressions become LaTeX.
- Do not use Markdown math fences or code blocks.
- Do not invent questions that are not in the PDF text.
"""
    user = f"""Metadata:
exam_id={exam_id}
subject={subject}
grade_level={grade_level}
profile={profile}

Raw PDF text:
{extracted_text}
"""
    return [{"role": "system", "content": system}, {"role": "user", "content": user}]


def _parse_json_response(text: str) -> dict[str, Any]:
    cleaned = text.strip()
    if cleaned.startswith("```"):
        cleaned = re.sub(r"^```(?:json)?", "", cleaned).strip()
        cleaned = re.sub(r"```$", "", cleaned).strip()
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError as exc:
        repaired = _escape_invalid_json_backslashes(cleaned)
        try:
            return json.loads(repaired)
        except json.JSONDecodeError:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail=f"AI did not return valid JSON: {exc}",
            ) from exc


def _normalize_question(item: dict[str, Any], exam_id: str | None) -> dict[str, Any]:
    question_type = item.get("questionType") or "MULTIPLE_CHOICE"
    paper_part = item.get("paperPart") or _default_part(question_type)
    item["examId"] = item.get("examId") or exam_id
    item["questionType"] = question_type
    item["paperPart"] = paper_part
    item["score"] = float(item.get("score") or _default_score(question_type, paper_part))
    item["options"] = item.get("options") or []
    if question_type == "SHORT_ANSWER":
        item["options"] = []
    return item


def _escape_invalid_json_backslashes(value: str) -> str:
    valid_escapes = {'"', "\\", "/", "b", "f", "n", "r", "t", "u"}
    chars: list[str] = []
    index = 0
    while index < len(value):
        char = value[index]
        if char != "\\":
            chars.append(char)
            index += 1
            continue

        next_char = value[index + 1] if index + 1 < len(value) else ""
        if next_char in valid_escapes:
            chars.append(char)
        else:
            chars.append("\\\\")
        index += 1
    return "".join(chars)


def _default_part(question_type: str) -> str:
    if question_type == "TRUE_FALSE":
        return "PART_II"
    if question_type == "SHORT_ANSWER":
        return "PART_III"
    return "PART_I"


def _default_score(question_type: str, paper_part: str) -> float:
    if paper_part == "PART_II" or question_type == "TRUE_FALSE":
        return 1.0
    if paper_part == "PART_III" or question_type == "SHORT_ANSWER":
        return 0.5
    return 0.25
