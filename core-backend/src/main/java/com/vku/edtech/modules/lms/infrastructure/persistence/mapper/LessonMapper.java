package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", builder = @Builder(disableBuilder = true))
public interface LessonMapper {
    @Mapping(source = "chapter.id", target = "chapterId")
    Lesson toDomain(LessonJpaEntity entity);

    @Mapping(source = "chapterId", target = "chapter.id")
    LessonJpaEntity toEntity(Lesson domain);
}
