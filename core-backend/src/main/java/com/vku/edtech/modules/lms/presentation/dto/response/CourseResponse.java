package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CourseResponse {
    private UUID id;
    private String title;
    private String description;
    private String subject;
    private String thumbnailUrl;
    private List<ChapterResponse> chapters;
    private Instant createdAt;
    private Instant updatedAt;
}
