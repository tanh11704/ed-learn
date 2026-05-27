from fastapi import HTTPException

from app.core.config import settings
from app.schemas.chat import ChatRequest, ChatResponse, SourceChunk
from app.services.embedding_service import EmbeddingService
from app.services.llm_service import LlmService
from app.services.prompt_service import build_chat_messages
from app.services.vector_store import VectorStore


class ChatService:
    def __init__(self) -> None:
        self.embedding_service = EmbeddingService()
        self.llm_service = LlmService()

    async def answer(self, request: ChatRequest) -> ChatResponse:
        question_embedding = await self.embedding_service.embed(request.question)
        sources = VectorStore().query(
            course_id=request.course_id,
            lesson_id=request.lesson_id,
            embedding=question_embedding,
            top_k=settings.rag_top_k,
        )
        filtered_sources = [
            source for source in sources if source.score >= settings.rag_min_score
        ]

        if not filtered_sources:
            return ChatResponse(
                answer="Minh chua du du lieu trong bai hoc de tra loi chinh xac. Em hay chon dung bai hoc hoac hoi cau lien quan hon den noi dung bai.",
                sources=[],
                confidence=0.0,
                used_fallback=True,
            )

        messages = build_chat_messages(
            question=request.question,
            sources=filtered_sources,
            chat_history=request.chat_history,
        )

        try:
            answer = await self.llm_service.chat(messages)
            return ChatResponse(
                answer=answer,
                sources=filtered_sources,
                confidence=_confidence(filtered_sources),
            )
        except HTTPException:
            if not settings.enable_fallback_answer:
                raise
            return ChatResponse(
                answer=_fallback_answer(request.question, filtered_sources),
                sources=filtered_sources,
                confidence=_confidence(filtered_sources),
                used_fallback=True,
            )


def _confidence(sources: list[SourceChunk]) -> float:
    if not sources:
        return 0.0
    return round(sum(source.score for source in sources) / len(sources), 3)


def _fallback_answer(question: str, sources: list[SourceChunk]) -> str:
    context = "\n".join(f"- {source.text}" for source in sources[:3])
    return (
        "Minh da tim thay mot so doan lien quan trong bai hoc, nhung LLM hien chua san sang. "
        "Em co the doc cac y sau de tu tra loi cau hoi:\n"
        f"{context}\n\n"
        f"Cau hoi cua em: {question}"
    )

