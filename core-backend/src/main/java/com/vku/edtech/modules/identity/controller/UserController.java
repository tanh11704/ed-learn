package com.vku.edtech.modules.identity.controller;

import com.vku.edtech.modules.identity.dto.response.UserProfileResponse;
import com.vku.edtech.modules.identity.entity.User;
import com.vku.edtech.modules.identity.service.UserService;
import com.vku.edtech.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
            Authentication authentication
    ) {
        User user = (User) authentication.getPrincipal();

        if (user == null) {
            throw new ResourceNotFoundException("Thông tin người dùng không hợp lệ");
        }

        UserProfileResponse response = userService.getMyProfile(user.getEmail());

        return ResponseEntity.ok(response);
    }
}
