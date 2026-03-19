package com.vku.edtech.modules.identity.infrastructure.persistence.mapper;

import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserPersistenceMapper {

    UserJpaEntity toEntity(User domain);

    default User toDomain(UserJpaEntity userJpaEntity) {
        if (userJpaEntity == null) {
            return null;
        }

        return new User(
                userJpaEntity.getId(),
                userJpaEntity.getEmail(),
                userJpaEntity.getPasswordHash(),
                userJpaEntity.getFullName(),
                userJpaEntity.getRole(),
                userJpaEntity.getCreatedAt(),
                userJpaEntity.getUpdatedAt()
        );
    }
}
