package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

@Schema(description = "Dữ liệu yêu cầu để tạo khóa học mới")
public record CreateCourseRequest(
        @Schema(description = "Tiêu đề khóa học", example = "Lập trình Spring Boot cơ bản")
                @NotNull(message = "Title không được để trống")
                String title,
        @Schema(description = "Mô tả khóa học")
                @NotNull(message = "Description không được để trống")
                String description,
        @Schema(description = "Chủ đề khóa học", example = "CNTT")
                @NotNull(message = "Subject không được để trống")
                String subject) {}
