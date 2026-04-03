package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserCourseProgressJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserCourseProgressMapper {
    UserCourseProgress toDomain(UserCourseProgressJpaEntity entity);

    UserCourseProgressJpaEntity toEntity(UserCourseProgress domain);
}
