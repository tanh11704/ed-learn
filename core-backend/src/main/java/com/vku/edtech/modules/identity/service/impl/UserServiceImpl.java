package com.vku.edtech.modules.identity.service.impl;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;
import com.vku.edtech.modules.identity.entity.User;
import com.vku.edtech.modules.identity.repository.UserRepository;
import com.vku.edtech.modules.identity.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    @Override
    public UserProfileResponse getMyProfile(User user) {

        return new UserProfileResponse(user.getId(), user.getEmail(), user.getFullName(), user.getRole());
    }
}
