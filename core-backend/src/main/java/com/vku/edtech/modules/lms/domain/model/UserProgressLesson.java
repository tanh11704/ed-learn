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
public class UserProgressLesson {
    private final UUID id;
    private final UUID userId;
    private final UUID lessonId;
    private LessonProgressStatus status;
    private Instant completedAt;
    private final Instant createdAt;
    private Instant updatedAt;

    public static UserProgressLesson createInProgress(UUID userId, UUID lessonId) {
        if (userId == null || lessonId == null) {
            throw new InvalidDomainDataException("User ID và Lesson ID không hợp lệ");
        }

        Instant now = Instant.now();
        return UserProgressLesson.builder()
                .id(UUID.randomUUID())
                .userId(userId)
                .lessonId(lessonId)
                .status(LessonProgressStatus.IN_PROGRESS)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    public boolean isCompleted() {
        return this.status == LessonProgressStatus.COMPLETED;
    }

    public void markCompleted() {
        this.status = LessonProgressStatus.COMPLETED;
        this.completedAt = Instant.now();
        this.updatedAt = Instant.now();
    }
}
