package com.vku.edtech.modules.exams.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu cập nhật đề thi")
public record UpdateExamRequest(
        @Schema(description = "Tên đề thi")
                @NotBlank(message = "title không được để trống")
                @Size(max = 255, message = "title tối đa 255 ký tự")
                String title,
        @Schema(description = "Môn học")
                @NotBlank(message = "subject không được để trống")
                @Size(max = 100, message = "subject tối đa 100 ký tự")
                String subject,
        @Schema(description = "Năm học")
                @Min(value = 2000, message = "schoolYear phải từ 2000 trở lên")
                Integer schoolYear,
        @Schema(description = "Thời gian làm bài")
                @Min(value = 1, message = "durationMinutes phải lớn hơn 0")
                Integer durationMinutes,
        @Schema(description = "Tổng số câu hỏi") @Min(value = 0, message = "totalQuestions không được âm")
                Integer totalQuestions,
        @Schema(description = "Mô tả đề thi") String description,
        @Schema(description = "Trạng thái đề thi", example = "DRAFT") String status) {}
