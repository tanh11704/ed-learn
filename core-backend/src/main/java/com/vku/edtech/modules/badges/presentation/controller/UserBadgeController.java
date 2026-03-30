package com.vku.edtech.modules.badges.presentation.controller;

import java.security.Principal;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.vku.edtech.modules.badges.application.port.in.GetMyBadgesUseCase;
import com.vku.edtech.modules.badges.presentation.dto.mapper.UserBadgeResponseMapper;
import com.vku.edtech.modules.badges.presentation.dto.response.UserBadgeResponse;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("api/v1/user-badges")
@RequiredArgsConstructor
@Tag(name = "User Badges", description = "Quản lý huy hiệu của người dùng")
public class UserBadgeController {

  private final GetMyBadgesUseCase getMyBadgesUseCase;
  private final UserBadgeResponseMapper userBadgeResponseMapper;

  @Operation(summary = "Lấy badge của tôi", security = @SecurityRequirement(name = "bearerAuth"))
  @GetMapping("/me")
  public ResponseEntity<Page<UserBadgeResponse>> getMyBadeges(
      Principal principal,
      @RequestParam(defaultValue = "0") int page,
      @RequestParam(defaultValue = "10") int size) {
    UUID userId = extractUserId(principal);
    Page<UserBadgeResponse> badges = getMyBadgesUseCase
        .getMyBadges(new GetMyBadgesUseCase.GetMyBadgesQuery(userId, PageRequest.of(page, size)))
        .map(userBadgeResponseMapper::toResponse);
    return ResponseEntity.ok(badges);
  }

  private UUID extractUserId(Principal principal) {
    JwtUserInfo userInfo = (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
    return userInfo.getId();
  }
}
