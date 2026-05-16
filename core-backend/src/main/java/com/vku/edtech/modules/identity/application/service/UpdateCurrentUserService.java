package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;
import com.vku.edtech.modules.identity.application.port.in.UpdateCurrentUserUseCase;
import com.vku.edtech.modules.identity.application.port.out.UserCommandPort;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class UpdateCurrentUserService implements UpdateCurrentUserUseCase {

    private final UserQueryPort userQueryPort;
    private final UserCommandPort userCommandPort;

    @Override
    public UserProfileResult updateCurrentUser(UpdateCurrentUserCommand command) {
        User user =
                userQueryPort
                        .findByEmail(command.email())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        user.updateProfile(command.fullName());
        User savedUser = userCommandPort.save(user);
        User refreshedUser =
                userQueryPort
                        .findByEmail(savedUser.getEmail())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        return new UserProfileResult(
                refreshedUser.getId(),
                refreshedUser.getEmail(),
                refreshedUser.getFullName(),
                refreshedUser.getRole().name());
    }
}
