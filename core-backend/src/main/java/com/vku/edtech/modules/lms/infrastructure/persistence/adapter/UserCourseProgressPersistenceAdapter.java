package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.UserCourseProgressCommandPort;
import com.vku.edtech.modules.lms.application.port.out.UserCourseProgressQueryPort;
import com.vku.edtech.modules.lms.domain.model.UserCourseProgress;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.UserCourseProgressJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.UserCourseProgressMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.UserCourseProgressJpaRepository;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserCourseProgressPersistenceAdapter
        implements UserCourseProgressCommandPort, UserCourseProgressQueryPort {

    private final UserCourseProgressJpaRepository repository;
    private final UserCourseProgressMapper mapper;

    @Override
    public UserCourseProgress save(UserCourseProgress userCourseProgress) {
        UserCourseProgressJpaEntity saved = repository.save(mapper.toEntity(userCourseProgress));
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<UserCourseProgress> findByUserIdAndCourseId(UUID userId, UUID courseId) {
        return repository.findByUserIdAndCourseId(userId, courseId).map(mapper::toDomain);
    }
}
