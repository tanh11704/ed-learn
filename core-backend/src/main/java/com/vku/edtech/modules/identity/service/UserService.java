package com.vku.edtech.modules.identity.service;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;
import com.vku.edtech.modules.identity.entity.User;

public interface UserService {
    UserProfileResponse getMyProfile(User user);
}
