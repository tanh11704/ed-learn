from typing import Annotated

from fastapi import APIRouter, Depends, File, Form, UploadFile

from app.core.security import require_ai_service_key
from app.schemas.solver import MathSolutionResponse
from app.services.math_solver_service import MathSolverService


router = APIRouter(dependencies=[Depends(require_ai_service_key)])


@router.post(
    "/solve-image",
    response_model=MathSolutionResponse,
    summary="Solve one cropped math question image",
    description=(
        "Stateless MVP endpoint for the mobile AI Solver. Upload one cropped image "
        "containing one math question. The service does not save the image or result; "
        "it calls Gemini Vision and returns a structured Vietnamese solution with LaTeX."
    ),
)
async def solve_image(
    image: Annotated[
        UploadFile,
        File(description="Required image file. Supported content types: image/jpeg, image/png, image/webp."),
    ],
    subject: Annotated[str, Form(description="Subject name. Default: math.")] = "math",
    grade_level: Annotated[str | None, Form(description="Optional grade level, e.g. 12.")] = None,
    language: Annotated[str, Form(description="Response language. Default: vi.")] = "vi",
    lesson_id: Annotated[str | None, Form(description="Optional lesson id if user is inside a lesson.")] = None,
    course_id: Annotated[str | None, Form(description="Optional course id if user is inside a course.")] = None,
    mode: Annotated[str, Form(description="Solver mode. MVP supports single_question.")] = "single_question",
) -> MathSolutionResponse:
    return await MathSolverService().solve_image(
        image=image,
        subject=subject,
        grade_level=grade_level,
        language=language,
        lesson_id=lesson_id,
        course_id=course_id,
        mode=mode,
    )
