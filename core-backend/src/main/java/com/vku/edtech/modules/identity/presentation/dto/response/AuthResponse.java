package com.vku.edtech.modules.identity.presentation.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Thông tin Token sau khi xác thực thành công")
public record AuthResponse(
        @Schema(description = "Access Token dùng để gọi các API bảo mật (hạn ngắn)")
        String accessToken,

        @Schema(description = "Refresh Token dùng để lấy Access Token mới (hạn dài)")
        String refreshToken,

        @Schema(description = "Loại token", example = "Bearer")
        String tokenType
) {
    public AuthResponse(String accessToken, String refreshToken) {
        this(accessToken, refreshToken, "Bearer");
    }
}
