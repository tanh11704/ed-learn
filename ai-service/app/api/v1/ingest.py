from fastapi import APIRouter, Depends

from app.core.security import verify_internal_api_key
from app.schemas.ingest import IngestLessonRequest, IngestLessonResponse
from app.services.ingest_service import IngestService

router = APIRouter(dependencies=[Depends(verify_internal_api_key)])


@router.post(
    "/lesson",
    response_model=IngestLessonResponse,
    summary="Ingest one lesson into RAG",
    description=(
        "Client gui toan bo noi dung lesson da co text. Service se replace chunks cu "
        "cua cung course_id + lesson_id, tu chia chunk, tao embedding bang provider "
        "da cau hinh va luu vao ChromaDB. Client khong can gui chunk/vector."
    ),
)
async def ingest_lesson(request: IngestLessonRequest) -> IngestLessonResponse:
    return await IngestService().ingest_lesson(request)
