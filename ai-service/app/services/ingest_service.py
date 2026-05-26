from app.schemas.ingest import IngestLessonRequest, IngestLessonResponse
from app.services.chunking import split_text
from app.services.embedding_service import EmbeddingService
from app.services.vector_store import VectorStore


class IngestService:
    def __init__(self) -> None:
        self.embedding_service = EmbeddingService()

    async def ingest_lesson(self, request: IngestLessonRequest) -> IngestLessonResponse:
        chunk_records = _build_chunk_records(request)
        embeddings = [
            await self.embedding_service.embed(record["text"]) for record in chunk_records
        ]
        chunk_count = VectorStore().upsert_lesson_chunks(
            course_id=request.course_id,
            lesson_id=request.lesson_id,
            course_title=request.course_title,
            lesson_title=request.lesson_title,
            subject=request.subject,
            grade_level=request.grade_level,
            source_url=request.source_url,
            chunk_records=chunk_records,
            embeddings=embeddings,
        )
        return IngestLessonResponse(
            course_id=request.course_id,
            lesson_id=request.lesson_id,
            chunk_count=chunk_count,
        )


def _build_chunk_records(request: IngestLessonRequest) -> list[dict[str, str | int | None]]:
    records: list[dict[str, str | int | None]] = []

    if request.sections:
        global_index = 0
        for section in request.sections:
            section_chunks = split_text(section.text)
            for section_chunk_index, chunk in enumerate(section_chunks):
                records.append(
                    {
                        "text": chunk,
                        "chunk_index": global_index,
                        "section_chunk_index": section_chunk_index,
                        "section_id": section.section_id,
                        "section_title": section.section_title,
                        "section_type": section.section_type,
                    }
                )
                global_index += 1
        return records

    for index, chunk in enumerate(split_text(request.text or "")):
        records.append(
            {
                "text": chunk,
                "chunk_index": index,
                "section_chunk_index": None,
                "section_id": None,
                "section_title": None,
                "section_type": None,
            }
        )
    return records
