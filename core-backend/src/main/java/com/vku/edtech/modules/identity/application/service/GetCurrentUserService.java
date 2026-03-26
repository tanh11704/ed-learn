package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;
import com.vku.edtech.modules.identity.application.port.in.GetCurrentUserUseCase;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class GetCurrentUserService implements GetCurrentUserUseCase {

    private final UserQueryPort userQueryPort;

    @Override
    public UserProfileResult getCurrentUser(GetCurrentUserQuery query) {

        User user =
                userQueryPort
                        .findByEmail(query.email())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        return new UserProfileResult(
                user.getId(), user.getEmail(), user.getFullName(), user.getRole().name());
    }
}
