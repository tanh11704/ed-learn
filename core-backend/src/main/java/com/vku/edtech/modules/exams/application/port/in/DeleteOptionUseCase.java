package com.vku.edtech.modules.exams.application.port.in;

import java.util.UUID;

public interface DeleteOptionUseCase {
    void delete(DeleteOptionCommand command);

    record DeleteOptionCommand(UUID questionId, UUID optionId) {}
}
