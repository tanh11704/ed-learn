package com.vku.edtech.modules.identity.infrastructure.persistence.adapter;

import com.vku.edtech.modules.identity.application.port.out.UserCommandPort;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.mapper.UserPersistenceMapper;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaUserRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserPersistenceAdapter implements UserCommandPort, UserQueryPort {

    private final JpaUserRepository userRepository;
    private final UserPersistenceMapper mapper;

    @Override
    public User save(User user) {
        UserJpaEntity entity = mapper.toEntity(user);

        UserJpaEntity savedEntity = userRepository.save(entity);

        return mapper.toDomain(savedEntity);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findById(UUID id) {
        return userRepository.findById(id).map(mapper::toDomain);
    }
}
