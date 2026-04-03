package com.vku.edtech.modules.badges.presentation.dto.mapper;

import com.vku.edtech.modules.badges.domain.model.Badge;
import com.vku.edtech.modules.badges.presentation.dto.response.BadgeResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface BadgeResponseMapper {
    BadgeResponse toResponse(Badge badge);
}
