package com.vku.edtech.modules.identity.service;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;

public interface UserService {
    UserProfileResponse getMyProfile(String email);
}
