package com.vku.edtech.modules.badges.infrastructure.persistence.mapper;

import com.vku.edtech.modules.badges.domain.model.UserBadge;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.UserBadgeJpaEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserBadgeMapper {

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "badgeId", source = "badge.id")
    UserBadge toDomain(UserBadgeJpaEntity entity);

    @Mapping(target = "user.id", source = "userId")
    @Mapping(target = "badge.id", source = "badgeId")
    UserBadgeJpaEntity toEntity(UserBadge domain);
}
