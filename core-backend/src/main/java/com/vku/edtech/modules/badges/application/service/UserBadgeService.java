package com.vku.edtech.modules.badges.application.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.vku.edtech.modules.badges.application.dto.UserBadgeResult;
import com.vku.edtech.modules.badges.application.port.in.GetMyBadgesUseCase;
import com.vku.edtech.modules.badges.application.port.out.UserBadgeQueryPort;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class UserBadgeService implements GetMyBadgesUseCase {

  private final UserBadgeQueryPort userBadgeQueryPort;

  @Override
  public List<UserBadgeResult> getMyBadges(GetMyBadgesQuery query) {
    return userBadgeQueryPort.findMyBadges(query.userId());
  }

}
