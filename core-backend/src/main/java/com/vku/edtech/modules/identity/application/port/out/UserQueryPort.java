package com.vku.edtech.modules.identity.application.port.out;

import com.vku.edtech.modules.identity.domain.model.User;
import java.util.Optional;
import java.util.UUID;

public interface UserQueryPort {
    boolean existsByEmail(String email);

    Optional<User> findByEmail(String email);

    Optional<User> findById(UUID id);
}
