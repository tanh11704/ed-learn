from abc import ABC, abstractmethod

from app.schemas.solver import MathSolutionRequestContext, MathSolutionResponse


class AiProvider(ABC):
    @abstractmethod
    async def embed(self, text: str) -> list[float]:
        raise NotImplementedError

    @abstractmethod
    async def chat(self, messages: list[dict[str, str]]) -> str:
        raise NotImplementedError


class VisionSolverProvider(ABC):
    @abstractmethod
    async def solve_math_image(
        self,
        *,
        image_bytes: bytes,
        mime_type: str,
        context: MathSolutionRequestContext,
    ) -> MathSolutionResponse:
        raise NotImplementedError
