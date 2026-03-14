package com.vku.edtech.modules.identity.controller;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;
import com.vku.edtech.modules.identity.entity.User;
import com.vku.edtech.modules.identity.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserProfileResponse> me(
            @AuthenticationPrincipal User user
    ) {
        UserProfileResponse response = userService.getMyProfile(user);

        return ResponseEntity.ok(response);
    }
}
