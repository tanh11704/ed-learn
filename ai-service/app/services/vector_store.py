from typing import Any

import chromadb
from fastapi import HTTPException, status

from app.core.config import settings
from app.schemas.chat import SourceChunk


class VectorStore:
    def __init__(self) -> None:
        self.client = chromadb.HttpClient(host=settings.chroma_host, port=settings.chroma_port)
        self.collection = self.client.get_or_create_collection(
            name=settings.chroma_collection,
            metadata={"hnsw:space": "cosine"},
        )

    def upsert_lesson_chunks(
        self,
        *,
        course_id: str,
        lesson_id: str,
        course_title: str | None,
        lesson_title: str,
        subject: str | None,
        grade_level: int | None,
        source_url: str | None,
        chunks: list[str],
        embeddings: list[list[float]],
    ) -> int:
        if len(chunks) != len(embeddings):
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Chunk and embedding count mismatch",
            )

        self.collection.delete(
            where={"$and": [{"course_id": course_id}, {"lesson_id": lesson_id}]}
        )

        ids = [f"lesson:{lesson_id}:chunk:{index}" for index in range(len(chunks))]
        metadatas: list[dict[str, str | int]] = []
        for index in range(len(chunks)):
            metadata: dict[str, str | int] = {
                "course_id": course_id,
                "lesson_id": lesson_id,
                "lesson_title": lesson_title,
                "chunk_index": index,
            }
            if course_title:
                metadata["course_title"] = course_title
            if subject:
                metadata["subject"] = subject
            if grade_level:
                metadata["grade_level"] = grade_level
            if source_url:
                metadata["source_url"] = source_url
            metadatas.append(metadata)

        self.collection.upsert(
            ids=ids,
            documents=chunks,
            embeddings=embeddings,
            metadatas=metadatas,
        )
        return len(chunks)

    def query(
        self,
        *,
        course_id: str,
        lesson_id: str | None,
        embedding: list[float],
        top_k: int,
    ) -> list[SourceChunk]:
        where: dict[str, Any]
        if lesson_id:
            where = {"$and": [{"course_id": course_id}, {"lesson_id": lesson_id}]}
        else:
            where = {"course_id": course_id}

        result = self.collection.query(
            query_embeddings=[embedding],
            n_results=top_k,
            where=where,
            include=["documents", "metadatas", "distances"],
        )

        ids = result.get("ids", [[]])[0]
        documents = result.get("documents", [[]])[0]
        metadatas = result.get("metadatas", [[]])[0]
        distances = result.get("distances", [[]])[0]

        sources: list[SourceChunk] = []
        for chunk_id, document, metadata, distance in zip(ids, documents, metadatas, distances):
            score = max(0.0, 1.0 - float(distance))
            sources.append(
                SourceChunk(
                    chunk_id=chunk_id,
                    course_id=str(metadata.get("course_id", "")),
                    lesson_id=str(metadata.get("lesson_id", "")),
                    lesson_title=metadata.get("lesson_title"),
                    score=score,
                    text=document,
                )
            )
        return sources
