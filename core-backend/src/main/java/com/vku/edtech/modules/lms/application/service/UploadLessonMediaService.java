package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase;
import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase.UploadLessonMediaCommand;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UploadLessonMediaService implements UploadLessonMediaUseCase {

    private final LessonCommandPort lessonCommandPort;
    private final LessonQueryPort lessonQueryPort;
    private final FileStoragePort fileStoragePort;

    @Override
    @Transactional
    public Lesson uploadMedia(UploadLessonMediaCommand command) {
        Lesson lesson =
                lessonQueryPort
                        .findById(command.lessonId())
                        .orElseThrow(() -> new ResourceNotFoundException("Lesson not found"));

        String fileUrl = fileStoragePort.uploadFile(command.file(), "lessons");

        if ("VIDEO".equalsIgnoreCase(command.mediaType())) {
            lesson.updateVideoMedia(fileUrl);
        } else if ("PDF".equalsIgnoreCase(command.mediaType())) {
            lesson.updatePdfMedia(fileUrl);
        } else {
            throw new InvalidDomainDataException("Unsupported media type: " + command.mediaType());
        }

        return lessonCommandPort.save(lesson);
    }
}
