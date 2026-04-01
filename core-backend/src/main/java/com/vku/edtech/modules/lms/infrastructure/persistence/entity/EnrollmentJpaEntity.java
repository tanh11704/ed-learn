package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "enrollments")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EnrollmentJpaEntity {
    @Id private UUID id;
    private UUID userId;
    private UUID courseId;
    private Long price;
    private String status;
    private Instant createdAt;
    private Instant updatedAt;
}
