package com.vku.edtech.modules.badges.application.port.out;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.domain.model.UserBadge;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserBadgeQueryPort {
    Page<UserBadgeResult> findMyBadges(UUID userId, Pageable pageable);

    Optional<UserBadge> findByIdAndUserId(UUID userBadgeId, UUID userId);

    boolean existsByUserIdAndBadgeId(UUID userId, UUID badgeId);
}
