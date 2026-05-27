from app.schemas.chat import ChatMessage, SourceChunk


SYSTEM_PROMPT = """Ban la gia su AI cua EdLearn cho hoc sinh THPT Viet Nam.
Nhiem vu: giai thich bai hoc, goi y tung buoc, giup hoc sinh tu hieu van de.

Quy tac bat buoc:
- Chi tra loi dua tren NGU CANH BAI HOC duoc cung cap.
- Neu ngu canh khong du, noi ro: "Minh chua du du lieu trong bai hoc de tra loi chinh xac."
- Khong bia them kien thuc ngoai tai lieu neu cau hoi yeu cau noi dung cu the cua bai hoc.
- Giai thich ngan gon, bang tieng Viet, phu hop hoc sinh THPT.
- Neu hoc sinh hoi bai tap, uu tien goi y tung buoc truoc, khong chi dua dap an cuoi.
- Cuoi cau tra loi nen co 1 cau hoi goi mo de hoc sinh tu kiem tra lai.
"""


def build_chat_messages(
    *,
    question: str,
    sources: list[SourceChunk],
    chat_history: list[ChatMessage],
) -> list[dict[str, str]]:
    context = "\n\n".join(
        _format_source(index, source)
        for index, source in enumerate(sources)
    )
    history_text = "\n".join(
        f"{message.role}: {message.content}" for message in chat_history[-6:]
    )

    user_prompt = f"""NGU CANH BAI HOC:
{context}

LICH SU CHAT GAN DAY:
{history_text or "(khong co)"}

CAU HOI CUA HOC SINH:
{question}

Hay tra loi theo dung quy tac."""

    return [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user_prompt},
    ]


def _format_source(index: int, source: SourceChunk) -> str:
    title_parts = [source.lesson_title or source.lesson_id]
    if source.section_title:
        title_parts.append(source.section_title)
    if source.section_type:
        title_parts.append(source.section_type)
    return f"[Nguon {index + 1} - {' / '.join(title_parts)}]\n{source.text}"
