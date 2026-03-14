package com.vku.edtech.modules.identity.dto.response;

import com.vku.edtech.modules.identity.entity.Role;

import java.util.UUID;

public record UserProfileResponse(
        UUID id,
        String email,
        String fullName,
        Role role
) {
}
