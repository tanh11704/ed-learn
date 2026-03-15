package com.vku.edtech.modules.identity.dto.response;

import com.vku.edtech.modules.identity.entity.Role;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.UUID;

@Schema(description = "Thông tin chi tiết hồ sơ người dùng")
public record UserProfileResponse(
        @Schema(description = "ID duy nhất của người dùng", example = "550e8400-e29b-41d4-a716-446655440000")
        UUID id,

        @Schema(description = "Địa chỉ email đăng ký", example = "student@vku.udn.vn")
        String email,

        @Schema(description = "Họ và tên đầy đủ", example = "Nguyễn Văn A")
        String fullName,

        @Schema(description = "Vai trò của người dùng trong hệ thống", example = "USER")
        Role role
) {
}
