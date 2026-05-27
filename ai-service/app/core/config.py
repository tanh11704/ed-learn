from functools import lru_cache
from pathlib import Path

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


BASE_DIR = Path(__file__).resolve().parents[2]
ENV_FILE = BASE_DIR / ".env"


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=ENV_FILE,
        env_file_encoding="utf-8",
        env_ignore_empty=True,
        case_sensitive=False,
        extra="ignore",
    )

    app_name: str = "EdLearn AI Service"
    environment: str = "local"
    ai_service_api_key: str | None = None
    cors_allow_origins_raw: str = Field(default="*", alias="CORS_ALLOW_ORIGINS")

    chroma_host: str = "localhost"
    chroma_port: int = 8000
    chroma_collection: str = "edlearn_lessons"

    ai_provider: str = "gemini"

    gemini_api_key: str | None = None
    gemini_base_url: str = "https://generativelanguage.googleapis.com/v1beta"
    gemini_chat_model: str = "gemini-2.5-flash"
    gemini_embedding_model: str = "gemini-embedding-001"
    gemini_vision_model: str | None = None
    gemini_timeout_seconds: float = 60.0
    gemini_max_retries: int = 2

    ollama_base_url: str = "http://localhost:11434"
    ollama_chat_model: str = "qwen3:8b"
    ollama_embedding_model: str = "nomic-embed-text"

    rag_top_k: int = 5
    rag_min_score: float = 0.2
    enable_fallback_answer: bool = True

    solver_max_image_bytes: int = 8 * 1024 * 1024

    @property
    def cors_allow_origins(self) -> list[str]:
        if self.cors_allow_origins_raw.strip() == "*":
            return ["*"]
        return [
            origin.strip()
            for origin in self.cors_allow_origins_raw.split(",")
            if origin.strip()
        ]

    @property
    def solver_model(self) -> str:
        return self.gemini_vision_model or self.gemini_chat_model


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
