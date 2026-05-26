from pydantic import BaseModel, ConfigDict, Field


class IngestLessonRequest(BaseModel):
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "course_id": "toan-12",
                "lesson_id": "don-dieu-cua-ham-so",
                "course_title": "Toan 12",
                "lesson_title": "Tinh don dieu cua ham so",
                "subject": "Toan",
                "grade_level": 12,
                "source_url": "manual://toan-12/don-dieu-cua-ham-so",
                "text": (
                    "Ham so y = f(x) duoc goi la dong bien tren khoang K neu "
                    "x1 < x2 thi f(x1) < f(x2). Neu f'(x) > 0 tren K thi "
                    "ham so dong bien tren K. Neu f'(x) < 0 tren K thi ham "
                    "so nghich bien tren K. De xet tinh don dieu, ta tim tap "
                    "xac dinh, tinh dao ham, xet dau dao ham va ket luan."
                ),
            }
        }
    )

    course_id: str = Field(
        ...,
        min_length=1,
        description="ID khoa hoc tu PostgreSQL/Spring Boot. Dung de search trong toan course.",
        examples=["toan-12"],
    )
    lesson_id: str = Field(
        ...,
        min_length=1,
        description="ID lesson tu PostgreSQL/Spring Boot. Moi lan ingest cung lesson se replace chunks cu.",
        examples=["don-dieu-cua-ham-so"],
    )
    course_title: str | None = Field(
        default=None,
        description="Ten khoa hoc de hien thi/truy vet source.",
        examples=["Toan 12"],
    )
    lesson_title: str = Field(
        ...,
        description="Ten bai hoc de hien thi trong source tra ve khi chat.",
        examples=["Tinh don dieu cua ham so"],
    )
    subject: str | None = Field(
        default=None,
        description="Mon hoc, vi du Toan/Ly/Hoa. Dung lam metadata.",
        examples=["Toan"],
    )
    grade_level: int | None = Field(
        default=None,
        ge=1,
        le=12,
        description="Khoi lop cua bai hoc, neu co.",
        examples=[12],
    )
    source_url: str | None = Field(
        default=None,
        description="Duong dan file/tai lieu goc de trace, khong bat buoc.",
        examples=["uploads/lessons/don-dieu.pdf"],
    )
    text: str = Field(
        ...,
        min_length=20,
        description="Toan bo noi dung lesson da extract/nhap thu cong. Client khong can tu chia chunk.",
    )


class IngestLessonResponse(BaseModel):
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "course_id": "toan-12",
                "lesson_id": "don-dieu-cua-ham-so",
                "chunk_count": 4,
            }
        }
    )

    course_id: str = Field(..., description="Course da duoc ingest.")
    lesson_id: str = Field(..., description="Lesson da duoc ingest.")
    chunk_count: int = Field(..., description="So chunk da tao va luu vao ChromaDB.")
