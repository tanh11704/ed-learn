package com.vku.edtech.modules.exams.infrastructure.persistence.mapper;

import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.infrastructure.persistence.entity.ExamJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ExamPersistenceMapper {
    ExamJpaEntity toEntity(Exam domain);

    @Mapping(target = "questions", ignore = true)
    Exam toDomain(ExamJpaEntity entity);
}
