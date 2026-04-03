package com.vku.edtech.modules.badges.infrastructure.persistence.adapter;

import com.vku.edtech.modules.badges.application.port.out.BadgeCommandPort;
import com.vku.edtech.modules.badges.application.port.out.BadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.Badge;
import com.vku.edtech.modules.badges.infrastructure.persistence.mapper.BadgeMapper;
import com.vku.edtech.modules.badges.infrastructure.persistence.repository.BadgeJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class BadgePersistenceAdapter implements BadgeQueryPort, BadgeCommandPort {

    private final BadgeJpaRepository badgeJpaRepository;
    private final BadgeMapper badgeMapper;

    @Override
    public Badge save(Badge badge) {
        return badgeMapper.toDomain(badgeJpaRepository.save(badgeMapper.toEntity(badge)));
    }

    @Override
    public void deleteById(UUID id) {
        badgeJpaRepository.deleteById(id);
    }

    @Override
    public Optional<Badge> findById(UUID id) {
        return badgeJpaRepository.findById(id).map(badgeMapper::toDomain);
    }

    @Override
    public Optional<Badge> findByCode(String code) {
        return badgeJpaRepository.findByCode(code).map(badgeMapper::toDomain);
    }

    @Override
    public boolean existByCode(String code) {
        return badgeJpaRepository.existsByCode(code);
    }

    @Override
    public Page<Badge> findAll(Pageable pageable) {
        return badgeJpaRepository.findAll(pageable).map(badgeMapper::toDomain);
    }
}
