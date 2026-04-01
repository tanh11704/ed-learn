package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.DeleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DeleteLessonService implements DeleteLessonUseCase {

    private final LessonQueryPort lessonQueryPort;
    private final LessonCommandPort lessonCommandPort;

    @Override
    @Transactional
    public void delete(DeleteLessonCommand command) {
        Lesson lesson =
                lessonQueryPort
                        .findByIdAndNotDeleted(command.lessonId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy lesson"));

        lesson.markAsDeleted();
        lessonCommandPort.save(lesson);
    }
}
