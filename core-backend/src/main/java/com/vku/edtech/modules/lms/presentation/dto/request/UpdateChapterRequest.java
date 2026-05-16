package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

@Schema(description = "Dữ liệu yêu cầu cập nhật chapter")
public record UpdateChapterRequest(
        @Schema(description = "ID khóa học", example = "100ab6bd-ed08-4bfa-af40-d00977051d70")
                UUID courseId,
        @Schema(description = "Tên chapter", example = "Kiến trúc sạch")
                @NotBlank(message = "title không được để trống")
                String title,
        @Schema(description = "Thứ tự chapter", example = "1") @NotNull(message = "orderIndex không được để trống")
                Integer orderIndex) {}
