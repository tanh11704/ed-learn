package com.vku.edtech.modules.exams.presentation.dto.response;

import java.util.List;

public record LearnerExamAttemptResponse(
        ExamAttemptResponse attempt,
        LearnerExamSummaryResponse exam,
        List<LearnerExamQuestionResponse> questions) {}
