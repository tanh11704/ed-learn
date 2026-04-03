package com.vku.edtech.modules.badges.application.port.in;

import com.vku.edtech.modules.badges.domain.model.Badge;
import java.util.UUID;

public interface GetBadgeUseCase {
    Badge getBadge(GetBadgeQuery query);

    record GetBadgeQuery(UUID id) {}
}
