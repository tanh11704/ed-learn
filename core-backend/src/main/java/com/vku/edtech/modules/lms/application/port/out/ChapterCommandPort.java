package com.vku.edtech.modules.lms.application.port.out;

import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.UUID;

public interface ChapterCommandPort {
    Chapter save(Chapter chapter);

    Chapter delete(UUID id);
}
