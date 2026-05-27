package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.CourseJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.ChapterMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.ChapterJpaRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ChapterPersistenceAdapter implements ChapterCommandPort, ChapterQueryPort {

    private final ChapterJpaRepository chapterJpaRepository;
    private final ChapterMapper chapterMapper;
    private final EntityManager entityManager;

    @Override
    public Chapter save(Chapter chapter) {
        ChapterJpaEntity entity = chapterMapper.toEntity(chapter);
        ChapterJpaEntity savedEntity = chapterJpaRepository.save(entity);
        return chapterMapper.toDomain(savedEntity);
    }

    @Override
    public Chapter delete(UUID id) {
        chapterJpaRepository
                .findById(id)
                .ifPresent(
                        entity -> {
                            entity.setIsDeleted(true);
                            chapterJpaRepository.save(entity);
                        });

        return null;
    }

    @Override
    public Optional<Chapter> findById(UUID id) {
        return chapterJpaRepository.findById(id).map(chapterMapper::toDomain);
    }

    @Override
    public List<Chapter> findAllByCourseIdWithLessons(UUID courseId, String status) {
        Session session = entityManager.unwrap(Session.class);
        if ("ACTIVE".equals(status) || "DELETED".equals(status)) {
            session.enableFilter("lessonDeletedFilter")
                    .setParameter("isDeleted", "DELETED".equals(status));
        }
        try {
            return chapterJpaRepository.findAllByCourseIdWithLessons(courseId, status).stream()
                    .map(chapterMapper::toDomain)
                    .sorted(Comparator.comparing(Chapter::getOrderIndex).thenComparing(Chapter::getId))
                    .toList();
        } finally {
            session.disableFilter("lessonDeletedFilter");
        }
    }

    @Override
    public int findMaxOrderIdxByCourseId(UUID courseId) {
        Integer maxIdx = chapterJpaRepository.findMaxOrderIdxByCourseId(courseId);
        return Optional.ofNullable(maxIdx).orElse(0);
    }

    @Override
    public void lockCourseForOrdering(UUID courseId) {
        entityManager.find(CourseJpaEntity.class, courseId, LockModeType.PESSIMISTIC_WRITE);
    }

    @Override
    public List<UUID> findActiveChapterIdsByCourseId(UUID courseId) {
        return chapterJpaRepository.findActiveChapterIdsByCourseId(courseId);
    }

    @Override
    public void updateOrderIndex(UUID chapterId, int orderIndex) {
        chapterJpaRepository.updateOrderIndex(chapterId, orderIndex);
    }

    @Override
    public void flush() {
        chapterJpaRepository.flush();
    }
}
