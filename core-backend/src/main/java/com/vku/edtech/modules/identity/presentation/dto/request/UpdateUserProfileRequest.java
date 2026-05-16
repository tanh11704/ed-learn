package com.vku.edtech.modules.identity.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateUserProfileRequest(
        @Schema(description = "Họ và tên đầy đủ", example = "Nguyễn Văn A")
                @NotBlank(message = "Họ tên không được để trống")
                @Size(max = 100, message = "Họ tên không được vượt quá 100 ký tự")
                String fullName) {}
