package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetDueErrorBankCardsUseCase;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankQueryPort;
import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;
import java.time.Instant;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetDueErrorBankCardsService implements GetDueErrorBankCardsUseCase {

    private final ErrorBankQueryPort errorBankQueryPort;

    @Override
    public List<ErrorBankCard> getDueCards(GetDueErrorBankCardsQuery query) {
        return errorBankQueryPort.findDueByUserId(query.userId(), Instant.now(), query.limit());
    }
}
