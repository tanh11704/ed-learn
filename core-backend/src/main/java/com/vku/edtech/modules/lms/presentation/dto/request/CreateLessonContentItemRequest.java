package com.vku.edtech.modules.lms.presentation.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;

public record CreateLessonContentItemRequest(
        @NotBlank @Pattern(regexp = "FLASHCARD|EXERCISE") String type,
        @NotBlank String prompt,
        @NotBlank String answer,
        String explanation,
        List<@NotBlank String> options,
        @Size(max = 10) String correctOption,
        Integer orderIndex) {}
