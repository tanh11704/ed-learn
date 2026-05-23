package com.vku.edtech.modules.exams.infrastructure.persistence.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamAttemptAnswerJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ExamAttemptAnswerPersistenceMapper {
    ExamAttemptAnswerJpaEntity toEntity(ExamAttemptAnswer domain);
}
