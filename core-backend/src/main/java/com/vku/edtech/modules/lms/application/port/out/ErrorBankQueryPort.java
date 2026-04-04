package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ErrorBankQueryPort {
    List<ErrorBankCard> findDueByUserId(UUID userId, Instant now, int limit);

    Optional<ErrorBankCard> findByIdAndUserId(UUID id, UUID userId);
}
