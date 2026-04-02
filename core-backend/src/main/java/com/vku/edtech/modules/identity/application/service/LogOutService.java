package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.port.in.LogOutUseCase;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenCommandPort;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenQueryPort;
import com.vku.edtech.modules.identity.application.port.out.TokenBlacklistPort;
import com.vku.edtech.modules.identity.application.port.out.TokenInspectionPort;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class LogOutService implements LogOutUseCase {

    private final RefreshTokenCommandPort refreshTokenCommandPort;
    private final RefreshTokenQueryPort refreshTokenQueryPort;
    private final TokenBlacklistPort tokenBlacklistPort;
    private final TokenInspectionPort tokenInspectionPort;

    @Override
    public void logOut(LogOutCommand command) {
        RefreshToken domain =
                refreshTokenQueryPort
                        .findByToken(command.refreshToken())
                        .orElseThrow(() -> new ResourceNotFoundException("Token không hợp lệ"));

        refreshTokenCommandPort.delete(domain);

        long rTtlInMillis = domain.getExpiresAt().toEpochMilli() - System.currentTimeMillis();
        if (rTtlInMillis > 0) {
            tokenBlacklistPort.blacklistToken(domain.getToken(), rTtlInMillis);
        }

        if (command.accessToken() != null) {
            long aTtlInMillis = tokenInspectionPort.getRemainingTtlInMillis(command.accessToken());
            if (aTtlInMillis > 0) {
                tokenBlacklistPort.blacklistToken(command.accessToken(), aTtlInMillis);
            }
        }
    }
}
