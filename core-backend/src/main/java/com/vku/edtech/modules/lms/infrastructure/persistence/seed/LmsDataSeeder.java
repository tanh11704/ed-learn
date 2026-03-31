package com.vku.edtech.modules.lms.infrastructure.persistence.seed;

import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.CourseJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.ChapterJpaRepository;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.CourseJpaRepository;
import java.util.LinkedHashSet;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

//@Component
@Profile({"dev", "local"})
@RequiredArgsConstructor
public class LmsDataSeeder implements CommandLineRunner {

    private final CourseJpaRepository courseRepository;
    private final ChapterJpaRepository chapterRepository;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        CourseJpaEntity course =
                CourseJpaEntity.builder()
                        .title("Lập trình Java Spring Boot Clean Architecture")
                        .description("Khóa học hướng dẫn xây dựng hệ thống LMS chuẩn chỉnh từ A-Z")
                        .subject("Backend")
                        .thumbnailUrl("https://img.youtube.com/vi/placeholder/0.jpg")
                        .chapters(new LinkedHashSet<>())
                        .build();

        ChapterJpaEntity chapter =
                ChapterJpaEntity.builder()
                        .title("Chương 1: Thiết kế Domain Model")
                        .orderIndex(1)
                        .course(course)
                        .lessons(new LinkedHashSet<>())
                        .build();

        LessonJpaEntity lesson =
                LessonJpaEntity.builder()
                        .title("Bài 1.1: Rich Domain Model vs Anemic Model")
                        .orderIndex(1)
                        .chapter(chapter)
                        .videoUrl("lessons/sample-video.mp4")
                        .build();

        chapter.addLesson(lesson);
        course.addChapter(chapter);

        courseRepository.save(course);
        System.out.println(">> LMS Data Seeded Successfully! 🚀");
    }
}
