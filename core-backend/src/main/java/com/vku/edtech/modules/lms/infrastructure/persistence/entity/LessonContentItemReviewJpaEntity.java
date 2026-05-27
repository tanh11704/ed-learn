package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "lesson_content_item_reviews")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class LessonContentItemReviewJpaEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "item_id", nullable = false)
    private LessonContentItemJpaEntity item;

    @Column(nullable = false)
    private UUID userId;

    @Column(nullable = false)
    @Builder.Default
    private Integer repetitionCount = 0;

    @Column(nullable = false)
    @Builder.Default
    private Double easeFactor = 2.5;

    @Column(nullable = false)
    @Builder.Default
    private Integer intervalDays = 1;

    @Column(nullable = false)
    @Builder.Default
    private Instant nextReviewDate = Instant.now();
}
