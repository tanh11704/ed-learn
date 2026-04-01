package com.vku.edtech.modules.lms.infrastructure.persistence.mapper;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.CourseJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {ChapterMapper.class})
public interface CourseMapper {
    Course toDomain(CourseJpaEntity entity);

    @Mapping(target = "chapters", ignore = true)
    Course toDomainSummary(CourseJpaEntity entity);

    CourseJpaEntity toEntity(Course domain);
}
