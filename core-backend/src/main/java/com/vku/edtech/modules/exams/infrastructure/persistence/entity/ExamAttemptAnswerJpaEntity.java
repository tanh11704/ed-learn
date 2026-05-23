package com.vku.edtech.modules.exams.infrastructure.persistence.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
@Table(name = "exam_attempt_answers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamAttemptAnswerJpaEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false)
    private UUID attemptId;

    @Column(nullable = false)
    private UUID questionId;

    private UUID selectedOptionId;

    @Column(columnDefinition = "TEXT")
    private String answerText;

    private Boolean correct;

    private Double score;

    private Instant createdAt;

    private Instant updatedAt;
}
