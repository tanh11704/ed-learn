package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.ReviewErrorBankCardUseCase;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankQueryPort;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ReviewErrorBankCardService implements ReviewErrorBankCardUseCase {

    private final ErrorBankQueryPort errorBankQueryPort;
    private final ErrorBankCommandPort errorBankCommandPort;

    @Override
    @Transactional
    public void review(ReviewErrorBankCardCommand command) {
        var card =
                errorBankQueryPort
                        .findByIdAndUserId(command.cardId(), command.userId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy thẻ lỗi sai"));

        card.review(command.quality());
        errorBankCommandPort.save(card);
    }
}
