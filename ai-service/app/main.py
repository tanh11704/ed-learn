from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.router import api_router
from app.core.config import settings


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.app_name,
        version="0.1.0",
        description=(
            "RAG chatbot service for EdLearn lessons and courses.\n\n"
            "Direct client flow:\n"
            "1. Call `POST /api/v1/ingest/lesson` to load lesson text into ChromaDB.\n"
            "2. Call `POST /api/v1/chat` with `course_id`, optional `lesson_id`, and `question`.\n\n"
            "All protected endpoints require header `X-AI-Service-Key` when `AI_SERVICE_API_KEY` is configured."
        ),
        contact={"name": "EdLearn Team"},
        openapi_tags=[
            {
                "name": "ingest",
                "description": "Load lesson text into the vector database for RAG retrieval.",
            },
            {
                "name": "chat",
                "description": "Ask questions against ingested lesson/course knowledge.",
            },
        ],
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.get("/health")
    async def health() -> dict[str, str]:
        return {"status": "ok", "service": settings.app_name}

    app.include_router(api_router, prefix="/api/v1")
    return app


app = create_app()
