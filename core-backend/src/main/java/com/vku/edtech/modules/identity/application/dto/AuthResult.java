package com.vku.edtech.modules.identity.application.dto;

public record AuthResult(
        String accessToken,
        String refreshToken
) {
}
