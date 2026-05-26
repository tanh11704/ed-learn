from abc import ABC, abstractmethod


class AiProvider(ABC):
    @abstractmethod
    async def embed(self, text: str) -> list[float]:
        raise NotImplementedError

    @abstractmethod
    async def chat(self, messages: list[dict[str, str]]) -> str:
        raise NotImplementedError

