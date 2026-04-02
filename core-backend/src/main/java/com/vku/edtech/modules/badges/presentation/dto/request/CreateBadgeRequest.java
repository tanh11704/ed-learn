package com.vku.edtech.modules.badges.presentation.dto.request;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateBadgeRequest(
        @NotBlank(message = "Code không được để trống")
        @Size(max = 100, message = "Code tối đa 100 ký tự")
        String code,

        @NotBlank(message = "Name không được để trống")
        @Size(max = 255, message = "Name tối đa 255 ký tự")
        String name,

        String description,

        @NotNull(message = "Category không được để trống")
        BadgeCategory category,

        @Size(max = 500, message = "imageUrl tối đa 500 ký tự")
        String imageUrl,

        @NotNull(message = "xpReward không được để trống")
        @Min(value = 0, message = "xpReward phải lớn hơn hoặc bằng 0")
        Integer xpReward
) {
}