package com.vku.edtech.modules.identity.presentation.controller;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;
import com.vku.edtech.modules.identity.application.port.in.CheckUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.in.GetCurrentUserUseCase;
import com.vku.edtech.modules.identity.presentation.dto.mapper.UserStreakMapper;
import com.vku.edtech.modules.identity.presentation.dto.response.UserStreakResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/v1/user-streaks")
@RequiredArgsConstructor
@Tag(name = "User Streak", description = "Quản lý chuỗi ngày hoạt động (Streak) của người dùng")
public class UserStreakController {

    private final CheckUserStreakUseCase checkUserStreakUseCase;
    private final GetCurrentUserUseCase getCurrentUserUseCase;
    private final UserStreakMapper userStreakMapper;

    @Operation(summary = "Lấy thông tin streak cá nhân", description = "Trả về thông tin streak của người dùng hiện tại dựa trên Access Token", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/me")
    public ResponseEntity<UserStreakResponse> getMyStreak(Principal principal) {
        String email = principal.getName();

        GetCurrentUserUseCase.GetCurrentUserQuery query = new GetCurrentUserUseCase.GetCurrentUserQuery(email);
        UserProfileResult user = getCurrentUserUseCase.getCurrentUser(query);

        return ResponseEntity.ok(userStreakMapper.toResponse(
                checkUserStreakUseCase.getUserStreak(
                        new CheckUserStreakUseCase.CheckUserStreakCommand(user.id()))));
    }
}
