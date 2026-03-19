package com.vku.edtech.modules.identity.presentation.dto.mapper;

import com.vku.edtech.modules.identity.application.dto.UserProfileResult;
import com.vku.edtech.modules.identity.presentation.dto.response.UserProfileResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserProfileResponse toResponse(UserProfileResult userProfileResult);
}
