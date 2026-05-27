package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.UUID;

public record LearnerExamQuestionOptionResponse(
        UUID id, UUID questionId, String content, Integer orderIndex) {}
