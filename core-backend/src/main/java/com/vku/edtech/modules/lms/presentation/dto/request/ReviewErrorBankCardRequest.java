package com.vku.edtech.modules.lms.presentation.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

@Schema(description = "Kết quả ôn tập flashcard lỗi sai")
public record ReviewErrorBankCardRequest(
        @Schema(description = "Điểm đánh giá mức độ nhớ từ 0 đến 5", example = "4")
                @Min(value = 0, message = "quality tối thiểu là 0")
                @Max(value = 5, message = "quality tối đa là 5")
                int quality) {}
