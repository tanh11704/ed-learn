package com.vku.edtech.modules.lms.presentation.dto.request;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;
import java.util.UUID;

public record ReorderLessonsRequest(@NotEmpty List<UUID> lessonIds) {}
