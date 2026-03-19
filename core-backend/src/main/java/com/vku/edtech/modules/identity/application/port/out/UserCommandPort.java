package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.User;

public interface UserCommandPort {
    User save(User user);
}
