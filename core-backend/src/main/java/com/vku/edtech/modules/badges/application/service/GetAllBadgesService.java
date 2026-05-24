package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.port.in.GetAllBadgesUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.Badge;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetAllBadgesService implements GetAllBadgesUseCase {

    private final BadgeQueryPort badgeQueryPort;

    @Override
    @Transactional(readOnly = true)
    public Page<Badge> getAllBadges(GetAllBadgesQuery query) {
        return badgeQueryPort.findAll(query.pageable());
    }
}
