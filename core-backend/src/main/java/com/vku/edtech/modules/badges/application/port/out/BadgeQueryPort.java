package com.vku.edtech.modules.badges.application.port.out;

import com.vku.edtech.modules.badges.domain.model.Badge;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface BadgeQueryPort {
    Optional<Badge> findById(UUID id);

    Optional<Badge> findByCode(String code);

    boolean existByCode(String code);

    Page<Badge> findAll(Pageable pageable);
}
