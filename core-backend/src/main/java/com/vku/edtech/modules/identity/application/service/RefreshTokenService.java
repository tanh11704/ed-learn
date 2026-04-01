package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.port.in.RefreshTokenUseCase;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenCommandPort;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenQueryPort;
import com.vku.edtech.modules.identity.application.port.out.TokenGeneratorPort;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import com.vku.edtech.shared.presentation.exception.TokenRefreshException;
import java.time.Instant;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class RefreshTokenService implements RefreshTokenUseCase {

    private final RefreshTokenCommandPort refreshTokenCommandPort;
    private final RefreshTokenQueryPort refreshTokenQueryPort;
    private final TokenGeneratorPort tokenGeneratorPort;
    private final UserQueryPort userQueryPort;

    @Override
    public AuthResult refresh(RefreshTokenCommand command) {

        RefreshToken refreshTokenDomain =
                refreshTokenQueryPort
                        .findByToken(command.refreshToken())
                        .orElseThrow(() -> new ResourceNotFoundException("Token không hợp lệ"));

        if (refreshTokenDomain.isRevoked()) {
            throw new TokenRefreshException("Token đã bị thu hồi");
        }

        if (refreshTokenDomain.isExpired()) {
            throw new TokenRefreshException("Phiên đăng nhập đã hết hạn");
        }

        User user =
                userQueryPort
                        .findById(refreshTokenDomain.getUserId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        String accessToken = tokenGeneratorPort.generateAccessToken(user);
        String refreshToken = tokenGeneratorPort.generateRefreshToken(user);

        refreshTokenDomain.renewToken(
                refreshToken,
                Instant.now().plusMillis(tokenGeneratorPort.getRefreshTokenExpirationMillis()));
        refreshTokenCommandPort.save(refreshTokenDomain);

        return new AuthResult(accessToken, refreshToken);
    }
}
