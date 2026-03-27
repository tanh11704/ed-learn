package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.domain.model.UserStreak;

import java.util.UUID;

public interface CheckUserStreakUseCase {
    UserStreak getUserStreak(UUID userId);
    UserStreak recordActivity(UUID userId);
}
