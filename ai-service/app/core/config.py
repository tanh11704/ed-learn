from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    app_name: str = "EdLearn AI Service"
    environment: str = "local"
    ai_service_api_key: str | None = None

    chroma_host: str = "localhost"
    chroma_port: int = 8000
    chroma_collection: str = "edlearn_lessons"

    ai_provider: str = "gemini"

    gemini_api_key: str | None = None
    gemini_base_url: str = "https://generativelanguage.googleapis.com/v1beta"
    gemini_chat_model: str = "gemini-2.5-flash"
    gemini_embedding_model: str = "gemini-embedding-001"

    ollama_base_url: str = "http://localhost:11434"
    ollama_chat_model: str = "qwen3:8b"
    ollama_embedding_model: str = "nomic-embed-text"

    rag_top_k: int = 5
    rag_min_score: float = 0.2
    enable_fallback_answer: bool = True


settings = Settings()
