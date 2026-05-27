package com.vku.edtech.modules.exams.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu cập nhật câu hỏi")
public record UpdateQuestionRequest(
        @Schema(description = "Nội dung câu hỏi")
                @NotBlank(message = "content không được để trống")
                @Size(max = 5000, message = "content tối đa 5000 ký tự")
                String content,
        @Schema(description = "URL hình ảnh minh họa hiện có, nếu giữ ảnh cũ")
                @Size(max = 1000, message = "imageUrl tối đa 1000 ký tự")
                String imageUrl,
        @Schema(description = "Thứ tự câu hỏi", example = "1") Integer orderIndex,
        @Schema(description = "Điểm của câu hỏi", example = "0.25")
                @NotNull(message = "score không được để trống")
                @DecimalMin(value = "0.01", message = "score phải lớn hơn 0")
                Double score,
        @Schema(description = "Đáp án chuẩn cho trả lời ngắn") String correctAnswer) {}
