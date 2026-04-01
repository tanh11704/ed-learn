package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.presentation.dto.response.ChapterResponse;
import org.mapstruct.Mapper;

@Mapper(
        componentModel = "spring",
        uses = {LessonResponseMapper.class})
public interface ChapterResponseMapper {
    ChapterResponse toResponse(Chapter domain);
}
