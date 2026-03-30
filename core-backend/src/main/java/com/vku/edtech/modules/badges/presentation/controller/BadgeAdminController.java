package com.vku.edtech.modules.badges.presentation.controller;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.vku.edtech.modules.badges.application.port.in.CreateBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.DeleteBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.GetAllBadgesUseCase;
import com.vku.edtech.modules.badges.application.port.in.GetBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.UpdateBadgeUseCase;
import com.vku.edtech.modules.badges.presentation.dto.mapper.BadgeResponseMapper;
import com.vku.edtech.modules.badges.presentation.dto.request.CreateBadgeRequest;
import com.vku.edtech.modules.badges.presentation.dto.request.UpdateBadgeRequest;
import com.vku.edtech.modules.badges.presentation.dto.response.BadgeResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("api/v1/admin/badges")
@RequiredArgsConstructor
@Tag(name = "Badge Admin", description = "Quản lý huy hiệu (dành cho admin)")
public class BadgeAdminController {
  private final CreateBadgeUseCase createBadgeUseCase;
  private final GetBadgeUseCase getBadgeUseCase;
  private final UpdateBadgeUseCase updateBadgeUseCase;
  private final DeleteBadgeUseCase deleteBadgeUseCase;
  private final BadgeResponseMapper badgeResponseMapper;
  private final GetAllBadgesUseCase getAllBadgesUseCase;

  @Operation(summary = "Tạo badge", security = @SecurityRequirement(name = "bearerAuth"))
  @PostMapping
  public ResponseEntity<BadgeResponse> create(@Valid @RequestBody CreateBadgeRequest request) {
    var badge = createBadgeUseCase.createBadge(
        new CreateBadgeUseCase.CreateBadgeCommand(
            request.code(),
            request.name(),
            request.description(),
            request.category(),
            request.imageUrl(),
            request.xpReward()));
    return ResponseEntity.ok(badgeResponseMapper.toResponse(badge));
  }

  @Operation(summary = "Lấy danh sách badge", security = @SecurityRequirement(name = "bearerAuth"))
  @GetMapping
  public ResponseEntity<Page<BadgeResponse>> getAll(
      @RequestParam(defaultValue = "0") int page,
      @RequestParam(defaultValue = "10") int size) {
    var badges = getAllBadgesUseCase.getAllBadges(
        new GetAllBadgesUseCase.GetAllBadgesQuery(PageRequest.of(page, size)));
    return ResponseEntity.ok(badges.map(badgeResponseMapper::toResponse));
  }

  @Operation(summary = "Lấy badge theo id", security = @SecurityRequirement(name = "bearerAuth"))
  @GetMapping("/{id}")
  public ResponseEntity<BadgeResponse> getById(@PathVariable UUID id) {
    var badge = getBadgeUseCase.getBadge(new GetBadgeUseCase.GetBadgeQuery(id));
    return ResponseEntity.ok(badgeResponseMapper.toResponse(badge));
  }

  @Operation(summary = "Cập nhật badge", security = @SecurityRequirement(name = "bearerAuth"))
  @PutMapping("/{id}")
  public ResponseEntity<BadgeResponse> update(@PathVariable UUID id, @Valid @RequestBody UpdateBadgeRequest request) {
    updateBadgeUseCase.updateBadge(
        new UpdateBadgeUseCase.UpdateBadgeCommand(
            id,
            request.code(),
            request.name(),
            request.description(),
            request.imageUrl(),
            request.category(),
            request.xpReward()));

    var updated = getBadgeUseCase.getBadge(new GetBadgeUseCase.GetBadgeQuery(id));
    return ResponseEntity.ok(badgeResponseMapper.toResponse(updated));
  }

  @Operation(summary = "Xóa badge", security = @SecurityRequirement(name = "bearerAuth"))
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> delete(@PathVariable UUID id) {
    deleteBadgeUseCase.deleteBadge(new DeleteBadgeUseCase.DeleteBadgeCommand(id));
    return ResponseEntity.noContent().build();
  }
}
