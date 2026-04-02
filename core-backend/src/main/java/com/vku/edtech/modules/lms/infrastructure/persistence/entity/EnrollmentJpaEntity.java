package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "enrollments")
@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class EnrollmentJpaEntity extends BaseEntity {
    private UUID userId;
    private UUID courseId;
    private Long price;
    private String status;
}
