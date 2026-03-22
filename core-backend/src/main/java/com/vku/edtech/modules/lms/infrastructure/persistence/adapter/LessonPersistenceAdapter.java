package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.LessonMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.LessonJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

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
    public Lesson save(Lesson lesson) {
        LessonJpaEntity entity = lessonMapper.toEntity(lesson);
        LessonJpaEntity savedEntity = lessonJpaRepository.save(entity);
        return lessonMapper.toDomain(savedEntity);
    }
}
