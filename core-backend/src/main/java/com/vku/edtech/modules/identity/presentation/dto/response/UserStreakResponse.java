package com.vku.edtech.modules.identity.presentation.dto.response;

import com.vku.edtech.modules.identity.domain.model.StreakStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStreakResponse {
    private UUID id;
    private UUID userId;
    private int currentStreak;
    private int longestStreak;
    private LocalDate lastActivityDay;
    private int streakFreezeCount;
    private StreakStatus status;
}
