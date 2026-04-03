package com.vku.edtech.modules.badges.application.port.in;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import java.util.UUID;

public interface UpdateBadgeUseCase {
    void updateBadge(UpdateBadgeCommand command);

    record UpdateBadgeCommand(
            UUID id,
            String code,
            String name,
            String description,
            String imageUrl,
            BadgeCategory category,
            Integer xpReward) {}
}
