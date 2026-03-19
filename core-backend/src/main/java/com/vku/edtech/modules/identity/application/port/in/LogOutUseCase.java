package com.vku.edtech.modules.identity.application.port.in;

public interface LogOutUseCase {
    void logOut(LogOutCommand command);

    record LogOutCommand(String accessToken, String refreshToken) {}
}
