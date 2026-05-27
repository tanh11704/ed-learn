import httpx
from fastapi import HTTPException, status

from app.core.config import settings
from app.providers.base import AiProvider


class OllamaProvider(AiProvider):
    async def embed(self, text: str) -> list[float]:
        payload = {"model": settings.ollama_embedding_model, "prompt": text}
        try:
            async with httpx.AsyncClient(timeout=60) as client:
                response = await client.post(
                    f"{settings.ollama_base_url}/api/embeddings",
                    json=payload,
                )
                response.raise_for_status()
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail=f"Ollama embedding service is unavailable: {exc}",
            ) from exc

        data = response.json()
        embedding = data.get("embedding")
        if not isinstance(embedding, list):
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Ollama returned an invalid embedding payload",
            )
        return embedding

    async def chat(self, messages: list[dict[str, str]]) -> str:
        payload = {
            "model": settings.ollama_chat_model,
            "messages": messages,
            "stream": False,
            "options": {
                "temperature": 0.2,
                "top_p": 0.9,
            },
        }
        try:
            async with httpx.AsyncClient(timeout=120) as client:
                response = await client.post(
                    f"{settings.ollama_base_url}/api/chat",
                    json=payload,
                )
                response.raise_for_status()
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail=f"Ollama chat service is unavailable: {exc}",
            ) from exc

        data = response.json()
        content = data.get("message", {}).get("content")
        if not content:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Ollama returned an empty chat response",
            )
        return str(content).strip()

