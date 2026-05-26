package com.vku.edtech.modules.lms.presentation.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateLessonVideoUrlRequest(
        @NotBlank(message = "videoUrl không được để trống")
                @Size(max = 1000, message = "videoUrl tối đa 1000 ký tự")
                String videoUrl) {}
