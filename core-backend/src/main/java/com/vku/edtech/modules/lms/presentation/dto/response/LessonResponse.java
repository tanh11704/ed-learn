package com.vku.edtech.modules.lms.presentation.dto.response;

import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.UUID;

@Data
@Builder
public class LessonResponse {
    private UUID id;
    private UUID chapterId;
    private String title;
    private String videoUrl;
    private String pdfUrl;
    private Integer orderIndex;
    private Instant createdAt;
    private Instant updatedAt;
}
