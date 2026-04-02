package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu tạo lesson")
public record CreateLessonRequest(
        @Schema(
                        description = "ID chapter chứa lesson",
                        example = "d290f1ee-6c54-4b01-90e6-d701748f0851")
                @NotBlank(message = "chapterId không được để trống")
                @Pattern(
                        regexp =
                                "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
                        message = "chapterId phải đúng định dạng UUID")
                String chapterId,
        @Schema(description = "Tiêu đề lesson", example = "Bài 1 - Giới thiệu")
                @NotBlank(message = "title không được để trống")
                @Size(max = 255, message = "title tối đa 255 ký tự")
                String title,
        @Schema(description = "Thứ tự trong chapter, bỏ trống để tự gán xuống cuối", example = "3")
                Integer orderIndex,
        @Schema(description = "Cho phép học thử", example = "false")
                @NotNull(message = "isPreview không được để trống")
                Boolean isPreview) {}
