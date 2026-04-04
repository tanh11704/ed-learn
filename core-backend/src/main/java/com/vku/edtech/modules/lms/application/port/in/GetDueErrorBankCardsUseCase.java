package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;
import java.util.List;
import java.util.UUID;

public interface GetDueErrorBankCardsUseCase {
    List<ErrorBankCard> getDueCards(GetDueErrorBankCardsQuery query);

    record GetDueErrorBankCardsQuery(UUID userId) {}
}
