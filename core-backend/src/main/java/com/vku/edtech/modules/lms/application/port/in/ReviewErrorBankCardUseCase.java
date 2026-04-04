package com.vku.edtech.modules.lms.application.port.in;

import java.util.UUID;

public interface ReviewErrorBankCardUseCase {
    void review(ReviewErrorBankCardCommand command);

    record ReviewErrorBankCardCommand(UUID userId, UUID cardId, int quality) {}
}
