package com.vku.edtech.modules.exams.infrastructure.persistence.adapter;

import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionOptionJpaEntity;
import com.vku.edtech.modules.exams.infrastructure.persistence.mapper.ExamQuestionOptionPersistenceMapper;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamQuestionJpaRepository;
import com.vku.edtech.modules.exams.infrastructure.persistence.repository.ExamQuestionOptionJpaRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ExamOptionPersistenceAdapter implements ExamOptionCommandPort, ExamOptionQueryPort {

    private final ExamQuestionOptionJpaRepository optionJpaRepository;
    private final ExamQuestionJpaRepository questionJpaRepository;
    private final ExamQuestionOptionPersistenceMapper optionMapper;

    @Override
    public ExamQuestionOption save(ExamQuestionOption option) {
        ExamQuestionOptionJpaEntity entity = optionMapper.toEntity(option);
        if (entity.getId() != null && !optionJpaRepository.existsById(entity.getId())) {
            entity.setId(null);
        }
        ExamQuestionJpaEntity questionRef = questionJpaRepository.getReferenceById(option.getQuestionId());
        entity.setQuestion(questionRef);
        ExamQuestionOptionJpaEntity saved = optionJpaRepository.saveAndFlush(entity);
        return optionMapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID optionId) {
        optionJpaRepository.deleteById(optionId);
    }

    @Override
    public Optional<ExamQuestionOption> findById(UUID optionId) {
        return optionJpaRepository.findById(optionId).map(optionMapper::toDomain);
    }

    @Override
    public List<ExamQuestionOption> findAllByQuestionId(UUID questionId) {
        return optionJpaRepository.findAllByQuestionIdOrderByOrderIndexAsc(questionId).stream()
                .map(optionMapper::toDomain)
                .toList();
    }
}
