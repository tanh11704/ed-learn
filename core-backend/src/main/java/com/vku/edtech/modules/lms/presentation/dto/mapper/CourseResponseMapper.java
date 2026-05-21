package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.presentation.dto.response.CourseResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {ChapterResponseMapper.class})
public interface CourseResponseMapper {
    @Mapping(target = "isDeleted", expression = "java(\"DELETED\".equals(domain.getStatus()))")
    CourseResponse toResponse(Course domain);
}
