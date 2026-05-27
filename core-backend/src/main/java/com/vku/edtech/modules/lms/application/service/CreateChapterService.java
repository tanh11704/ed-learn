package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.CreateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateChapterService implements CreateChapterUseCase {

    private final ChapterCommandPort chapterCommandPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional
    @Caching(
            evict = {
                @CacheEvict(value = "courseDetail", key = "#command.courseId()"),
                @CacheEvict(value = "coursePage", allEntries = true)
            })
    public Chapter createChapter(CreateChapterCommand command) {
        int finalOrderIdx = chapterQueryPort.findMaxOrderIdxByCourseId(command.courseId()) + 1;

        Chapter chapter = Chapter.createNew(command.courseId(), command.title(), finalOrderIdx);

        return chapterCommandPort.save(chapter);
    }
}
