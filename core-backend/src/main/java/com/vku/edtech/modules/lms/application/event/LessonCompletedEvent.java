package com.vku.edtech.modules.lms.application.event;

import java.time.Instant;
import java.util.UUID;

public record LessonCompletedEvent(
        UUID userId, UUID lessonId, UUID courseId, Instant completedAt) {}
