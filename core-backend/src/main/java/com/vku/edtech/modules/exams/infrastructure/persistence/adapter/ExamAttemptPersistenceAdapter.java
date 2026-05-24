package com.vku.edtech.modules.exams.infrastructure.persistence.adapter;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptSummaryResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptStudentResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptsByGradeResult;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamAttemptJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.mapper.ExamAttemptPersistenceMapper;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamAttemptJpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ExamAttemptPersistenceAdapter
        implements ExamAttemptCommandPort, ExamAttemptQueryPort {

    private final ExamAttemptJpaRepository repository;
    private final ExamAttemptPersistenceMapper mapper;

    @Override
    public ExamAttempt save(ExamAttempt attempt) {
        ExamAttemptJpaEntity saved = repository.save(mapper.toEntity(attempt));
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<ExamAttempt> findById(UUID attemptId) {
        return repository.findById(attemptId).map(mapper::toDomain);
    }

    @Override
    public List<ExamAttempt> findByUserId(UUID userId) {
        return repository.findByUserIdOrderByStartedAtDesc(userId).stream()
                .map(mapper::toDomain)
                .toList();
    }

    @Override
    public ExamAttemptSummaryResult getSummaryByExamId(UUID examId) {
        var projection = repository.getSummaryByExamId(examId);
        if (projection == null) {
            throw new ExamNotFoundException("Khong tim thay de thi");
        }
        return new ExamAttemptSummaryResult(
                projection.getExamId(),
                projection.getExamTitle(),
                projection.getAttemptCount() == null ? 0 : projection.getAttemptCount(),
                projection.getSubmittedCount() == null ? 0 : projection.getSubmittedCount(),
                projection.getAverageScore(),
                projection.getHighestScore(),
                projection.getLowestScore());
    }

    @Override
    public List<ExamAttemptsByGradeResult> getAttemptsByGrade(UUID examId) {
        return repository.getAttemptsByGrade(examId).stream()
                .map(
                        projection ->
                                new ExamAttemptsByGradeResult(
                                        projection.getGradeLevel(),
                                        projection.getAttemptCount() == null
                                                ? 0
                                                : projection.getAttemptCount(),
                                        projection.getSubmittedCount() == null
                                                ? 0
                                                : projection.getSubmittedCount(),
                                        projection.getAverageScore()))
                .toList();
    }

    @Override
    public List<ExamAttemptsByGradeResult> getAttemptsByGrade() {
        return repository.getAttemptsByGrade().stream()
                .map(
                        projection ->
                                new ExamAttemptsByGradeResult(
                                        projection.getGradeLevel(),
                                        projection.getAttemptCount() == null
                                                ? 0
                                                : projection.getAttemptCount(),
                                        projection.getSubmittedCount() == null
                                                ? 0
                                                : projection.getSubmittedCount(),
                                        projection.getAverageScore()))
                .toList();
    }

    @Override
    public List<ExamAttemptStudentResult> findStudentAttemptsByExamId(UUID examId) {
        return repository.findStudentAttemptsByExamId(examId).stream()
                .map(
                        projection ->
                                new ExamAttemptStudentResult(
                                        projection.getAttemptId(),
                                        projection.getExamId(),
                                        projection.getStudentId(),
                                        projection.getStudentName(),
                                        projection.getEmail(),
                                        projection.getGradeLevel(),
                                        projection.getClassName(),
                                        projection.getStatus(),
                                        projection.getStartedAt(),
                                        projection.getSubmittedAt(),
                                        projection.getDurationSeconds(),
                                        projection.getScore(),
                                        projection.getMaxScore()))
                .toList();
    }
}
