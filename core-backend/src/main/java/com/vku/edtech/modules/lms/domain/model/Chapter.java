package com.vku.edtech.modules.lms.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class Chapter {
    private final UUID id;
    private UUID courseId;
    private String title;
    private Integer orderIndex;
    @Builder.Default private List<Lesson> lessons = new ArrayList<>();
    private Boolean isDeleted;
    private final Instant createdAt;
    private Instant updatedAt;

    public static Chapter createNew(UUID courseId, String title, Integer orderIndex) {
        if (title == null || title.isBlank()) {
            throw new InvalidDomainDataException("Tiêu đề chương không được để trống");
        }
        return Chapter.builder()
                .id(UUID.randomUUID())
                .courseId(courseId)
                .title(title)
                .orderIndex(orderIndex)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public void addLesson(Lesson lesson) {
        if (this.lessons == null) {
            this.lessons = new ArrayList<>();
        }
        this.lessons.add(lesson);
        this.updatedAt = Instant.now();
    }

    public void updateDetails(String title, Integer orderIndex) {
        if (title != null && !title.isBlank()) this.title = title;
        if (orderIndex != null) this.orderIndex = orderIndex;
        this.updatedAt = Instant.now();
    }

    public List<Lesson> getLessons() {
        return lessons == null ? Collections.emptyList() : Collections.unmodifiableList(lessons);
    }

    public void moveToCourse(UUID newCourseId, Integer newOrderIndex) {
        if (newCourseId == null) {
            throw new InvalidDomainDataException("ID của khóa học mới không hợp lệ");
        }
        this.courseId = newCourseId;
        this.orderIndex = newOrderIndex;
        this.updatedAt = Instant.now();
    }
}
