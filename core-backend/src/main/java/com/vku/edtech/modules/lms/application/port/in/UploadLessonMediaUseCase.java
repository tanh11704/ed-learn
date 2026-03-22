package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;

import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

public interface UploadLessonMediaUseCase {
    Lesson uploadMedia(UploadLessonMediaCommand command);

    record UploadLessonMediaCommand(UUID lessonId, MultipartFile file, String mediaType) {}
}
