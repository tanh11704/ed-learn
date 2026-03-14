package com.vku.edtech.modules.identity.service.impl;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;
import com.vku.edtech.modules.identity.entity.User;
import com.vku.edtech.modules.identity.repository.UserRepository;
import com.vku.edtech.modules.identity.service.UserService;
import com.vku.edtech.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    @Override
    public UserProfileResponse getMyProfile(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        return new UserProfileResponse(user.getId(), user.getEmail(), user.getFullName(), user.getRole());
    }
}
