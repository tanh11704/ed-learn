package com.vku.edtech.modules.exams.infrastructure.persistence.adapter;

import com.vku.edtech.modules.exams.application.port.out.ExamCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.mapper.ExamPersistenceMapper;
import com.vku.edtech.modules.exams.infrastructure.persistence.mapper.ExamQuestionPersistenceMapper;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamJpaRepository;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamQuestionJpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ExamPersistenceAdapter implements ExamCommandPort, ExamQueryPort {

    private final ExamJpaRepository examJpaRepository;
    private final ExamQuestionJpaRepository questionJpaRepository;
    private final ExamPersistenceMapper examPersistenceMapper;
    private final ExamQuestionPersistenceMapper questionPersistenceMapper;

    @Override
    public Exam save(Exam exam) {
        ExamJpaEntity entity = examPersistenceMapper.toEntity(exam);
        if (entity.getId() != null && !examJpaRepository.existsById(entity.getId())) {
            entity.setId(null);
        }
        ExamJpaEntity saved = examJpaRepository.save(entity);
        return examPersistenceMapper.toDomain(saved);
    }

    @Override
    public Optional<Exam> findById(UUID examId) {
        return examJpaRepository
                .findById(examId)
                .map(entity -> {
                    Exam exam = examPersistenceMapper.toDomain(entity);
                    questionJpaRepository.findAllByExamIdWithOptions(examId).stream()
                            .map(questionPersistenceMapper::toDomain)
                            .forEach(exam::addQuestion);
                    return exam;
                });
    }

    @Override
    public List<Exam> findAll() {
        return examJpaRepository.findAll().stream()
                .map(examPersistenceMapper::toDomain)
                .toList();
    }

    @Override
    public List<Exam> findAllActive() {
        return examJpaRepository.findAllByStatusNotOrderByCreatedAtDesc("ARCHIVED").stream()
                .map(examPersistenceMapper::toDomain)
                .toList();
    }

    @Override
    public List<Exam> findAllByStatus(String status) {
        return examJpaRepository.findAllByStatusOrderByCreatedAtDesc(status).stream()
                .map(examPersistenceMapper::toDomain)
                .toList();
    }
}
