package com.vku.edtech.modules.identity.controller;

import com.vku.edtech.modules.identity.dto.request.LoginRequest;
import com.vku.edtech.modules.identity.dto.request.LogoutRequest;
import com.vku.edtech.modules.identity.dto.request.RefreshTokenRequest;
import com.vku.edtech.modules.identity.dto.request.RegisterRequest;
import com.vku.edtech.modules.identity.dto.response.AuthResponse;
import com.vku.edtech.modules.identity.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/auth")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody @Valid LoginRequest request) {
        AuthResponse response = authService.login(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody @Valid RegisterRequest request) {
        AuthResponse response = authService.register(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@RequestBody @Valid RefreshTokenRequest request) {
        AuthResponse response = authService.refreshToken(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(
            Authentication authentication,
            @RequestBody @Valid LogoutRequest logoutRequest
    ) {
        if (authentication == null || authentication.getCredentials() == null) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", "Thiếu hoặc sai định dạng Access Token");
            return ResponseEntity.badRequest().body(errorResponse);
        }

        String accessToken = (String) authentication.getCredentials();

        authService.logout(accessToken, logoutRequest.refreshToken());

        Map<String, String> response = new HashMap<>();
        response.put("message", "Đăng xuất thành công");

        return ResponseEntity.ok(response);
    }
}
