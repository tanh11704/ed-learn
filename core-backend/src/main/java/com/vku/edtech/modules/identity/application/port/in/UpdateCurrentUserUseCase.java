package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;

public interface UpdateCurrentUserUseCase {
    UserProfileResult updateCurrentUser(UpdateCurrentUserCommand command);

    record UpdateCurrentUserCommand(String email, String fullName) {}
}
