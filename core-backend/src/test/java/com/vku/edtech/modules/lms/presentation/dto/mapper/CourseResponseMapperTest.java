package com.vku.edtech.modules.lms.presentation.dto.mapper;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.vku.edtech.modules.lms.domain.model.Course;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

class CourseResponseMapperTest {

    private final CourseResponseMapper mapper = Mappers.getMapper(CourseResponseMapper.class);

    @Test
    @DisplayName("Course status DELETED được map thành isDeleted true")
    void toResponse_deletedCourse_mapsIsDeletedTrue() {
        Course course = course("DELETED");

        assertTrue(mapper.toResponse(course).isDeleted());
    }

    @Test
    @DisplayName("Course status khác DELETED được map thành isDeleted false")
    void toResponse_activeCourse_mapsIsDeletedFalse() {
        Course course = course("ACTIVE");

        assertFalse(mapper.toResponse(course).isDeleted());
    }

    private Course course(String status) {
        Instant now = Instant.now();
        return Course.builder()
                .id(UUID.randomUUID())
                .title("Course")
                .description("Description")
                .subject("Subject")
                .thumbnailUrl("thumbnail.png")
                .status(status)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }
}
