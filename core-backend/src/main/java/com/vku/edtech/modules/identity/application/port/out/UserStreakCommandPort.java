package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.UserStreak;

public interface UserStreakCommandPort {
    UserStreak save(UserStreak userStreak);
}
