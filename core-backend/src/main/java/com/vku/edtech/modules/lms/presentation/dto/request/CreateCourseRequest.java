package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Dữ liệu yêu cầu để tạo khóa học mới")
public record CreateCourseRequest(
        @Schema(description = "Tiêu đề khóa học", example = "Lập trình Spring Boot cơ bản")
                @NotBlank(message = "title không được để trống")
                @Size(max = 255, message = "title tối đa 255 ký tự")
                String title,
        @Schema(description = "Mô tả khóa học")
                @NotBlank(message = "description không được để trống")
                String description,
        @Schema(description = "Chủ đề khóa học", example = "CNTT")
                @NotBlank(message = "subject không được để trống")
                @Size(max = 100, message = "subject tối đa 100 ký tự")
                String subject) {}
