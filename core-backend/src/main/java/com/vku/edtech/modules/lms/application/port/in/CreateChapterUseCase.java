package com.vku.edtech.modules.lms.application.port.in;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.UUID;

public interface CreateChapterUseCase {
    Chapter execute(CreateChapterCommand command);

    record CreateChapterCommand(UUID courseId, String title, int orderIdx) {}
}
