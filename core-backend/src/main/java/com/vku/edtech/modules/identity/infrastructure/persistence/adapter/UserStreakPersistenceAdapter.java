package com.vku.edtech.modules.identity.infrastructure.persistence.adapter;

import com.vku.edtech.modules.identity.application.port.out.UserStreakPort;
import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserStreakJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.mapper.UserStreakPersistenceMapper;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaUserStreakRepository;
import jakarta.persistence.EntityManager;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserStreakPersistenceAdapter implements UserStreakPort {

    private final JpaUserStreakRepository userStreakRepository;
    private final EntityManager entityManager;
    private final UserStreakPersistenceMapper userStreakMapper;

    @Override
    public Optional<UserStreak> findByUserId(UUID userId) {
        return userStreakRepository.findByUserId(userId).map(userStreakMapper::toDomain);
    }

    @Override
    public UserStreak save(UserStreak userStreak) {
        UserJpaEntity userRef =
                entityManager.getReference(UserJpaEntity.class, userStreak.getUserId());

        UserStreakJpaEntity entity = userStreakMapper.toEntity(userStreak, userRef);

        if (userStreak.getId() != null) {
            entity.setId(userStreak.getId());
        }

        UserStreakJpaEntity savedEntity = userStreakRepository.save(entity);
        return userStreakMapper.toDomain(savedEntity);
    }
}
