package com.vku.edtech.modules.identity.infrastructure.persistence.mapper;

import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserStreakJpaEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserStreakPersistenceMapper {

    default UserStreakJpaEntity toEntity(UserStreak userStreak, UserJpaEntity userJpaEntity) {
        if (userStreak == null) {
            return null;
        }

        return UserStreakJpaEntity.builder()
                .id(userStreak.getId())
                .user(userJpaEntity)
                .currentStreak(userStreak.getCurrentStreak())
                .longestStreak(userStreak.getLongestStreak())
                .lastActivityDay(userStreak.getLastActivityDay())
                .streakFreezeCount(userStreak.getStreakFreezeCount())
                .status(userStreak.getStatus())
                .build();
    }

    default UserStreak toDomain(UserStreakJpaEntity userStreakJpaEntity) {
        if (userStreakJpaEntity == null) {
            return null;
        }

        return UserStreak.builder()
                .id(userStreakJpaEntity.getId())
                .userId(
                        userStreakJpaEntity.getUser() != null
                                ? userStreakJpaEntity.getUser().getId()
                                : null)
                .currentStreak(userStreakJpaEntity.getCurrentStreak())
                .longestStreak(userStreakJpaEntity.getLongestStreak())
                .lastActivityDay(userStreakJpaEntity.getLastActivityDay())
                .streakFreezeCount(userStreakJpaEntity.getStreakFreezeCount())
                .status(userStreakJpaEntity.getStatus())
                .build();
    }
}
