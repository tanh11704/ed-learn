package com.vku.edtech.modules.exams.presentation.dto.response;

import java.time.Instant;
import java.util.UUID;

public record ExamQuestionOptionResponse(
        UUID id,
        UUID questionId,
        String content,
        boolean correct,
        Integer orderIndex,
        Instant createdAt,
        Instant updatedAt) {}
