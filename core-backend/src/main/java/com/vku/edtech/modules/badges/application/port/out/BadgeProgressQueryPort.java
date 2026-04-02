package com.vku.edtech.modules.badges.application.port.out;

import java.util.UUID;

public interface BadgeProgressQueryPort {
  BadgeProgressSnapshot getProgress(UUID userId);

  record BadgeProgressSnapshot(int currentStreak, long enrollmentCount) {
  }
}
