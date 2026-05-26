package com.vku.edtech.modules.lms.infrastructure.persistence.entity;

import com.vku.edtech.shared.infrastructure.persistence.entity.BaseEntity;
import jakarta.persistence.*;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;

@Entity
@Table(name = "chapters")
@FilterDef(
        name = "lessonDeletedFilter",
        parameters = @ParamDef(name = "isDeleted", type = Boolean.class))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class ChapterJpaEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private CourseJpaEntity course;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private Integer orderIndex;

    @OneToMany(mappedBy = "chapter", cascade = CascadeType.ALL, orphanRemoval = true)
    @Filter(name = "lessonDeletedFilter", condition = "is_deleted = :isDeleted")
    @Builder.Default
    private Set<LessonJpaEntity> lessons = new LinkedHashSet<>();

    @Column(nullable = false)
    @Builder.Default
    private Boolean isDeleted = false;

    public void addLesson(LessonJpaEntity lesson) {
        lessons.add(lesson);
        lesson.setChapter(this);
    }

    public void removeLesson(LessonJpaEntity lesson) {
        lessons.remove(lesson);
        lesson.setChapter(null);
    }
}
