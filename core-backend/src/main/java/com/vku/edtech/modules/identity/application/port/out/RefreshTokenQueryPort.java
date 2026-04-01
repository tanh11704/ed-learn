package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import java.util.Optional;

public interface RefreshTokenQueryPort {
    Optional<RefreshToken> findByToken(String refreshToken);
}
