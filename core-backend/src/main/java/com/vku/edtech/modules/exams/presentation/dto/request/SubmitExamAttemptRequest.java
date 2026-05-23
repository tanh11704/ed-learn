package com.vku.edtech.modules.exams.presentation.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import java.util.UUID;

public record SubmitExamAttemptRequest(
        @NotEmpty(message = "answers khong duoc de trong") List<@Valid SubmitAnswerRequest> answers) {

    public record SubmitAnswerRequest(
            @NotNull(message = "questionId khong duoc de trong") UUID questionId,
            UUID selectedOptionId,
            String answerText) {}
}
