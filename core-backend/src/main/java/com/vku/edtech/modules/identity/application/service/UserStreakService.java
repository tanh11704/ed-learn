package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.port.in.CheckUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.in.CreateUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.out.UserStreakPort;
import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserStreakService implements CheckUserStreakUseCase, CreateUserStreakUseCase {

    private final UserStreakPort userStreakPort;

    @Override
    public UserStreak createInitialStreak(UUID userId) {
        UserStreak newStreak = UserStreak.createInitialStreak(userId);
        return userStreakPort.save(newStreak);
    }

    @Override
    public UserStreak getUserStreak(UUID userId) {
        UserStreak userStreak = userStreakPort.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User streak not found for user: " + userId));

        boolean changed = userStreak.checkAndUpdateStatus(LocalDate.now());
        if (changed) {
            return userStreakPort.save(userStreak);
        }
        return userStreak;
    }

    @Override
    public UserStreak recordActivity(UUID userId) {
        UserStreak userStreak = userStreakPort.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User streak not found for user: " + userId));

        userStreak.recordActivity(LocalDate.now());
        return userStreakPort.save(userStreak);
    }
}
