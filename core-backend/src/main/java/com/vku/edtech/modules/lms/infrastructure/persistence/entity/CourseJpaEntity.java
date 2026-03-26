package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.*;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "courses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class CourseJpaEntity extends BaseEntity {

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String subject;

    private String thumbnailUrl;

    @Column(nullable = false, length = 50)
    @Builder.Default
    private String status = "ACTIVE";

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private Set<ChapterJpaEntity> chapters = new LinkedHashSet<>();

    public void addChapter(ChapterJpaEntity chapter) {
        chapters.add(chapter);
        chapter.setCourse(this);
    }

    public void removeChapter(ChapterJpaEntity chapter) {
        chapters.remove(chapter);
        chapter.setCourse(null);
    }
}
