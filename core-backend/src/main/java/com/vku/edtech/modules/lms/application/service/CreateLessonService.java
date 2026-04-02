package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.CreateLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateLessonService implements CreateLessonUseCase {

    private final LessonCommandPort lessonCommandPort;
    private final LessonQueryPort lessonQueryPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional
    public Lesson create(CreateLessonCommand command) {
        Chapter chapter =
                chapterQueryPort
                        .findById(command.chapterId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy chapter"));

        if (Boolean.TRUE.equals(chapter.getIsDeleted())) {
            throw new ResourceNotFoundException("Chapter đã bị xóa");
        }

        Integer finalOrderIndex = command.orderIndex();
        if (finalOrderIndex == null || finalOrderIndex <= 0) {
            finalOrderIndex =
                    lessonQueryPort.findMaxOrderIndexByChapterId(command.chapterId()).orElse(0) + 1;
        }

        Lesson lesson =
                Lesson.create(
                        command.chapterId(), command.title(), finalOrderIndex, command.isPreview());

        return lessonCommandPort.save(lesson);
    }
}
