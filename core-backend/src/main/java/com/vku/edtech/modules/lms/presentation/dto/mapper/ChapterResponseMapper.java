package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.presentation.dto.response.ChapterResponse;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ChapterResponseMapper {
    private final LessonResponseMapper lessonResponseMapper;

    public ChapterResponse toResponse(Chapter domain) {
        if (domain == null) {
            return null;
        }

        return new ChapterResponse(
                domain.getId(),
                domain.getCourseId(),
                domain.getTitle(),
                domain.getOrderIndex(),
                mapLessons(domain),
                domain.getIsDeleted(),
                domain.getCreatedAt(),
                domain.getUpdatedAt());
    }

    private List<com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse> mapLessons(
            Chapter domain) {
        return domain.getLessons().stream().map(lessonResponseMapper::toResponse).toList();
    }
}
