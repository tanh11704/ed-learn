package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Lesson;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface UploadLessonMediaUseCase {
    Lesson uploadMedia(UploadLessonMediaCommand command);

    record UploadLessonMediaCommand(UUID lessonId, MultipartFile file, String mediaType) {}
}
