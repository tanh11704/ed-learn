package com.vku.edtech.modules.lms.domain.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class CourseTest {

    @Test
    @DisplayName("Tạo course với title rỗng phải ném lỗi domain")
    void createNew_blankTitle() {
        assertThrows(InvalidDomainDataException.class, () -> Course.createNew(" ", "desc", "subject"));
    }

    @Test
    @DisplayName("Update course phải cập nhật đúng fields")
    void updateDetails_success() {
        Course course = course();

        course.updateDetails("New", "New desc", "IT", "thumb");

        assertEquals("New", course.getTitle());
        assertEquals("New desc", course.getDescription());
        assertEquals("IT", course.getSubject());
    }

    private Course course() {
        Instant now = Instant.now();
        return Course.builder().id(UUID.randomUUID()).title("Old").description("Old desc").subject("Math").createdAt(now).updatedAt(now).build();
    }
}
