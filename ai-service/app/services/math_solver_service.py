from fastapi import HTTPException, UploadFile, status

from app.core.config import settings
from app.providers.gemini_provider import GeminiProvider
from app.schemas.solver import MathSolutionRequestContext, MathSolutionResponse


SUPPORTED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/webp"}


class MathSolverService:
    async def solve_image(
        self,
        *,
        image: UploadFile,
        subject: str,
        grade_level: str | None,
        language: str,
        lesson_id: str | None,
        course_id: str | None,
        mode: str,
    ) -> MathSolutionResponse:
        mime_type = image.content_type or ""
        if mime_type not in SUPPORTED_IMAGE_TYPES:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Only JPG, PNG, and WEBP image files are supported.",
            )

        if mode != "single_question":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="MVP supports only mode=single_question.",
            )

        image_bytes = await image.read()
        if not image_bytes:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Uploaded image is empty.",
            )

        if len(image_bytes) > settings.solver_max_image_bytes:
            max_mb = settings.solver_max_image_bytes / 1024 / 1024
            raise HTTPException(
                status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
                detail=f"Image is too large. Maximum size is {max_mb:.0f} MB.",
            )

        context = MathSolutionRequestContext(
            subject=subject,
            grade_level=grade_level,
            language=language,
            lesson_id=lesson_id,
            course_id=course_id,
            mode=mode,
        )

        provider_name = settings.ai_provider.lower()
        if provider_name != "gemini":
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail=f"AI provider '{settings.ai_provider}' does not support image solving yet.",
            )

        return await GeminiProvider().solve_math_image(
            image_bytes=image_bytes,
            mime_type=mime_type,
            context=context,
        )
