package com.vku.edtech.modules.badges.application.port.in;

import java.util.UUID;

public interface DeleteBadgeUseCase {
    void deleteBadge(DeleteBadgeCommand command);

    record DeleteBadgeCommand(UUID id) {}
}
