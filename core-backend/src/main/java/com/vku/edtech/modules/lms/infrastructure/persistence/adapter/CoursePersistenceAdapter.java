package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.CourseJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.CourseMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.CourseJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class CoursePersistenceAdapter implements CourseQueryPort, CourseCommandPort {

    private final CourseJpaRepository courseJpaRepository;
    private final CourseMapper courseMapper;

    @Override
    public Page<Course> findCourses(String subject, Pageable pageable) {
        return courseJpaRepository.findBySubjectOrAll(subject, pageable)
                .map(courseMapper::toDomainSummary);
    }

    @Override
    public Optional<Course> findByIdWithChapters(UUID id) {
        return courseJpaRepository.findByIdWithChapters(id)
                .map(courseMapper::toDomain);
    }

    @Override
    public Course save(Course course) {
        CourseJpaEntity entity = courseMapper.toEntity(course);
        CourseJpaEntity savedEntity = courseJpaRepository.save(entity);
        return courseMapper.toDomain(savedEntity);
    }
}
