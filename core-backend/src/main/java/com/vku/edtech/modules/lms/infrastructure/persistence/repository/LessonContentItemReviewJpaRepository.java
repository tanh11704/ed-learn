package com.vku.edtech.modules.lms.infrastructure.persistence.repository;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonContentItemReviewJpaEntity;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LessonContentItemReviewJpaRepository
        extends JpaRepository<LessonContentItemReviewJpaEntity, UUID> {

    Optional<LessonContentItemReviewJpaEntity> findByItemIdAndUserId(UUID itemId, UUID userId);

    List<LessonContentItemReviewJpaEntity> findByItemIdInAndUserId(List<UUID> itemIds, UUID userId);

    void deleteByItemId(UUID itemId);
}
