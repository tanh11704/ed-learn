package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.Enrollment;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.EnrollmentJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface EnrollmentMapper {
    Enrollment toDomain(EnrollmentJpaEntity entity);

    EnrollmentJpaEntity toEntity(Enrollment domain);
}
