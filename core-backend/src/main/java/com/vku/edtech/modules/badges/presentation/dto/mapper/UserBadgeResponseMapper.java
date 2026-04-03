package com.vku.edtech.modules.badges.presentation.dto.mapper;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.presentation.dto.response.UserBadgeResponse;
import java.util.List;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserBadgeResponseMapper {

    UserBadgeResponse toResponse(UserBadgeResult result);

    List<UserBadgeResponse> toResponses(List<UserBadgeResult> results);
}
