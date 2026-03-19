package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.application.dto.AuthResult;

public interface LoginUseCase {
    AuthResult login(LoginCommand command);

    record LoginCommand(String email, String rawPassword) {}
}
