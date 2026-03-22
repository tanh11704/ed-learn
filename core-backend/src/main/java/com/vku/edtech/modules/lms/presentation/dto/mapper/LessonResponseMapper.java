package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface LessonResponseMapper {
    LessonResponse toResponse(Lesson domain);
}
