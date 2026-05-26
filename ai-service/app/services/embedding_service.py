from app.providers.factory import get_ai_provider


class EmbeddingService:
    async def embed(self, text: str) -> list[float]:
        return await get_ai_provider().embed(text)
