from app.schemas.ingest import IngestLessonRequest, IngestLessonResponse
from app.services.chunking import split_text
from app.services.embedding_service import EmbeddingService
from app.services.vector_store import VectorStore


class IngestService:
    def __init__(self) -> None:
        self.embedding_service = EmbeddingService()

    async def ingest_lesson(self, request: IngestLessonRequest) -> IngestLessonResponse:
        chunks = split_text(request.text)
        embeddings = [await self.embedding_service.embed(chunk) for chunk in chunks]
        chunk_count = VectorStore().upsert_lesson_chunks(
            course_id=request.course_id,
            lesson_id=request.lesson_id,
            course_title=request.course_title,
            lesson_title=request.lesson_title,
            subject=request.subject,
            grade_level=request.grade_level,
            source_url=request.source_url,
            chunks=chunks,
            embeddings=embeddings,
        )
        return IngestLessonResponse(
            course_id=request.course_id,
            lesson_id=request.lesson_id,
            chunk_count=chunk_count,
        )

