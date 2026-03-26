package com.vku.edtech.modules.identity.infrastructure.persistence.mapper;

import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.RefreshTokenJpaEntity;
import java.util.UUID;
import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", builder = @Builder(disableBuilder = true))
public interface RefreshTokenPersistenceMapper {

    @Mapping(target = "userJpaEntity.id", source = "userId")
    RefreshTokenJpaEntity toEntity(RefreshToken domain);

    default RefreshToken toDomain(RefreshTokenJpaEntity refreshTokenJpaEntity) {
        if (refreshTokenJpaEntity == null) {
            return null;
        }

        UUID userId =
                refreshTokenJpaEntity.getUserJpaEntity() != null
                        ? refreshTokenJpaEntity.getUserJpaEntity().getId()
                        : null;

        return new RefreshToken(
                refreshTokenJpaEntity.getId(),
                refreshTokenJpaEntity.getToken(),
                refreshTokenJpaEntity.getExpiresAt(),
                refreshTokenJpaEntity.getDeviceInfo(),
                refreshTokenJpaEntity.getRevoked(),
                userId,
                refreshTokenJpaEntity.getCreatedAt(),
                refreshTokenJpaEntity.getUpdatedAt());
    }
}
