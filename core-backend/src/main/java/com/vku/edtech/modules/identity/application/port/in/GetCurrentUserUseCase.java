package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;

public interface GetCurrentUserUseCase {
    UserProfileResult getCurrentUser(GetCurrentUserQuery query);

    record GetCurrentUserQuery(String email) {}
}
