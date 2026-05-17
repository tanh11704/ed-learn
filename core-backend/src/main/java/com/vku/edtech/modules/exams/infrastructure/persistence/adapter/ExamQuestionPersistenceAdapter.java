package com.vku.edtech.modules.exams.infrastructure.persistence.adapter;

import com.vku.edtech.modules.exams.application.port.out.ExamQuestionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionJpaEntity;
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
public class ExamQuestionPersistenceAdapter
        implements ExamQuestionCommandPort, ExamQuestionQueryPort {

    private final ExamQuestionJpaRepository questionJpaRepository;
    private final ExamJpaRepository examJpaRepository;
    private final ExamQuestionPersistenceMapper questionMapper;

    @Override
    public ExamQuestion save(ExamQuestion question) {
        ExamQuestionJpaEntity entity = questionMapper.toEntity(question);
        if (entity.getId() != null && !questionJpaRepository.existsById(entity.getId())) {
            entity.setId(null);
        }
        ExamJpaEntity examRef = examJpaRepository.getReferenceById(question.getExamId());
        entity.setExam(examRef);
        ExamQuestionJpaEntity saved = questionJpaRepository.saveAndFlush(entity);
        return questionMapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID questionId) {
        questionJpaRepository.deleteById(questionId);
    }

    @Override
    public Optional<ExamQuestion> findById(UUID questionId) {
        return questionJpaRepository.findByIdWithOptions(questionId).map(questionMapper::toDomain);
    }

    @Override
    public List<ExamQuestion> findAllByExamId(UUID examId) {
        return questionJpaRepository.findAllByExamIdWithOptions(examId).stream()
                .map(questionMapper::toDomain)
                .toList();
    }
}
