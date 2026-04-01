package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu cập nhật lesson")
public record UpdateLessonRequest(
        @Schema(
                        description = "ID chapter mới (nếu muốn chuyển chapter)",
                        example = "d290f1ee-6c54-4b01-90e6-d701748f0851")
                @Pattern(
                        regexp =
                                "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
                        message = "chapterId phải đúng định dạng UUID")
                String chapterId,
        @Schema(description = "Tiêu đề lesson", example = "Bài 1 - Giới thiệu cập nhật")
                @NotBlank(message = "title không được để trống")
                @Size(max = 255, message = "title tối đa 255 ký tự")
                String title,
        @Schema(description = "Thứ tự trong chapter", example = "4") Integer orderIndex,
        @Schema(description = "Cho phép học thử", example = "true") Boolean isPreview) {}
