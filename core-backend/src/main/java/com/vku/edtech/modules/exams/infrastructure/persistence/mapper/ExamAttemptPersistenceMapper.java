package com.vku.edtech.modules.exams.infrastructure.persistence.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamAttemptJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ExamAttemptPersistenceMapper {
    ExamAttempt toDomain(ExamAttemptJpaEntity entity);

    ExamAttemptJpaEntity toEntity(ExamAttempt domain);
}
