package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.RefreshToken;

public interface RefreshTokenCommandPort {

    RefreshToken save(RefreshToken domain);

    void delete(RefreshToken domain);
}
