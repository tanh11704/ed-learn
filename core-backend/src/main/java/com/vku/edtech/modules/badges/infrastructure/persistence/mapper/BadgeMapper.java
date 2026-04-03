package com.vku.edtech.modules.badges.infrastructure.persistence.mapper;

import com.vku.edtech.modules.badges.domain.model.Badge;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.BadgeJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface BadgeMapper {
    Badge toDomain(BadgeJpaEntity entity);

    BadgeJpaEntity toEntity(Badge domain);
}
