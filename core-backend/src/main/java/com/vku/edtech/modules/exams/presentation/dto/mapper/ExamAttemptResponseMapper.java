package com.vku.edtech.modules.exams.presentation.dto.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptResponse;
import org.springframework.stereotype.Component;

@Component
public class ExamAttemptResponseMapper {
    public ExamAttemptResponse toResponse(ExamAttempt attempt) {
        return new ExamAttemptResponse(
                attempt.getId(),
                attempt.getExamId(),
                attempt.getUserId(),
                attempt.getGradeLevel(),
                attempt.getClassName(),
                attempt.getStatus().name(),
                attempt.getStartedAt(),
                attempt.getSubmittedAt(),
                attempt.getDurationSeconds(),
                attempt.getScore(),
                attempt.getMaxScore());
    }
}
