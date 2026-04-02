package com.vku.edtech.modules.identity.infrastructure.persistence.adapter;

import com.vku.edtech.modules.identity.application.port.out.RefreshTokenCommandPort;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenQueryPort;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.RefreshTokenJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.mapper.RefreshTokenPersistenceMapper;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaRefreshTokenRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class RefreshTokenPersistenceAdapter
        implements RefreshTokenCommandPort, RefreshTokenQueryPort {

    private final JpaRefreshTokenRepository jpaRefreshTokenRepository;
    private final RefreshTokenPersistenceMapper mapper;

    @Override
    public RefreshToken save(RefreshToken domain) {

        RefreshTokenJpaEntity entity = mapper.toEntity(domain);

        RefreshTokenJpaEntity saveEntity = jpaRefreshTokenRepository.save(entity);

        return mapper.toDomain(saveEntity);
    }

    @Override
    public void delete(RefreshToken domain) {
        jpaRefreshTokenRepository
                .findByToken(domain.getToken())
                .ifPresent(jpaRefreshTokenRepository::delete);
    }

    @Override
    public Optional<RefreshToken> findByToken(String refreshToken) {
        return jpaRefreshTokenRepository.findByToken(refreshToken).map(mapper::toDomain);
    }
}
