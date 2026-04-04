package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;

public interface ErrorBankCommandPort {
    ErrorBankCard save(ErrorBankCard card);
}
