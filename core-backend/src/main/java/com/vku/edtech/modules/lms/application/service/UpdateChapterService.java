package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.exception.LmsNotFoundException;
import com.vku.edtech.modules.lms.application.port.in.UpdateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateChapterService implements UpdateChapterUseCase {

    private final ChapterQueryPort chapterQueryPort;
    private final ChapterCommandPort chapterCommandPort;
    private final CourseQueryPort courseQueryPort;

    @Override
    @Transactional
    @CacheEvict(value = {"courseDetail", "coursePage"}, allEntries = true)
    public Chapter updateChapter(UpdateChapterCommand command) {
        Chapter chapter =
                chapterQueryPort
                        .findById(command.chapterId())
                        .orElseThrow(() -> new LmsNotFoundException("Không tìm thấy chapter"));

        if (Boolean.TRUE.equals(chapter.getIsDeleted())) {
            throw new LmsNotFoundException("Chapter đã bị xóa");
        }

        if (command.courseId() != null && courseQueryPort.findByIdWithChapters(command.courseId()).isEmpty()) {
            throw new LmsNotFoundException("Không tìm thấy khóa học");
        }

        chapter.updateDetails(command.title(), null);
        if (command.courseId() != null && !command.courseId().equals(chapter.getCourseId())) {
            chapterQueryPort.lockCourseForOrdering(command.courseId());
            int nextOrderIndex = chapterQueryPort.findMaxOrderIdxByCourseId(command.courseId()) + 1;
            chapter.moveToCourse(command.courseId(), nextOrderIndex);
        }

        return chapterCommandPort.save(chapter);
    }
}
