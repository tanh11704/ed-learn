package com.vku.edtech.modules.badges.application.port.out;

import com.vku.edtech.modules.badges.domain.model.UserBadge;

public interface UserBadgeCommandPort {
    UserBadge save(UserBadge userBadge);
}
