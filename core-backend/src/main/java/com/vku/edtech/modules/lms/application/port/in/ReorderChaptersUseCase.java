package com.vku.edtech.modules.lms.application.port.in;

import java.util.List;
import java.util.UUID;

public interface ReorderChaptersUseCase {
    void reorder(ReorderChaptersCommand command);

    record ReorderChaptersCommand(UUID courseId, List<UUID> chapterIds) {}
}
