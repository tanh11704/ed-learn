package com.vku.edtech.modules.exams.infrastructure.persistence.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionOptionJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ExamQuestionOptionPersistenceMapper {
    @Mapping(target = "questionId", source = "question.id")
    ExamQuestionOption toDomain(ExamQuestionOptionJpaEntity entity);

    @Mapping(target = "question", ignore = true)
    ExamQuestionOptionJpaEntity toEntity(ExamQuestionOption domain);
}
