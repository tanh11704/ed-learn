from pydantic import BaseModel, ConfigDict, Field


class ChatMessage(BaseModel):
    role: str = Field(
        ...,
        pattern="^(user|assistant)$",
        description="Vai tro tin nhan trong lich su chat.",
        examples=["user"],
    )
    content: str = Field(
        ...,
        min_length=1,
        description="Noi dung tin nhan.",
        examples=["Don dieu la gi?"],
    )


class ChatRequest(BaseModel):
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "user_id": "student-1",
                "course_id": "toan-12",
                "lesson_id": "don-dieu-cua-ham-so",
                "question": "Vi sao f'(x) > 0 thi ham so dong bien?",
                "chat_history": [
                    {"role": "user", "content": "Don dieu la gi?"},
                    {
                        "role": "assistant",
                        "content": "Don dieu nghia la ham so dong bien hoac nghich bien tren mot khoang.",
                    },
                ],
            }
        }
    )

    user_id: str | None = Field(
        default=None,
        description="ID hoc sinh de logging/phat trien sau. Hien tai khong bat buoc.",
        examples=["student-1"],
    )
    course_id: str = Field(
        ...,
        min_length=1,
        description="ID course can chat. Neu khong co lesson_id, service search toan course.",
        examples=["toan-12"],
    )
    lesson_id: str | None = Field(
        default=None,
        description="ID lesson hien tai. Neu co, service chi search trong lesson nay.",
        examples=["don-dieu-cua-ham-so"],
    )
    question: str = Field(
        ...,
        min_length=1,
        description="Cau hoi cua hoc sinh.",
        examples=["Vi sao f'(x) > 0 thi ham so dong bien?"],
    )
    chat_history: list[ChatMessage] = Field(
        default_factory=list,
        description="Lich su chat gan day. Co the de mang rong.",
    )


class SourceChunk(BaseModel):
    chunk_id: str = Field(..., description="ID chunk trong ChromaDB.")
    course_id: str = Field(..., description="Course cua chunk.")
    lesson_id: str = Field(..., description="Lesson cua chunk.")
    lesson_title: str | None = Field(default=None, description="Ten lesson cua chunk.")
    section_id: str | None = Field(default=None, description="ID section neu chunk den tu section-based ingest.")
    section_title: str | None = Field(default=None, description="Tieu de section neu co.")
    section_type: str | None = Field(default=None, description="Loai section: theory, method, example...")
    score: float = Field(..., description="Do gan nghia voi cau hoi. Gan 1 la lien quan hon.")
    text: str = Field(..., description="Noi dung chunk duoc dung lam ngu canh.")


class ChatResponse(BaseModel):
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "answer": "Neu f'(x) > 0 tren khoang K thi khi x tang, gia tri f(x) cung tang, nen ham so dong bien tren K.",
                "sources": [
                    {
                        "chunk_id": "lesson:don-dieu-cua-ham-so:chunk:0",
                        "course_id": "toan-12",
                        "lesson_id": "don-dieu-cua-ham-so",
                        "lesson_title": "Tinh don dieu cua ham so",
                        "section_id": "method",
                        "section_title": "Quy trinh lam bai",
                        "section_type": "method",
                        "score": 0.84,
                        "text": "Neu f'(x) > 0 tren K thi ham so dong bien tren K.",
                    }
                ],
                "confidence": 0.84,
                "used_fallback": False,
            }
        }
    )

    answer: str = Field(..., description="Cau tra loi da sinh tu LLM dua tren retrieved sources.")
    sources: list[SourceChunk] = Field(..., description="Cac chunk lien quan da duoc dung lam context.")
    confidence: float = Field(..., description="Diem trung binh tu sources da retrieve.")
    used_fallback: bool = Field(
        default=False,
        description="True neu LLM loi va service tra fallback tu context.",
    )
