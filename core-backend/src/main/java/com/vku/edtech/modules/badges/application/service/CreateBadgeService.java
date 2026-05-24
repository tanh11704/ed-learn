package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.port.in.CreateBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeCommandPort;
import com.vku.edtech.modules.badges.domain.model.Badge;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateBadgeService implements CreateBadgeUseCase {

    private final BadgeCommandPort badgeCommandPort;

    @Override
    @Transactional
    public Badge createBadge(CreateBadgeCommand command) {
        Badge badge =
                new Badge(
                        null,
                        command.code(),
                        command.name(),
                        command.description(),
                        command.category(),
                        command.imageUrl(),
                        command.xpReward());
        return badgeCommandPort.save(badge);
    }
}
