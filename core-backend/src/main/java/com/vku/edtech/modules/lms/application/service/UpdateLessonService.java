package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.exception.LmsBadRequestException;
import com.vku.edtech.modules.lms.application.port.in.UpdateLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateLessonService implements UpdateLessonUseCase {

    private final LessonCommandPort lessonCommandPort;
    private final LessonQueryPort lessonQueryPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional
    @CacheEvict(value = {"courseDetail", "coursePage"}, allEntries = true)
    public Lesson update(UpdateLessonCommand command) {
        Lesson lesson =
                lessonQueryPort
                        .findByIdAndNotDeleted(command.lessonId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy lesson"));

        if (command.orderIndex() != null && !command.orderIndex().equals(lesson.getOrderIndex())) {
            throw new LmsBadRequestException("Vui lòng dùng API sắp xếp lại bài học để đổi thứ tự");
        }

        Integer finalOrderIndex = null;
        if (command.chapterId() != null) {
            Chapter chapter =
                    chapterQueryPort
                            .findById(command.chapterId())
                            .orElseThrow(
                                    () -> new ResourceNotFoundException("Không tìm thấy chapter"));

            if (Boolean.TRUE.equals(chapter.getIsDeleted())) {
                throw new ResourceNotFoundException("Chapter đã bị xóa");
            }

            if (!command.chapterId().equals(lesson.getChapterId())) {
                chapterQueryPort.lockCourseForOrdering(chapter.getCourseId());
                finalOrderIndex =
                        lessonQueryPort.findMaxOrderIndexByChapterId(command.chapterId()).orElse(0)
                                + 1;
            }
        }

        lesson.updateDetails(
                command.chapterId(), command.title(), finalOrderIndex, command.isPreview());

        return lessonCommandPort.save(lesson);
    }
}
