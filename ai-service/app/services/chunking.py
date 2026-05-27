import re


def split_text(text: str, chunk_size: int = 900, overlap: int = 120) -> list[str]:
    normalized = re.sub(r"\s+", " ", text).strip()
    if not normalized:
        return []

    chunks: list[str] = []
    start = 0
    while start < len(normalized):
        end = min(start + chunk_size, len(normalized))
        window = normalized[start:end]

        if end < len(normalized):
            boundary = max(window.rfind(". "), window.rfind("? "), window.rfind("! "), window.rfind("; "))
            if boundary > chunk_size * 0.55:
                end = start + boundary + 1
                window = normalized[start:end]

        chunks.append(window.strip())
        if end == len(normalized):
            break
        start = max(0, end - overlap)

    return chunks

