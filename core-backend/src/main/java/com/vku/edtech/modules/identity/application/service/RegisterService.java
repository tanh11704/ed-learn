package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.port.in.CreateUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.in.RegisterUseCase;
import com.vku.edtech.modules.identity.application.port.out.*;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.presentation.exception.EmailAlreadyExistsException;
import java.time.Instant;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class RegisterService implements RegisterUseCase {

    private final UserQueryPort userQueryPort;
    private final UserCommandPort userCommandPort;
    private final PasswordEncoderPort passwordEncoderPort;
    private final TokenGeneratorPort tokenGeneratorPort;
    private final RefreshTokenCommandPort refreshTokenCommandPort;
    private final CreateUserStreakUseCase createUserStreakUseCase;

    @Override
    public AuthResult register(RegisterCommand command) {
        if (userQueryPort.existsByEmail(command.email())) {
            throw new EmailAlreadyExistsException("Email đã được sử dụng trong hệ thống!");
        }

        String hashedPassword = passwordEncoderPort.encode(command.rawPassword());

        User newUser = new User(command.email(), hashedPassword, command.fullName());

        User savedUser = userCommandPort.save(newUser);

        String accessToken = tokenGeneratorPort.generateAccessToken(savedUser);
        String refreshToken = tokenGeneratorPort.generateRefreshToken(savedUser);

        long expirationMillis = tokenGeneratorPort.getRefreshTokenExpirationMillis();

        RefreshToken refreshTokenDomain =
                new RefreshToken(
                        refreshToken,
                        Instant.now().plusMillis(expirationMillis),
                        "",
                        savedUser.getId());

        refreshTokenCommandPort.save(refreshTokenDomain);

        createUserStreakUseCase.createInitialStreak(savedUser.getId());

        return new AuthResult(accessToken, refreshToken);
    }
}
