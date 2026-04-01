package com.vku.edtech.modules.identity.presentation.dto.mapper;

import com.vku.edtech.modules.identity.domain.model.UserStreak;
import com.vku.edtech.modules.identity.presentation.dto.response.UserStreakResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserStreakMapper {
    UserStreakResponse toResponse(UserStreak domain);
}
