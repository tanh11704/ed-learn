package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserProgressLessonJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserProgressLessonMapper {
    UserProgressLesson toDomain(UserProgressLessonJpaEntity entity);

    UserProgressLessonJpaEntity toEntity(UserProgressLesson domain);
}
