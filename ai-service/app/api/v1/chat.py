from fastapi import APIRouter, Depends

from app.core.security import verify_internal_api_key
from app.schemas.chat import ChatRequest, ChatResponse
from app.services.chat_service import ChatService

router = APIRouter(dependencies=[Depends(verify_internal_api_key)])


@router.post(
    "",
    response_model=ChatResponse,
    summary="Chat with lesson/course RAG",
    description=(
        "Hoi dap dua tren noi dung da ingest trong ChromaDB. Neu request co lesson_id, "
        "service chi search trong lesson do. Neu khong co lesson_id, service search "
        "trong toan bo course_id."
    ),
)
async def chat(request: ChatRequest) -> ChatResponse:
    return await ChatService().answer(request)
