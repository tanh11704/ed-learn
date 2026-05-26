from pydantic import BaseModel, ConfigDict, Field, model_validator


class IngestLessonSection(BaseModel):
    section_id: str = Field(
        ...,
        min_length=1,
        description="ID section duy nhat trong lesson, vi du definition/method/example-basic.",
        examples=["definition"],
    )
    section_title: str = Field(
        ...,
        min_length=1,
        description="Tieu de section de dua vao source/context.",
        examples=["Dinh nghia"],
    )
    section_type: str = Field(
        ...,
        min_length=1,
        description="Loai section: theory, method, example, mistake, faq, exercise...",
        examples=["theory"],
    )
    text: str = Field(
        ...,
        min_length=20,
        description="Noi dung section. Neu dai, service se chia tiep thanh nhieu chunk.",
    )


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
                "sections": [
                    {
                        "section_id": "definition",
                        "section_title": "Dinh nghia",
                        "section_type": "theory",
                        "text": "Ham so y = f(x) duoc goi la dong bien tren khoang K neu x1 < x2 thi f(x1) < f(x2). Ham so nghich bien neu x1 < x2 thi f(x1) > f(x2).",
                    },
                    {
                        "section_id": "method",
                        "section_title": "Quy trinh lam bai",
                        "section_type": "method",
                        "text": "De xet tinh don dieu, ta tim tap xac dinh, tinh dao ham, giai f'(x)=0, lap bang xet dau va ket luan khoang dong bien nghich bien.",
                    },
                ],
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
    text: str | None = Field(
        default=None,
        min_length=20,
        description="Noi dung lesson dang legacy. Dung khi client chua chia sections.",
    )
    sections: list[IngestLessonSection] = Field(
        default_factory=list,
        description="Danh sach section cua lesson. Nen dung cho production de retrieval chinh xac hon.",
    )

    @model_validator(mode="after")
    def require_text_or_sections(self) -> "IngestLessonRequest":
        if not self.text and not self.sections:
            raise ValueError("Either text or sections must be provided")
        return self


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
