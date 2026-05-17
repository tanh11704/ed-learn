package com.vku.edtech.modules.exams.application.port.in;

import java.util.UUID;

public interface DeleteQuestionUseCase {
    void delete(DeleteQuestionCommand command);

    record DeleteQuestionCommand(UUID questionId) {}
}
