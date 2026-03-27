package com.vku.edtech.modules.identity.infrastructure.persistence.adapter;

import com.vku.edtech.modules.identity.application.port.out.UserStreakPort;
import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserStreakJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.mapper.UserStreakPersistenceMapper;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaUserRepository;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaUserStreakRepository;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class UserStreakPersistenceAdapter implements UserStreakPort {

    private final JpaUserStreakRepository userStreakRepository;
    private final JpaUserRepository userRepository;
    private final UserStreakPersistenceMapper userStreakMapper;

    @Override
    public Optional<UserStreak> findByUserId(UUID userId) {
        return userStreakRepository.findByUserId(userId)
                .map(userStreakMapper::toDomain);
    }

    @Override
    @Transactional
    public UserStreak save(UserStreak userStreak) {
        UserJpaEntity user = userRepository.findById(userStreak.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userStreak.getUserId()));

        UserStreakJpaEntity entity = userStreakMapper.toEntity(userStreak, user);
        
        if (userStreak.getId() != null) {
            entity.setId(userStreak.getId());
        }
        
        UserStreakJpaEntity savedEntity = userStreakRepository.save(entity);
        return userStreakMapper.toDomain(savedEntity);
    }
}
