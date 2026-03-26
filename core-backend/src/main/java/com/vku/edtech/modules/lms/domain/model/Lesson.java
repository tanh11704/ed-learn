package com.vku.edtech.modules.lms.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class Lesson {
    private final UUID id;
    private UUID chapterId;
    private String title;
    private String videoUrl;
    private String pdfUrl;
    private Integer orderIndex;
    private final Instant createdAt;
    private Instant updatedAt;

    public static Lesson createNew(UUID chapterId, String title, Integer orderIndex) {
        if (title == null || title.isBlank()) {
            throw new InvalidDomainDataException("Tiêu đề bài học không được để trống");
        }
        return Lesson.builder()
                .id(UUID.randomUUID())
                .chapterId(chapterId)
                .title(title)
                .orderIndex(orderIndex)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public void updateVideoMedia(String videoUrl) {
        this.videoUrl = videoUrl;
        this.updatedAt = Instant.now();
    }

    public void updatePdfMedia(String pdfUrl) {
        this.pdfUrl = pdfUrl;
        this.updatedAt = Instant.now();
    }

    public void moveToChapter(UUID newChapterId, Integer newOrderIndex) {
        if (newChapterId == null) {
            throw new InvalidDomainDataException("ID của chương mới không hợp lệ");
        }
        this.chapterId = newChapterId;
        this.orderIndex = newOrderIndex;
        this.updatedAt = Instant.now();
    }
}
