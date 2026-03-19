package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.port.in.LoginUseCase;
import com.vku.edtech.modules.identity.application.port.out.PasswordEncoderPort;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenCommandPort;
import com.vku.edtech.modules.identity.application.port.out.TokenGeneratorPort;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

@Service
@Transactional
@RequiredArgsConstructor
public class LoginService implements LoginUseCase {

    private final UserQueryPort userQueryPort;
    private final PasswordEncoderPort passwordEncoderPort;
    private final TokenGeneratorPort tokenGeneratorPort;
    private final RefreshTokenCommandPort refreshTokenCommandPort;

    @Override
    public AuthResult login(LoginCommand command) {
        User user = userQueryPort.findByEmail(command.email())
                .orElseThrow(() -> new BadCredentialsException("Email hoặc mật khẩu không chính xác"));

        boolean isPasswordValid = passwordEncoderPort.matches(command.rawPassword(), user.getPasswordHash());
        if (!isPasswordValid) {
            throw new ResourceNotFoundException("Email hoặc mật khẩu không chính xác");
        }

        String accessToken = tokenGeneratorPort.generateAccessToken(user);
        String refreshToken = tokenGeneratorPort.generateRefreshToken(user);

        long expirationMillis = tokenGeneratorPort.getRefreshTokenExpirationMillis();
        RefreshToken refreshTokenDomain = new RefreshToken(
                refreshToken,
                Instant.now().plusMillis(expirationMillis),
                "",
                user.getId()
        );
        refreshTokenCommandPort.save(refreshTokenDomain);

        return new AuthResult(accessToken, refreshToken);
    }

}
