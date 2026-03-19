package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.application.dto.AuthResult;

public interface RefreshTokenUseCase {

    AuthResult refresh(RefreshTokenCommand command);

    record RefreshTokenCommand(String refreshToken) {}
}
