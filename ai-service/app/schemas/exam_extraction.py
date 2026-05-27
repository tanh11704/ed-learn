from pydantic import BaseModel, ConfigDict, Field


class ExtractedOption(BaseModel):
    content: str = Field(
        ...,
        description="Noi dung lua chon/dong dung sai. Cong thuc toan nen o LaTeX \\(...\\).",
    )
    correct: bool = Field(..., description="Option dung hay sai.")
    orderIndex: int | None = Field(default=None, description="Thu tu option.")


class ExtractedQuestion(BaseModel):
    examId: str | None = Field(default=None, description="UUID exam trong Spring Boot neu request co truyen.")
    questionType: str = Field(..., description="MULTIPLE_CHOICE, TRUE_FALSE, SHORT_ANSWER.")
    paperPart: str = Field(..., description="PART_I, PART_II, PART_III.")
    content: str = Field(
        ...,
        description="Noi dung cau hoi. Cong thuc toan nen o LaTeX \\(...\\) hoac \\[...\\].",
    )
    orderIndex: int | None = Field(default=None, description="Thu tu cau hoi.")
    score: float = Field(..., description="Diem cau hoi theo cau truc de.")
    correctAnswer: str | None = Field(
        default=None,
        description="Dap an chuan cho SHORT_ANSWER. Cong thuc toan nen o LaTeX neu can.",
    )
    options: list[ExtractedOption] = Field(default_factory=list, description="Danh sach options neu co.")


class ExtractExamResponse(BaseModel):
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "exam_id": "100ab6bd-ed08-4bfa-af40-d00977051d70",
                "subject": "Toan",
                "profile": "THPT_2026",
                "question_count": 2,
                "warnings": ["Admin should review extracted answers before saving."],
                "questions": [
                    {
                        "examId": "100ab6bd-ed08-4bfa-af40-d00977051d70",
                        "questionType": "MULTIPLE_CHOICE",
                        "paperPart": "PART_I",
                        "content": "Cau 1. Ham so nao dong bien tren R?",
                        "orderIndex": 1,
                        "score": 0.25,
                        "correctAnswer": None,
                        "options": [
                            {"content": "A. y = x", "correct": True, "orderIndex": 1},
                            {"content": "B. y = -x", "correct": False, "orderIndex": 2},
                        ],
                    }
                ],
            }
        }
    )

    exam_id: str | None = Field(default=None, description="Exam ID da truyen len.")
    subject: str | None = Field(default=None, description="Mon thi.")
    profile: str = Field(..., description="Profile cau truc de.")
    question_count: int = Field(..., description="So cau hoi trich xuat duoc.")
    warnings: list[str] = Field(default_factory=list, description="Canh bao can review.")
    questions: list[ExtractedQuestion] = Field(..., description="Danh sach cau hoi format gan voi Spring Boot.")
