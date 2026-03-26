package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.presentation.dto.response.CourseResponse;
import org.mapstruct.Mapper;

@Mapper(
        componentModel = "spring",
        uses = {ChapterResponseMapper.class})
public interface CourseResponseMapper {
    CourseResponse toResponse(Course domain);
}
