package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Dữ liệu yêu cầu để tạo khóa học mới")
public record CreateCourseRequest(
        @Schema(description = "Tiêu đề khóa học", example = "Lập trình Spring Boot cơ bản")
        String title,
        @Schema(description = "Mô tả khóa học")
        String description,
        @Schema(description = "Chủ đề khóa học", example = "CNTT")
        String subject) {
}
