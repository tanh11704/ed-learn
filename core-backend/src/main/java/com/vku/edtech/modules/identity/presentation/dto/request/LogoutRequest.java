package com.vku.edtech.modules.identity.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

public record LogoutRequest(
        @Schema(description = "Refresh Token cần xóa khỏi hệ thống")
                @NotBlank(message = "Refresh Token không được để trống")
                String refreshToken) {}
