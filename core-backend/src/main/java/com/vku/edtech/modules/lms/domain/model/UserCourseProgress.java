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
public class UserCourseProgress {
    private final UUID id;
    private final UUID userId;
    private final UUID courseId;
    private int progressPercent;
    private UUID lastAccessedLessonId;
    private final Instant createdAt;
    private Instant updatedAt;

    public static UserCourseProgress create(UUID userId, UUID courseId) {
        if (userId == null || courseId == null) {
            throw new InvalidDomainDataException("User ID và Course ID không hợp lệ");
        }

        Instant now = Instant.now();
        return UserCourseProgress.builder()
                .id(UUID.randomUUID())
                .userId(userId)
                .courseId(courseId)
                .progressPercent(0)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    public void updateProgress(int progressPercent, UUID lastAccessedLessonId) {
        if (progressPercent < 0 || progressPercent > 100) {
            throw new InvalidDomainDataException(
                    "Progress percent phải nằm trong khoảng 0 đến 100");
        }

        this.progressPercent = progressPercent;
        this.lastAccessedLessonId = lastAccessedLessonId;
        this.updatedAt = Instant.now();
    }
}
