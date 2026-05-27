from pydantic import BaseModel, Field, field_validator


class MathSolutionRequestContext(BaseModel):
    subject: str = Field(default="math", examples=["math"])
    grade_level: str | None = Field(default=None, examples=["12"])
    language: str = Field(default="vi", examples=["vi"])
    lesson_id: str | None = Field(default=None, examples=["don-dieu-cua-ham-so"])
    course_id: str | None = Field(default=None, examples=["toan-12"])
    mode: str = Field(default="single_question", examples=["single_question"])


class MathSolutionStep(BaseModel):
    title: str = Field(examples=["Buoc 1"])
    explanation: str = Field(examples=["Tinh dao ham cua ham so."])
    latex: str = Field(default="", examples=[r"\(f'(x)=2x-3\)"])


class MathSolutionResponse(BaseModel):
    detected_question: str = Field(
        default="",
        description="Question text read from the uploaded image. Use LaTeX for formulas.",
        examples=[r"Tim khoang dong bien cua ham so \(y=x^3-3x+1\)."],
    )
    answer: str = Field(
        default="",
        description="Final answer. For multiple-choice questions, include option letter when available.",
        examples=[r"Ham so dong bien tren \((-\infty,-1)\) va \((1,+\infty)\)."],
    )
    steps: list[MathSolutionStep] = Field(default_factory=list)
    topic_tags: list[str] = Field(default_factory=list, examples=[["don dieu ham so"]])
    confidence: float = Field(default=0.0, ge=0.0, le=1.0)
    needs_clarification: bool = Field(
        default=False,
        description="True when image is unreadable, cropped incorrectly, ambiguous, or contains multiple questions.",
    )
    warnings: list[str] = Field(default_factory=list)
    model: str = Field(default="gemini")

    @field_validator("confidence", mode="before")
    @classmethod
    def normalize_confidence(cls, value: float | int | str | None) -> float:
        if value is None:
            return 0.0
        number = float(value)
        if number > 1:
            number = number / 100
        return max(0.0, min(1.0, number))
