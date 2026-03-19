package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.application.dto.AuthResult;

public interface RegisterUseCase {
    AuthResult register(RegisterCommand command);

    record RegisterCommand(String email, String rawPassword, String fullName) {}
}
