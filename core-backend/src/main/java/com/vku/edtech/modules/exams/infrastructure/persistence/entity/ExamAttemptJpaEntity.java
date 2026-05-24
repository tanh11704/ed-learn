package com.vku.edtech.modules.exams.infrastructure.persistence.entity;

import com.vku.edtech.modules.exams.domain.model.ExamAttemptStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "exam_attempts")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamAttemptJpaEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false)
    private UUID examId;

    @Column(nullable = false)
    private UUID userId;

    @Column(nullable = false)
    private Integer gradeLevel;

    private String className;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ExamAttemptStatus status;

    @Column(nullable = false)
    private Instant startedAt;

    private Instant submittedAt;

    private Integer durationSeconds;

    private Double score;

    private Double maxScore;

    private Instant createdAt;

    private Instant updatedAt;
}
