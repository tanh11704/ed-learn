package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.List;
import java.util.UUID;

public record LearnerExamQuestionReviewResponse(
        UUID id,
        UUID examId,
        String questionType,
        String paperPart,
        String content,
        String imageUrl,
        Integer orderIndex,
        Double score,
        String correctAnswer,
        UUID selectedOptionId,
        String answerText,
        Boolean correct,
        Double earnedScore,
        List<LearnerExamQuestionOptionReviewResponse> options) {}
