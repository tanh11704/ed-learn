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
    private boolean isPreview;
    private boolean isDeleted;
    private final Instant createdAt;
    private Instant updatedAt;

    public static Lesson create(
            UUID chapterId, String title, Integer orderIndex, boolean isPreview) {
        if (chapterId == null) {
            throw new InvalidDomainDataException("Chapter ID không hợp lệ");
        }
        validateTitle(title);

        return Lesson.builder()
                .id(UUID.randomUUID())
                .chapterId(chapterId)
                .title(title.trim())
                .orderIndex(orderIndex)
                .isPreview(isPreview)
                .isDeleted(false)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public void updateDetails(UUID chapterId, String title, Integer orderIndex, Boolean isPreview) {
        if (chapterId != null) {
            this.chapterId = chapterId;
        }
        if (title != null) {
            validateTitle(title);
            this.title = title.trim();
        }
        if (orderIndex != null && orderIndex > 0) {
            this.orderIndex = orderIndex;
        }
        if (isPreview != null) {
            this.isPreview = isPreview;
        }
        this.updatedAt = Instant.now();
    }

    public void markAsDeleted() {
        this.isDeleted = true;
        this.updatedAt = Instant.now();
    }

    public void updateVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
        this.updatedAt = Instant.now();
    }

    public void updatePdfUrl(String pdfUrl) {
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

    private static void validateTitle(String title) {
        if (title == null || title.isBlank()) {
            throw new InvalidDomainDataException("Tiêu đề bài học không được để trống");
        }
        if (title.length() > 255) {
            throw new InvalidDomainDataException("Tiêu đề bài học tối đa 255 ký tự");
        }
    }
}
