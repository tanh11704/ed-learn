package com.vku.edtech.modules.badges.application.service;

import com.vku.edtech.modules.badges.application.port.in.DeleteBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeCommandPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteBadgeService implements DeleteBadgeUseCase {

    private final BadgeCommandPort badgeCommandPort;

    @Override
    @Transactional
    public void deleteBadge(DeleteBadgeCommand command) {
        badgeCommandPort.deleteById(command.id());
    }
}
