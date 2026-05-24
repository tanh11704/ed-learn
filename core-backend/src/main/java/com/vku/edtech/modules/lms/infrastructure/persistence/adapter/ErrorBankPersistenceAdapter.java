package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.dto.ErrorBankStudentStatisticResult;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ErrorBankQueryPort;
import com.vku.edtech.modules.lms.domain.model.ErrorBankCard;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.ErrorBankMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.ErrorBankJpaRepository;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ErrorBankPersistenceAdapter implements ErrorBankQueryPort, ErrorBankCommandPort {

    private final ErrorBankJpaRepository repository;
    private final ErrorBankMapper mapper;

    @Override
    public List<ErrorBankCard> findDueByUserId(UUID userId, Instant now, int limit) {
        int safeLimit = Math.max(1, limit);
        return repository
                .findByUserIdAndNextReviewDateLessThanEqualOrderByNextReviewDateAsc(
                        userId, now, PageRequest.of(0, safeLimit))
                .stream()
                .map(mapper::toDomain)
                .toList();
    }

    @Override
    public Optional<ErrorBankCard> findByIdAndUserId(UUID id, UUID userId) {
        return repository.findByIdAndUserId(id, userId).map(mapper::toDomain);
    }

    @Override
    public List<ErrorBankStudentStatisticResult> getStudentStatistics(Instant now) {
        return repository.getStudentStatistics(now).stream()
                .map(
                        projection ->
                                new ErrorBankStudentStatisticResult(
                                        projection.getStudentId(),
                                        projection.getStudentName(),
                                        projection.getEmail(),
                                        projection.getGradeLevel(),
                                        projection.getClassName(),
                                        projection.getTotalErrors() == null
                                                ? 0
                                                : projection.getTotalErrors(),
                                        projection.getDueErrors() == null
                                                ? 0
                                                : projection.getDueErrors(),
                                        projection.getReviewedErrors() == null
                                                ? 0
                                                : projection.getReviewedErrors(),
                                        projection.getMasteredErrors() == null
                                                ? 0
                                                : projection.getMasteredErrors(),
                                        projection.getAverageEaseFactor(),
                                        projection.getAverageIntervalDays(),
                                        projection.getNextReviewDate(),
                                        projection.getLastUpdatedAt()))
                .toList();
    }

    @Override
    public ErrorBankCard save(ErrorBankCard card) {
        return mapper.toDomain(repository.save(mapper.toEntity(card)));
    }
}
