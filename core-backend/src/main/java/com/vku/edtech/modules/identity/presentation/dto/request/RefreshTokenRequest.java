package com.vku.edtech.modules.identity.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record RefreshTokenRequest(
        @Schema(description = "Chuỗi Refresh Token được cấp lúc đăng nhập")
                @NotBlank(message = "Refresh Token không được để trống")
                String refreshToken) {}
