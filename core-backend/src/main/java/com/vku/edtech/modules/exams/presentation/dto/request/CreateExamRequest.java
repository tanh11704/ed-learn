package com.vku.edtech.modules.exams.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu tạo đề thi")
public record CreateExamRequest(
        @Schema(description = "Tên đề thi", example = "Đề kiểm tra giữa kỳ")
                @NotBlank(message = "title không được để trống")
                @Size(max = 255, message = "title tối đa 255 ký tự")
                String title,
        @Schema(description = "Môn học", example = "Toán")
                @NotBlank(message = "subject không được để trống")
                @Size(max = 100, message = "subject tối đa 100 ký tự")
                String subject,
        @Schema(description = "Năm học", example = "2026")
                @NotNull(message = "schoolYear không được để trống")
                @Min(value = 2000, message = "schoolYear phải từ 2000 trở lên")
                Integer schoolYear,
        @Schema(description = "Thời gian làm bài (phút)", example = "60")
                @NotNull(message = "durationMinutes không được để trống")
                @Min(value = 1, message = "durationMinutes phải lớn hơn 0")
                Integer durationMinutes,
        @Schema(description = "Tổng số câu hỏi", example = "40")
                @NotNull(message = "totalQuestions không được để trống")
                @Min(value = 0, message = "totalQuestions không được âm")
                Integer totalQuestions,
        @Schema(description = "Mô tả đề thi") String description) {}
