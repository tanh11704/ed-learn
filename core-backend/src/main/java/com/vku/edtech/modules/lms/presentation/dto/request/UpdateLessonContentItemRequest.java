package com.vku.edtech.modules.lms.presentation.dto.request;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;

public record UpdateLessonContentItemRequest(
        @Pattern(regexp = "FLASHCARD|EXERCISE") String type,
        String prompt,
        String answer,
        String explanation,
        List<String> options,
        @Size(max = 10) String correctOption,
        Integer orderIndex) {}
