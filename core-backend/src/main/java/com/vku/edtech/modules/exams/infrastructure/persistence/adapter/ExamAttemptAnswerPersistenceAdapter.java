package com.vku.edtech.modules.exams.infrastructure.persistence.adapter;

import com.vku.edtech.modules.exams.application.port.out.ExamAttemptAnswerCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptAnswerQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import com.vku.edtech.modules.exams.infrastructure.persistence.mapper.ExamAttemptAnswerPersistenceMapper;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamAttemptAnswerJpaRepository;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ExamAttemptAnswerPersistenceAdapter
        implements ExamAttemptAnswerCommandPort, ExamAttemptAnswerQueryPort {

    private final ExamAttemptAnswerJpaRepository repository;
    private final ExamAttemptAnswerPersistenceMapper mapper;

    @Override
    public void saveAll(List<ExamAttemptAnswer> answers) {
        repository.saveAll(answers.stream().map(mapper::toEntity).toList());
    }

    @Override
    public List<ExamAttemptAnswer> findAllByAttemptId(UUID attemptId) {
        return repository.findAllByAttemptId(attemptId).stream()
                .map(mapper::toDomain)
                .toList();
    }
}
