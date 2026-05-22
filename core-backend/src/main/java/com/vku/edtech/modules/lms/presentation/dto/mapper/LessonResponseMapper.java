package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import org.springframework.stereotype.Component;

@Component
public class LessonResponseMapper {
    public LessonResponse toResponse(Lesson domain) {
        if (domain == null) {
            return null;
        }

        return new LessonResponse(
                domain.getId(),
                domain.getChapterId(),
                domain.getTitle(),
                domain.getVideoUrl(),
                domain.getPdfUrl(),
                domain.getOrderIndex(),
                domain.isPreview(),
                domain.isDeleted(),
                domain.getCreatedAt(),
                domain.getUpdatedAt());
    }
}
