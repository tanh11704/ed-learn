package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.ChapterJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.mapper.ChapterMapper;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.ChapterJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class ChapterPersistenceAdapter implements ChapterCommandPort, ChapterQueryPort {

    private final ChapterJpaRepository chapterJpaRepository;
    private final ChapterMapper chapterMapper;

    @Override
    public Chapter save(Chapter chapter) {
        ChapterJpaEntity entity = chapterMapper.toEntity(chapter);
        ChapterJpaEntity savedEntity = chapterJpaRepository.save(entity);
        return chapterMapper.toDomain(savedEntity);
    }

    @Override
    public Chapter delete(UUID id) {
        chapterJpaRepository.findById(id).ifPresent(entity -> {
            entity.setIsDeleted(true);
            chapterJpaRepository.save(entity);
        });

        return null;
    }

    @Override
    public Optional<Chapter> findById(UUID id) {
        return chapterJpaRepository.findById(id)
                .map(chapterMapper::toDomain);
    }

    @Override
    public List<Chapter> findAllByCourseIdWithLessons(UUID courseId) {
        return chapterJpaRepository.findAllByCourseIdWithLessons(courseId).stream()
                .map(chapterMapper::toDomain)
                .toList();
    }

    @Override
    public int findMaxOrderIdxByCourseId(UUID courseId) {
        Integer maxIdx = chapterJpaRepository.findMaxOrderIdxByCourseId(courseId);
        return Optional.ofNullable(maxIdx).orElse(0);
    }
}
