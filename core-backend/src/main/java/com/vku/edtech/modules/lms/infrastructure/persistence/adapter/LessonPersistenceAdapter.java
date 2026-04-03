package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.LessonMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.LessonJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class LessonPersistenceAdapter implements LessonCommandPort, LessonQueryPort {

    private final LessonJpaRepository lessonJpaRepository;
    private final LessonMapper lessonMapper;

    @Override
    public Optional<Lesson> findById(UUID id) {
        return lessonJpaRepository.findById(id).map(lessonMapper::toDomain);
    }

    @Override
    public Optional<Lesson> findByIdAndNotDeleted(UUID id) {
        return lessonJpaRepository.findByIdAndNotDeleted(id).map(lessonMapper::toDomain);
    }

    @Override
    public Optional<Integer> findMaxOrderIndexByChapterId(UUID chapterId) {
        return lessonJpaRepository.findMaxOrderIndexByChapterId(chapterId);
    }

    @Override
    public Optional<UUID> findCourseIdByLessonId(UUID lessonId) {
        return lessonJpaRepository.findCourseIdByLessonId(lessonId);
    }

    @Override
    public long countLessonsByCourseId(UUID courseId) {
        return lessonJpaRepository.countLessonsByCourseId(courseId);
    }

    @Override
    public Lesson save(Lesson lesson) {
        LessonJpaEntity entity = lessonMapper.toEntity(lesson);
        LessonJpaEntity savedEntity = lessonJpaRepository.save(entity);
        return lessonMapper.toDomain(savedEntity);
    }
}
