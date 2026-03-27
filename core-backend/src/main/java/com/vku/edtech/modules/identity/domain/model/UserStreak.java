package com.vku.edtech.modules.identity.domain.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

public class UserStreak {
    private UUID id;
    private UUID userId;
    private int currentStreak;
    private int longestStreak;
    private LocalDate lastActivityDay;
    private int streakFreezeCount;
    private StreakStatus status;

    public UserStreak() {}

    public UserStreak(UUID id, UUID userId, int currentStreak, int longestStreak, LocalDate lastActivityDay, int streakFreezeCount, StreakStatus status) {
        this.id = id;
        this.userId = userId;
        this.currentStreak = currentStreak;
        this.longestStreak = longestStreak;
        this.lastActivityDay = lastActivityDay;
        this.streakFreezeCount = streakFreezeCount;
        this.status = status;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getUserId() { return userId; }
    public void setUserId(UUID userId) { this.userId = userId; }

    public int getCurrentStreak() { return currentStreak; }
    public void setCurrentStreak(int currentStreak) { this.currentStreak = currentStreak; }

    public int getLongestStreak() { return longestStreak; }
    public void setLongestStreak(int longestStreak) { this.longestStreak = longestStreak; }

    public LocalDate getLastActivityDay() { return lastActivityDay; }
    public void setLastActivityDay(LocalDate lastActivityDay) { this.lastActivityDay = lastActivityDay; }

    public int getStreakFreezeCount() { return streakFreezeCount; }
    public void setStreakFreezeCount(int streakFreezeCount) { this.streakFreezeCount = streakFreezeCount; }

    public StreakStatus getStatus() { return status; }
    public void setStatus(StreakStatus status) { this.status = status; }

    public static UserStreakBuilder builder() {
        return new UserStreakBuilder();
    }

    public static class UserStreakBuilder {
        private UUID id;
        private UUID userId;
        private int currentStreak;
        private int longestStreak;
        private LocalDate lastActivityDay;
        private int streakFreezeCount;
        private StreakStatus status;

        UserStreakBuilder() {}

        public UserStreakBuilder id(UUID id) {
            this.id = id;
            return this;
        }

        public UserStreakBuilder userId(UUID userId) {
            this.userId = userId;
            return this;
        }

        public UserStreakBuilder currentStreak(int currentStreak) {
            this.currentStreak = currentStreak;
            return this;
        }

        public UserStreakBuilder longestStreak(int longestStreak) {
            this.longestStreak = longestStreak;
            return this;
        }

        public UserStreakBuilder lastActivityDay(LocalDate lastActivityDay) {
            this.lastActivityDay = lastActivityDay;
            return this;
        }

        public UserStreakBuilder streakFreezeCount(int streakFreezeCount) {
            this.streakFreezeCount = streakFreezeCount;
            return this;
        }

        public UserStreakBuilder status(StreakStatus status) {
            this.status = status;
            return this;
        }

        public UserStreak build() {
            return new UserStreak(id, userId, currentStreak, longestStreak, lastActivityDay, streakFreezeCount, status);
        }
    }

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
