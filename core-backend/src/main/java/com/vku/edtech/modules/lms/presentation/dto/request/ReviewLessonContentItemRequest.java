package com.vku.edtech.modules.lms.presentation.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public record ReviewLessonContentItemRequest(
        @Min(value = 0, message = "quality tối thiểu là 0")
                @Max(value = 5, message = "quality tối đa là 5")
                int quality) {}
