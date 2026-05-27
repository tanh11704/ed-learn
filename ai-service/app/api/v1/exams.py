from typing import Annotated

from fastapi import APIRouter, Depends, File, Form, UploadFile

from app.core.security import verify_internal_api_key
from app.schemas.exam_extraction import ExtractExamResponse
from app.services.exam_pdf_service import ExamPdfExtractionService

router = APIRouter(dependencies=[Depends(verify_internal_api_key)])


@router.post(
    "/extract-pdf",
    response_model=ExtractExamResponse,
    summary="Extract exam questions from a PDF",
    description=(
        "Upload mot file PDF de AI service trich xuat cau hoi theo format gan voi "
        "CreateQuestionRequest cua Spring Boot. Client nen cho admin review ket qua "
        "truoc khi goi Spring Boot luu vao Postgres."
    ),
)
async def extract_exam_pdf(
    file: Annotated[UploadFile, File(description="PDF de thi can trich xuat")],
    exam_id: Annotated[str | None, Form(description="UUID exam trong Spring Boot, neu da co")] = None,
    subject: Annotated[str | None, Form(description="Mon thi, vi du Toan/Vat ly/Hoa")] = None,
    grade_level: Annotated[int | None, Form(description="Khoi lop, vi du 12")] = None,
    profile: Annotated[str, Form(description="Cau truc de thi, mac dinh THPT_2026")] = "THPT_2026",
) -> ExtractExamResponse:
    return await ExamPdfExtractionService().extract(
        file=file,
        exam_id=exam_id,
        subject=subject,
        grade_level=grade_level,
        profile=profile,
    )

