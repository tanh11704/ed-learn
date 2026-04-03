package com.vku.edtech.modules.badges.application.dto;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import java.time.LocalDateTime;
import java.util.UUID;

public record UserBadgeResult(
        UUID userBadgeId,
        UUID badgeId,
        String badgeCode,
        String badgeName,
        String badgeDescription,
        BadgeCategory category,
        String imageUrl,
        Integer xpReward,
        LocalDateTime earnedAt,
        Boolean isNew) {}
