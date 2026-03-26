package com.vku.edtech.modules.lms.presentation.dto.response;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChapterResponse {
    private UUID id;
    private UUID courseId;
    private String title;
    private Integer orderIndex;
    private List<LessonResponse> lessons;
    private Instant createdAt;
    private Instant updatedAt;
}
