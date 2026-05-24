package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.UserStreak;
import java.util.Optional;
import java.util.UUID;

public interface UserStreakQueryPort {
    Optional<UserStreak> findByUserId(UUID userId);
}
