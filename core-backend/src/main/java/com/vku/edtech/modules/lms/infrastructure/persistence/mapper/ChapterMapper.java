package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {LessonMapper.class})
public interface ChapterMapper {
    @Mapping(source = "course.id", target = "courseId")
    Chapter toDomain(ChapterJpaEntity entity);

    @Mapping(source = "courseId", target = "course.id")
    ChapterJpaEntity toEntity(Chapter domain);
}
