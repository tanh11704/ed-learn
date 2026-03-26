package com.vku.edtech.modules.lms.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class Course {
    private final UUID id;
    private String title;
    private String description;
    private String subject;
    private String thumbnailUrl;
    private String status;

    @Builder.Default
    private List<Chapter> chapters = new ArrayList<>();

    private final Instant createdAt;
    private Instant updatedAt;

    public static Course createNew(String title, String description, String subject) {
        if (title == null || title.isBlank()) {
            throw new InvalidDomainDataException("Tiêu đề khóa học không được để trống");
        }
        return Course.builder()
                .title(title)
                .description(description)
                .subject(subject)
                .status("ACTIVE")
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public void addChapter(Chapter chapter) {
        if (this.chapters == null) {
            this.chapters = new ArrayList<>();
        }
        this.chapters.add(chapter);
        this.updatedAt = Instant.now();
    }

    public void updateDetails(String title, String description, String subject, String thumbnailUrl) {
        if (title != null && !title.isBlank())
            this.title = title;
        if (description != null)
            this.description = description;
        if (subject != null)
            this.subject = subject;
        if (thumbnailUrl != null)
            this.thumbnailUrl = thumbnailUrl;
        this.updatedAt = Instant.now();
    }

    public void markAsDeleted() {
        this.status = "DELETED";
        this.updatedAt = Instant.now();
    }

    public List<Chapter> getChapters() {
        return chapters == null ? Collections.emptyList() : Collections.unmodifiableList(chapters);
    }
}
