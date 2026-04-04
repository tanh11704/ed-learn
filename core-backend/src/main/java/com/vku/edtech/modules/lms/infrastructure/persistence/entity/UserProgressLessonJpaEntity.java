package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.modules.lms.domain.model.LessonProgressStatus;
import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "user_progress_lessons")
@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class UserProgressLessonJpaEntity extends BaseEntity {

    @Column(nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private UUID lessonId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private LessonProgressStatus status;

    private Instant completedAt;
}
