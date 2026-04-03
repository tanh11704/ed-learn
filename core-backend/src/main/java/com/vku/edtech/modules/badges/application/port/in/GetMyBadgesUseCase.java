package com.vku.edtech.modules.badges.application.port.in;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface GetMyBadgesUseCase {
    Page<UserBadgeResult> getMyBadges(GetMyBadgesQuery query);

    record GetMyBadgesQuery(UUID userId, Pageable pageable) {}
}
