package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserProgressLessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.UserProgressLesson;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserProgressLessonJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.UserProgressLessonMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.UserProgressLessonJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserProgressLessonPersistenceAdapter
        implements UserProgressLessonCommandPort, UserProgressLessonQueryPort {

    private final UserProgressLessonJpaRepository repository;
    private final UserProgressLessonMapper mapper;

    @Override
    public UserProgressLesson save(UserProgressLesson userProgressLesson) {
        UserProgressLessonJpaEntity saved = repository.save(mapper.toEntity(userProgressLesson));
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<UserProgressLesson> findByUserIdAndLessonId(UUID userId, UUID lessonId) {
        return repository.findByUserIdAndLessonId(userId, lessonId).map(mapper::toDomain);
    }

    @Override
    public long countCompletedByUserIdAndCourseId(UUID userId, UUID courseId) {
        return repository.countCompletedByUserIdAndCourseId(userId, courseId);
    }
}
