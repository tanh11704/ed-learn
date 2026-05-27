package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.List;

public record LearnerExamAttemptReviewResponse(
        ExamAttemptResponse attempt,
        LearnerExamSummaryResponse exam,
        List<LearnerExamQuestionReviewResponse> questions) {}
