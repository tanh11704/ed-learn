package com.vku.edtech.modules.identity.domain.model;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class UserStreakTest {

    @Test
    void testCreateInitialStreak() {
        UUID userId = UUID.randomUUID();
        UserStreak streak = UserStreak.createInitialStreak(userId);

        assertEquals(userId, streak.getUserId());
        assertEquals(0, streak.getCurrentStreak());
        assertEquals(0, streak.getLongestStreak());
        assertNull(streak.getLastActivityDay());
        assertEquals(StreakStatus.INACTIVE, streak.getStatus());
    }

    @Test
    void checkAndUpdateStatus_WhenLastActivityIsNull() {
        UserStreak streak = UserStreak.createInitialStreak(UUID.randomUUID());

        boolean changed = streak.checkAndUpdateStatus(LocalDate.now());

        assertFalse(changed, "Status is already INACTIVE, should not change");
        assertEquals(StreakStatus.INACTIVE, streak.getStatus());
    }

    @Test
    void checkAndUpdateStatus_WhenDifferenceIsZero_ShouldKeepActive() {
        LocalDate today = LocalDate.now();
        UserStreak streak =
                UserStreak.builder().lastActivityDay(today).status(StreakStatus.ACTIVE).build();

        boolean changed = streak.checkAndUpdateStatus(today);

        assertFalse(changed);
        assertEquals(StreakStatus.ACTIVE, streak.getStatus());
    }

    @Test
    void checkAndUpdateStatus_WhenDifferenceIsOne_ShouldSetToInactive() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        LocalDate today = LocalDate.now();

        UserStreak streak =
                UserStreak.builder().lastActivityDay(yesterday).status(StreakStatus.ACTIVE).build();

        boolean changed = streak.checkAndUpdateStatus(today);

        assertTrue(changed);
        assertEquals(StreakStatus.INACTIVE, streak.getStatus());
    }

    @Test
    void checkAndUpdateStatus_WhenDifferenceIsGreaterThanOne_ShouldBreakStreak() {
        LocalDate twoDaysAgo = LocalDate.now().minusDays(2);
        LocalDate today = LocalDate.now();

        UserStreak streak =
                UserStreak.builder()
                        .lastActivityDay(twoDaysAgo)
                        .status(StreakStatus.INACTIVE)
                        .currentStreak(5)
                        .build();

        boolean changed = streak.checkAndUpdateStatus(today);

        assertTrue(changed);
        assertEquals(StreakStatus.BROKEN, streak.getStatus());
        assertEquals(0, streak.getCurrentStreak());
    }

    @Test
    void recordActivity_WhenLastActivityIsNull_ShouldStartStreak() {
        LocalDate today = LocalDate.now();
        UserStreak streak = UserStreak.createInitialStreak(UUID.randomUUID());

        streak.recordActivity(today);

        assertEquals(today, streak.getLastActivityDay());
        assertEquals(1, streak.getCurrentStreak());
        assertEquals(1, streak.getLongestStreak());
        assertEquals(StreakStatus.ACTIVE, streak.getStatus());
    }

    @Test
    void recordActivity_WhenDifferenceIsZero_ShouldDoNothing() {
        LocalDate today = LocalDate.now();
        UserStreak streak =
                UserStreak.builder()
                        .lastActivityDay(today)
                        .currentStreak(5)
                        .longestStreak(10)
                        .status(StreakStatus.ACTIVE)
                        .build();

        streak.recordActivity(today);

        assertEquals(today, streak.getLastActivityDay());
        assertEquals(5, streak.getCurrentStreak(), "Streak should not increase for the same day");
        assertEquals(StreakStatus.ACTIVE, streak.getStatus());
    }

    @Test
    void recordActivity_WhenDifferenceIsOne_ShouldIncreaseStreak() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        LocalDate today = LocalDate.now();

        UserStreak streak =
                UserStreak.builder()
                        .lastActivityDay(yesterday)
                        .currentStreak(5)
                        .longestStreak(5)
                        .status(StreakStatus.ACTIVE)
                        .build();

        streak.recordActivity(today);

        assertEquals(today, streak.getLastActivityDay());
        assertEquals(6, streak.getCurrentStreak());
        assertEquals(6, streak.getLongestStreak());
        assertEquals(StreakStatus.ACTIVE, streak.getStatus());
    }

    @Test
    void recordActivity_WhenDifferenceIsGreaterThanOne_ShouldRestartStreak() {
        LocalDate twoDaysAgo = LocalDate.now().minusDays(2);
        LocalDate today = LocalDate.now();

        UserStreak streak =
                UserStreak.builder()
                        .lastActivityDay(twoDaysAgo)
                        .currentStreak(5)
                        .longestStreak(10)
                        .status(StreakStatus.BROKEN)
                        .build();

        streak.recordActivity(today);

        assertEquals(today, streak.getLastActivityDay());
        assertEquals(1, streak.getCurrentStreak(), "Streak should reset to 1");
        assertEquals(10, streak.getLongestStreak(), "Longest streak should remain 10");
        assertEquals(StreakStatus.ACTIVE, streak.getStatus());
    }
}
