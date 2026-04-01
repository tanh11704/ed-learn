package com.vku.edtech.modules.identity.presentation.controller;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.port.in.LogOutUseCase;
import com.vku.edtech.modules.identity.application.port.in.LoginUseCase;
import com.vku.edtech.modules.identity.application.port.in.RefreshTokenUseCase;
import com.vku.edtech.modules.identity.application.port.in.RegisterUseCase;
import com.vku.edtech.modules.identity.presentation.dto.mapper.AuthMapper;
import com.vku.edtech.modules.identity.presentation.dto.request.LoginRequest;
import com.vku.edtech.modules.identity.presentation.dto.request.LogoutRequest;
import com.vku.edtech.modules.identity.presentation.dto.request.RefreshTokenRequest;
import com.vku.edtech.modules.identity.presentation.dto.request.RegisterRequest;
import com.vku.edtech.modules.identity.presentation.dto.response.AuthResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/auth")
@Tag(name = "Authentication", description = "Quản lý đăng nhập, đăng ký và cấp phát Token")
public class AuthController {

    private final RegisterUseCase registerUseCase;
    private final LoginUseCase loginUseCase;
    private final LogOutUseCase logOutUseCase;
    private final RefreshTokenUseCase refreshTokenUseCase;
    private final AuthMapper authMapper;

    @Operation(
            summary = "Đăng nhập người dùng",
            description = "Trả về cặp Access Token và Refresh Token")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Đăng nhập thành công"),
        @ApiResponse(responseCode = "401", description = "Sai email hoặc mật khẩu")
    })
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody @Valid LoginRequest request) {

        LoginUseCase.LoginCommand command =
                new LoginUseCase.LoginCommand(request.email(), request.password());

        AuthResult authResult = loginUseCase.login(command);

        AuthResponse response = authMapper.toResponse(authResult);

        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Đăng ký tài khoản mới")
    @ApiResponse(responseCode = "400", description = "Email đã tồn tại hoặc dữ liệu không hợp lệ")
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody @Valid RegisterRequest request) {

        RegisterUseCase.RegisterCommand command =
                new RegisterUseCase.RegisterCommand(
                        request.email(), request.password(), request.fullName());

        AuthResult authResult = registerUseCase.register(command);

        AuthResponse response = authMapper.toResponse(authResult);

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Lấy Access Token mới",
            description = "Sử dụng Refresh Token để gia hạn phiên đăng nhập")
    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@RequestBody @Valid RefreshTokenRequest request) {
        RefreshTokenUseCase.RefreshTokenCommand command =
                new RefreshTokenUseCase.RefreshTokenCommand(request.refreshToken());

        AuthResult authResult = refreshTokenUseCase.refresh(command);

        AuthResponse response = authMapper.toResponse(authResult);

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Đăng xuất",
            description = "Vô hiệu hóa Access Token (Blacklist) và xóa Refresh Token",
            security = @SecurityRequirement(name = "bearerAuth"))
    @SecurityRequirement(name = "bearerAuth")
    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody @Valid LogoutRequest logoutRequest) {

        String accessToken = null;
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            accessToken = authHeader.substring(7); // Cắt bỏ chữ Bearer
        }

        LogOutUseCase.LogOutCommand command =
                new LogOutUseCase.LogOutCommand(accessToken, logoutRequest.refreshToken());

        logOutUseCase.logOut(command);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Đăng xuất thành công");

        return ResponseEntity.ok(response);
    }
}
