package com.vku.edtech.modules.identity.service.impl;

import com.vku.edtech.modules.identity.dto.request.LoginRequest;
import com.vku.edtech.modules.identity.dto.request.RegisterRequest;
import com.vku.edtech.modules.identity.dto.response.AuthResponse;
import com.vku.edtech.modules.identity.entity.RefreshToken;
import com.vku.edtech.modules.identity.entity.User;
import com.vku.edtech.modules.identity.repository.RefreshTokenRepository;
import com.vku.edtech.modules.identity.repository.UserRepository;
import com.vku.edtech.modules.identity.security.JwtService;
import com.vku.edtech.modules.identity.service.AuthService;
import com.vku.edtech.shared.exception.EmailAlreadyExistsException;
import com.vku.edtech.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    @Value("${jwt.refresh-expiration:604800000}")
    private long refreshExpiration;

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final RefreshTokenRepository refreshTokenRepository;

    @Override
    public AuthResponse register(RegisterRequest req) {
        if (userRepository.existsByEmail(req.email())) {
            throw new EmailAlreadyExistsException("Tài khoản đã tồn tại");
        }

        User user = User.builder()
                .fullName(req.fullName())
                .email(req.email())
                .passwordHash(passwordEncoder.encode(req.password()))
                .build();

        User savedUser = userRepository.save(user);

        String accessToken = jwtService.generateAccessToken(savedUser);
        String refreshToken = jwtService.generateRefreshToken();

        saveUserRefreshToken(savedUser, refreshToken);

        return new AuthResponse(accessToken, refreshToken);
    }

    @Override
    public AuthResponse login(LoginRequest req) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.email(), req.password())
        );

        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy người dùng."));

        String accessToken = jwtService.generateAccessToken(user);
        String refreshTokenString = jwtService.generateRefreshToken();

        saveUserRefreshToken(user, refreshTokenString);

        return new AuthResponse(accessToken, refreshTokenString);
    }

    private void saveUserRefreshToken(User user, String refreshToken) {
        RefreshToken token = RefreshToken.builder()
                .user(user)
                .token(refreshToken)
                .expiresAt(Instant.now().plusMillis(refreshExpiration))
                .revoked(false)
                // .deviceInfo(...) // Sau này nếu lấy được User-Agent từ Request thì truyền vào đây
                .build();
        refreshTokenRepository.save(token);
    }
}
