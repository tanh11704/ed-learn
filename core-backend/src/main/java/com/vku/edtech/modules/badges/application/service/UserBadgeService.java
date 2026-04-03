package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.application.port.in.GetMyBadgesUseCase;
import com.vku.edtech.modules.badges.application.port.out.UserBadgeQueryPort;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@Transactional
@RequiredArgsConstructor
public class UserBadgeService implements GetMyBadgesUseCase {

    private final UserBadgeQueryPort userBadgeQueryPort;

    @Override
    public Page<UserBadgeResult> getMyBadges(GetMyBadgesQuery query) {
        return userBadgeQueryPort.findMyBadges(query.userId(), query.pageable());
    }
}
