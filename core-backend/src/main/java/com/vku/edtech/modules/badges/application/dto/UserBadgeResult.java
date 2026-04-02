package com.vku.edtech.modules.badges.application.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;

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
        Boolean isNew) {

}
