package com.vku.edtech.modules.exams.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record ExamQuestionResponse(
        UUID id,
        UUID examId,
        String content,
        String imageUrl,
        Integer orderIndex,
        List<ExamQuestionOptionResponse> options,
        Instant createdAt,
        Instant updatedAt) {}
