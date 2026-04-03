package com.vku.edtech.modules.badges.presentation.dto.response;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import java.util.UUID;

public record BadgeResponse(
        UUID id,
        String code,
        String name,
        String description,
        BadgeCategory category,
        String imageUrl,
        Integer xpReward) {}
