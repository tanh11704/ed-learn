package com.vku.edtech.modules.badges.application.port.in;

import com.vku.edtech.modules.badges.domain.model.Badge;
import com.vku.edtech.modules.badges.domain.model.BadgeCategory;

public interface CreateBadgeUseCase {
    Badge createBadge(CreateBadgeCommand command);

    record CreateBadgeCommand(
            String code,
            String name,
            String description,
            BadgeCategory category,
            String imageUrl,
            Integer xpReward) {}
}
