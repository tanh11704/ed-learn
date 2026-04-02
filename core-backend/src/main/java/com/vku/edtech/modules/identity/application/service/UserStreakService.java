package com.vku.edtech.modules.identity.application.service;

import com.vku.edtech.modules.identity.application.port.in.CheckUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.in.CreateUserStreakUseCase;
import com.vku.edtech.modules.identity.application.port.out.UserStreakPort;
import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserStreakService implements CheckUserStreakUseCase, CreateUserStreakUseCase {

    private final UserStreakPort userStreakPort;

    @Override
    public UserStreak createInitialStreak(UUID userId) {
        UserStreak newStreak = UserStreak.createInitialStreak(userId);
        return userStreakPort.save(newStreak);
    }

    @Override
    public UserStreak getUserStreak(CheckUserStreakCommand command) {
        UserStreak userStreak =
                userStreakPort
                        .findByUserId(command.userId())
                        .orElseThrow(
                                () ->
                                        new ResourceNotFoundException(
                                                "User streak not found for user: "
                                                        + command.userId()));

        // Lấy ngày hiện tại theo múi giờ Việt Nam
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));

        boolean changed = userStreak.checkAndUpdateStatus(today);
        if (changed) {
            return userStreakPort.save(userStreak);
        }
        return userStreak;
    }

    @Override
    public UserStreak recordActivity(CheckUserStreakCommand command) {
        UserStreak userStreak =
                userStreakPort
                        .findByUserId(command.userId())
                        .orElseThrow(
                                () ->
                                        new ResourceNotFoundException(
                                                "User streak not found for user: "
                                                        + command.userId()));

        // Lấy ngày hiện tại theo múi giờ Việt Nam
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));

        userStreak.recordActivity(today);
        return userStreakPort.save(userStreak);
    }
}
