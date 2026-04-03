package com.vku.edtech.modules.badges.application.port.out;

import com.vku.edtech.modules.badges.domain.model.Badge;
import java.util.UUID;

public interface BadgeCommandPort {
    Badge save(Badge badge);

    void deleteById(UUID id);
}
