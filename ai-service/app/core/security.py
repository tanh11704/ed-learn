from fastapi import Depends, HTTPException, status
from fastapi.security import APIKeyHeader

from app.core.config import settings

ai_service_key_header = APIKeyHeader(name="X-AI-Service-Key", auto_error=False)


async def verify_internal_api_key(
    x_ai_service_key: str | None = Depends(ai_service_key_header),
) -> None:
    if not settings.ai_service_api_key:
        return
    if x_ai_service_key != settings.ai_service_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid AI service key",
        )
