package com.vku.edtech.modules.lms.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class Enrollment {
    private final UUID id;
    private final UUID userId;
    private final UUID courseId;
    private final Long price;
    private String status;
    private final Instant createdAt;
    private Instant updatedAt;

    public static Enrollment createNew(UUID userId, UUID courseId, Long price) {
        if (userId == null || courseId == null) {
            throw new InvalidDomainDataException("UserId và CourseId không được để trống");
        }
        return Enrollment.builder()
                .userId(userId)
                .courseId(courseId)
                .price(price != null ? price : 0L)
                .status("ACTIVE")
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }
}
