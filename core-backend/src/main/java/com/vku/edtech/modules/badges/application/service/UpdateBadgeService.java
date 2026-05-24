package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.port.in.UpdateBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeCommandPort;
import com.vku.edtech.modules.badges.application.port.out.BadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.Badge;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateBadgeService implements UpdateBadgeUseCase {

    private final BadgeQueryPort badgeQueryPort;
    private final BadgeCommandPort badgeCommandPort;

    @Override
    @Transactional
    public void updateBadge(UpdateBadgeCommand command) {
        Badge badge =
                badgeQueryPort
                        .findById(command.id())
                        .orElseThrow(() -> new RuntimeException("Badge not found"));

        badge.setCode(command.code());
        badge.setName(command.name());
        badge.setDescription(command.description());
        badge.setCategory(command.category());
        badge.setImageUrl(command.imageUrl());
        badge.setXpReward(command.xpReward());

        badgeCommandPort.save(badge);
    }
}
