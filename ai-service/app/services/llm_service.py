from app.providers.factory import get_ai_provider


class LlmService:
    async def chat(self, messages: list[dict[str, str]]) -> str:
        return await get_ai_provider().chat(messages)
