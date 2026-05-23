package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.port.in.GetBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.Badge;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetBadgeService implements GetBadgeUseCase {

    private final BadgeQueryPort badgeQueryPort;

    @Override
    @Transactional(readOnly = true)
    public Badge getBadge(GetBadgeQuery query) {
        return badgeQueryPort
                .findById(query.id())
                .orElseThrow(() -> new RuntimeException("Badge not found"));
    }
}
