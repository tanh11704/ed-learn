from fastapi import HTTPException, status

from app.core.config import settings
from app.providers.base import AiProvider
from app.providers.gemini_provider import GeminiProvider
from app.providers.ollama_provider import OllamaProvider


def get_ai_provider() -> AiProvider:
    provider = settings.ai_provider.strip().lower()
    if provider == "gemini":
        return GeminiProvider()
    if provider == "ollama":
        return OllamaProvider()
    raise HTTPException(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail=f"Unsupported AI_PROVIDER: {settings.ai_provider}",
    )

