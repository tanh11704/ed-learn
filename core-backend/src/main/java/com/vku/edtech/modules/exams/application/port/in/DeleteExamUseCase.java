package com.vku.edtech.modules.exams.application.port.in;

import java.util.UUID;

public interface DeleteExamUseCase {
    void delete(DeleteExamCommand command);

    record DeleteExamCommand(UUID examId) {}
}
