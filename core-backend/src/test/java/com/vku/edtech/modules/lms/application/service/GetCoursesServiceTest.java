package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.vku.edtech.modules.lms.application.port.in.GetCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.application.port.out.CourseVisibilityPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

class GetCoursesServiceTest {

    @Test
    @DisplayName("User thường không được query course đã xóa")
    void getCourses_user_doesNotIncludeDeletedCourses() {
        FakeCourseQueryPort courseQueryPort = new FakeCourseQueryPort();
        GetCoursesService service =
                new GetCoursesService(courseQueryPort, () -> false);

        CustomPage<Course> result =
                service.getCourses(
                        new GetCoursesUseCase.GetCoursesQuery(
                                "Math", PageRequest.of(0, 10)));

        assertFalse(courseQueryPort.includeDeleted);
        assertEquals("Math", courseQueryPort.subject);
        assertEquals(1, result.getTotalElements());
    }

    @Test
    @DisplayName("Admin được query cả course đã xóa")
    void getCourses_admin_includesDeletedCourses() {
        FakeCourseQueryPort courseQueryPort = new FakeCourseQueryPort();
        CourseVisibilityPort visibilityPort = () -> true;
        GetCoursesService service = new GetCoursesService(courseQueryPort, visibilityPort);

        service.getCourses(
                new GetCoursesUseCase.GetCoursesQuery(null, PageRequest.of(1, 20)));

        assertTrue(courseQueryPort.includeDeleted);
        assertEquals(1, courseQueryPort.pageable.getPageNumber());
        assertEquals(20, courseQueryPort.pageable.getPageSize());
    }

    private static class FakeCourseQueryPort implements CourseQueryPort {
        private String subject;
        private Pageable pageable;
        private boolean includeDeleted;

        @Override
        public Page<Course> findCourses(
                String subject, Pageable pageable, boolean includeDeleted) {
            this.subject = subject;
            this.pageable = pageable;
            this.includeDeleted = includeDeleted;
            Course course =
                    Course.builder()
                            .id(UUID.randomUUID())
                            .title("Course")
                            .status("ACTIVE")
                            .createdAt(Instant.now())
                            .updatedAt(Instant.now())
                            .build();
            return new PageImpl<>(List.of(course), pageable, 1);
        }

        @Override
        public Optional<Course> findByIdWithChapters(UUID id) {
            return Optional.empty();
        }
    }
}
