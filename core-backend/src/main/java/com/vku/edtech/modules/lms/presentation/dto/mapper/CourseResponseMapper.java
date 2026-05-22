package com.vku.edtech.modules.lms.presentation.dto.mapper;

import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.presentation.dto.response.ChapterResponse;
import com.vku.edtech.modules.lms.presentation.dto.response.CourseResponse;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CourseResponseMapper {
    private final ChapterResponseMapper chapterResponseMapper;

    public CourseResponse toResponse(Course domain) {
        if (domain == null) {
            return null;
        }

        return new CourseResponse(
                domain.getId(),
                domain.getTitle(),
                domain.getDescription(),
                domain.getSubject(),
                domain.getThumbnailUrl(),
                "DELETED".equals(domain.getStatus()),
                mapChapters(domain),
                domain.getCreatedAt(),
                domain.getUpdatedAt());
    }

    private List<ChapterResponse> mapChapters(Course domain) {
        return domain.getChapters().stream().map(chapterResponseMapper::toResponse).toList();
    }
}
