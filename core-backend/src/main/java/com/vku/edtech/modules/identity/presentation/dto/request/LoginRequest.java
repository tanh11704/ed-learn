package com.vku.edtech.modules.identity.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record LoginRequest(
        @Schema(description = "Địa chỉ email của người dùng", example = "student@vku.udn.vn")
                @NotBlank(message = "Email không được để trống")
                @Email(message = "Email không đúng định dạng")
                String email,
        @Schema(description = "Mật khẩu đăng nhập", example = "P@ssword123")
                @NotBlank(message = "Mật khẩu không được để trống")
                String password) {}
