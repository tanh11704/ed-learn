package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.UUID;

public record LearnerExamQuestionOptionReviewResponse(
        UUID id, UUID questionId, String content, boolean correct, Integer orderIndex) {}
