package com.vku.edtech.modules.identity.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStreak {
    private UUID id;
    private UUID userId;
    private int currentStreak;
    private int longestStreak;
    private LocalDate lastActivityDay;
    private int streakFreezeCount;
    private StreakStatus status;

    public boolean checkAndUpdateStatus(LocalDate today) {
        if (lastActivityDay == null) {
            if (this.status != StreakStatus.INACTIVE) {
                this.status = StreakStatus.INACTIVE;
                return true;
            }
            return false;
        }

        long daysBetween = ChronoUnit.DAYS.between(lastActivityDay, today);
        boolean changed = false;

        if (daysBetween == 0) {
            if (this.status != StreakStatus.ACTIVE) {
                this.status = StreakStatus.ACTIVE;
                changed = true;
            }
        } else if (daysBetween == 1) {
            if (this.status != StreakStatus.INACTIVE) {
                this.status = StreakStatus.INACTIVE;
                changed = true;
            }
        } else {
            if (this.status != StreakStatus.BROKEN || this.currentStreak != 0) {
                this.status = StreakStatus.BROKEN;
                this.currentStreak = 0;
                changed = true;
            }
        }
        return changed;
    }

    public void recordActivity(LocalDate today) {
        if (lastActivityDay == null) {
            this.lastActivityDay = today;
            this.currentStreak = 1;
            this.longestStreak = 1;
            this.status = StreakStatus.ACTIVE;
            return;
        }

        long daysBetween = ChronoUnit.DAYS.between(lastActivityDay, today);

        if (daysBetween == 0) {
            // Already active today, do nothing or just ensure status is active
            this.status = StreakStatus.ACTIVE;
        } else if (daysBetween == 1) {
            // Continued the streak
            this.lastActivityDay = today;
            this.currentStreak++;
            if (this.currentStreak > this.longestStreak) {
                this.longestStreak = this.currentStreak;
            }
            this.status = StreakStatus.ACTIVE;
        } else {
            // Streak broken, starting a new one
            this.lastActivityDay = today;
            this.currentStreak = 1;
            if (this.currentStreak > this.longestStreak) {
                this.longestStreak = this.currentStreak;
            }
            this.status = StreakStatus.ACTIVE;
        }
    }

    public static UserStreak createInitialStreak(UUID userId) {
        return UserStreak.builder()
                .userId(userId)
                .currentStreak(0)
                .longestStreak(0)
                .lastActivityDay(null)
                .streakFreezeCount(0)
                .status(StreakStatus.INACTIVE)
                .build();
    }
}
