package com.vku.edtech.modules.exams.infrastructure.persistence.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamQuestionJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = ExamQuestionOptionPersistenceMapper.class)
public interface ExamQuestionPersistenceMapper {
    @Mapping(target = "examId", source = "exam.id")
    ExamQuestion toDomain(ExamQuestionJpaEntity entity);

    @Mapping(target = "exam.id", source = "examId")
    @Mapping(target = "questionType", expression = "java(domain.getQuestionType() == null ? null : domain.getQuestionType().name())")
    @Mapping(target = "paperPart", expression = "java(domain.getPaperPart() == null ? null : domain.getPaperPart().name())")
    @Mapping(target = "options", ignore = true)
    @Mapping(target = "deleted", constant = "false")
    ExamQuestionJpaEntity toEntity(ExamQuestion domain);
}
