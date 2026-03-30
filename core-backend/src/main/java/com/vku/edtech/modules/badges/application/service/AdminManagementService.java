package com.vku.edtech.modules.badges.application.service;

import org.springframework.data.domain.Page;

import org.springframework.stereotype.Service;

import com.vku.edtech.modules.badges.application.port.in.CreateBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.DeleteBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.GetAllBadgesUseCase;
import com.vku.edtech.modules.badges.application.port.in.GetBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.in.UpdateBadgeUseCase;
import com.vku.edtech.modules.badges.application.port.out.BadgeCommandPort;
import com.vku.edtech.modules.badges.application.port.out.BadgeQueryPort;
import com.vku.edtech.modules.badges.domain.model.Badge;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminManagementService implements
    CreateBadgeUseCase,
    GetBadgeUseCase,
    UpdateBadgeUseCase,
    DeleteBadgeUseCase,
    GetAllBadgesUseCase {

  private final BadgeQueryPort badgeQueryPort;
  private final BadgeCommandPort badgeCommandPort;

  @Override
  public void deleteBadge(DeleteBadgeCommand command) {
    badgeCommandPort.deleteById(command.id());
  }

  @Override
  public void updateBadge(UpdateBadgeCommand command) {
    Badge badge = badgeQueryPort.findById(command.id())
        .orElseThrow(() -> new RuntimeException("Badge not found"));

    badge.setCode(command.code());
    badge.setName(command.name());
    badge.setDescription(command.description());
    badge.setCategory(command.category());
    badge.setImageUrl(command.imageUrl());
    badge.setXpReward(command.xpReward());

    badgeCommandPort.save(badge);
  }

  @Override
  public Badge getBadge(GetBadgeQuery query) {
    return badgeQueryPort.findById(query.id())
        .orElseThrow(() -> new RuntimeException("Badge not found"));
  }

  @Override
  public Badge createBadge(CreateBadgeCommand command) {
    Badge badge = new Badge(
        null,
        command.code(),
        command.name(),
        command.description(),
        command.category(),
        command.imageUrl(),
        command.xpReward());
    return badgeCommandPort.save(badge);
  }

  @Override
  public Page<Badge> getAllBadges(GetAllBadgesQuery query) {
    return badgeQueryPort.findAll(query.pageable());
  }

}
