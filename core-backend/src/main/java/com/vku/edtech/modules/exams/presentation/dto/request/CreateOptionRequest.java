package com.vku.edtech.modules.exams.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu tạo đáp án")
public record CreateOptionRequest(
        @Schema(description = "Nội dung đáp án")
                @NotBlank(message = "content không được để trống")
                @Size(max = 3000, message = "content tối đa 3000 ký tự")
                String content,
        @Schema(description = "Đáp án đúng hay không", example = "true")
                @NotNull(message = "correct không được để trống")
                Boolean correct,
        @Schema(description = "Thứ tự đáp án", example = "1") Integer orderIndex) {}
