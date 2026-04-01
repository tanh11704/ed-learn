package com.vku.edtech.modules.identity.application.port.in;

import com.vku.edtech.modules.identity.domain.model.UserStreak;
import java.util.UUID;

public interface CheckUserStreakUseCase {
    UserStreak getUserStreak(CheckUserStreakCommand command);

    UserStreak recordActivity(CheckUserStreakCommand command);

    record CheckUserStreakCommand(UUID userId) {}
}
