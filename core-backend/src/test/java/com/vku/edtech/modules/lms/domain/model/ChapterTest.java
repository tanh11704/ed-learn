package com.vku.edtech.modules.lms.domain.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class ChapterTest {

    @Test
    @DisplayName("Tạo chapter với title rỗng phải ném lỗi domain")
    void createNew_blankTitle() {
        assertThrows(InvalidDomainDataException.class, () -> Chapter.createNew(UUID.randomUUID(), "", 1));
    }

    @Test
    @DisplayName("Update chapter phải đổi title và orderIndex")
    void updateDetails_success() {
        Chapter chapter = chapter();

        chapter.updateDetails("New", 2);

        assertEquals("New", chapter.getTitle());
        assertEquals(2, chapter.getOrderIndex());
    }

    private Chapter chapter() {
        Instant now = Instant.now();
        return Chapter.builder().id(UUID.randomUUID()).courseId(UUID.randomUUID()).title("Old").orderIndex(1).isDeleted(false).createdAt(now).updatedAt(now).build();
    }
}
