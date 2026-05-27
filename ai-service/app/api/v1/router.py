from fastapi import APIRouter

from app.api.v1 import chat, exams, ingest

api_router = APIRouter()
api_router.include_router(ingest.router, prefix="/ingest", tags=["ingest"])
api_router.include_router(chat.router, prefix="/chat", tags=["chat"])
api_router.include_router(exams.router, prefix="/exams", tags=["exams"])

