package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.List;
import java.util.UUID;

public interface GetChaptersUseCase {
    List<Chapter> getChaptersByCourseId(UUID courseId);
}
