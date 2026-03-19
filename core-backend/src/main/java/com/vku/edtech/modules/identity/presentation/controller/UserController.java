package com.vku.edtech.modules.identity.presentation.controller;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;
import com.vku.edtech.modules.identity.application.port.in.GetCurrentUserUseCase;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.presentation.dto.mapper.UserMapper;
import com.vku.edtech.modules.identity.presentation.dto.response.UserProfileResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "Quản lý thông tin người dùng")
public class UserController {

    private final GetCurrentUserUseCase getCurrentUserUseCase;
    private final UserMapper userMapper;

    @Operation(
            summary = "Lấy thông tin cá nhân",
            description = "Trả về thông tin của người dùng hiện tại dựa trên Access Token trong Header",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @GetMapping("/me")
    public ResponseEntity<UserProfileResponse> me(Principal principal) {
        String email = principal.getName();

        GetCurrentUserUseCase.GetCurrentUserQuery query = new GetCurrentUserUseCase.GetCurrentUserQuery(email);

        UserProfileResult result = getCurrentUserUseCase.getCurrentUser(query);

        UserProfileResponse response = userMapper.toResponse(result);

        return ResponseEntity.ok(response);
    }
}
