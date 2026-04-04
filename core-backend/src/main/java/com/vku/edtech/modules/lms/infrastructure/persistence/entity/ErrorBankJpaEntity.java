package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "error_bank")
@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class ErrorBankJpaEntity extends BaseEntity {

    @Column(nullable = false)
    private UUID userId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String questionContent;

    @Column(columnDefinition = "TEXT")
    private String wrongAnswer;

    @Column(columnDefinition = "TEXT")
    private String correctAnswer;

    @Column(nullable = false)
    private int repetitionCount;

    @Column(nullable = false)
    private double easeFactor;

    @Column(nullable = false)
    private int intervalDays;

    @Column(nullable = false)
    private Instant nextReviewDate;
}
