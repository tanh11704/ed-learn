package com.vku.edtech.shared.exception;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(description = "Cấu trúc phản hồi lỗi chuẩn của hệ thống")
public record ErrorResponse(
        @Schema(description = "Mã lỗi HTTP", example = "400")
        int status,

        @Schema(description = "Loại lỗi (Error Category)", example = "Bad Request")
        String error,

        @Schema(description = "Thông báo lỗi chi tiết cho người dùng", example = "Email đã tồn tại trong hệ thống")
        String message,

        @Schema(description = "Thông tin bổ sung về lỗi (thường dùng cho lỗi Validation hoặc danh sách các trường sai)",
                example = "{\"email\": \"Định dạng email không hợp lệ\"}")
        Object details,

        @Schema(description = "Thời điểm xảy ra lỗi (Unix timestamp)", example = "1710456000000")
        long timestamp
) {
    public ErrorResponse(int status, String error, String message) {
        this(status, error, message, null, System.currentTimeMillis());
    }

    public ErrorResponse(int status, String error, String message, Object details) {
        this(status, error, message, details, System.currentTimeMillis());
    }
}
