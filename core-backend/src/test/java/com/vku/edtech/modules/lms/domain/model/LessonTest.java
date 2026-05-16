package com.vku.edtech.modules.lms.domain.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class LessonTest {

    @Test
    @DisplayName("Create lesson với title rỗng phải ném lỗi")
    void create_blankTitle() {
        assertThrows(
                InvalidDomainDataException.class,
                () -> Lesson.create(UUID.randomUUID(), " ", 1, false));
    }

    @Test
    @DisplayName("Update lesson phải cập nhật title và preview")
    void updateDetails_success() {
        Lesson lesson = lesson();

        lesson.updateDetails(UUID.randomUUID(), "New", 2, true);

        assertEquals("New", lesson.getTitle());
        assertEquals(2, lesson.getOrderIndex());
    }

    private Lesson lesson() {
        Instant now = Instant.now();
        return Lesson.builder().id(UUID.randomUUID()).chapterId(UUID.randomUUID()).title("Old").orderIndex(1).isDeleted(false).createdAt(now).updatedAt(now).build();
    }
}
