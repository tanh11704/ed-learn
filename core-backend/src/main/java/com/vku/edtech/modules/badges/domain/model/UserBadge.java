package com.vku.edtech.modules.badges.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

public class UserBadge {
  private UUID id;
  private UUID userId;
  private UUID badgeId;
  private LocalDateTime earnedAt;
  private Boolean isNew;

  public UserBadge() {
  }

  public UserBadge(UUID id, UUID userId, UUID badgeId, LocalDateTime earnedAt, Boolean isNew) {
    this.id = id;
    this.userId = userId;
    this.badgeId = badgeId;
    this.earnedAt = earnedAt;
    this.isNew = isNew;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public UUID getUserId() {
    return userId;
  }

  public void setUserId(UUID userId) {
    this.userId = userId;
  }

  public UUID getBadgeId() {
    return badgeId;
  }

  public void setBadgeId(UUID badgeId) {
    this.badgeId = badgeId;
  }

  public LocalDateTime getEarnedAt() {
    return earnedAt;
  }

  public void setEarnedAt(LocalDateTime earnedAt) {
    this.earnedAt = earnedAt;
  }

  public Boolean getIsNew() {
    return isNew;
  }

  public void setIsNew(Boolean isNew) {
    this.isNew = isNew;
  }

}
