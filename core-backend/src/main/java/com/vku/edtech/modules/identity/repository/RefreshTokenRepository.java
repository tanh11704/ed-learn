package com.vku.edtech.modules.identity.repository;

import com.vku.edtech.modules.identity.entity.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {
}
