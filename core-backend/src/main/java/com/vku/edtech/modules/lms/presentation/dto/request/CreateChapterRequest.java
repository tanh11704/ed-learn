package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record CreateChapterRequest(
        @Schema(description = "ID của khóa học", example = "100ab6bd-ed08-4bfa-af40-d00977051d70")
                @NotNull(message = "ID khóa học không được để trống")
                UUID courseId,
        @Schema(description = "Tên chương", example = "Làm quen với kiến trúc Layer Architecture")
                @NotNull(message = "Tên chương không được để trống")
                String title,
        @Schema(description = "Thứ tự chương", example = "0") int orderIndex) {}
