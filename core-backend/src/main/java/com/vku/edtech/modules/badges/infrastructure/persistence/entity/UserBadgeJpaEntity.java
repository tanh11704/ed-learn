package com.vku.edtech.modules.badges.infrastructure.persistence.entity;

import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
    name = "user_badges",
    indexes = {
        @Index(name = "idx_user_badges_user_id", columnList = "user_id"),
        @Index(name = "idx_user_badges_badge_id", columnList = "badge_id")
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserBadgeJpaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserJpaEntity user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "badge_id", nullable = false)
    private BadgeJpaEntity badge;

    @Column(name = "earned_at", nullable = false)
    private LocalDateTime earnedAt;

    @Column(name = "is_new", nullable = false)
    private Boolean isNew;
}