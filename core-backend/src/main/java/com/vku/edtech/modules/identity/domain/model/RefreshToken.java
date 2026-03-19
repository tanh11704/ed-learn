package com.vku.edtech.modules.identity.domain.model;

import java.time.Instant;
import java.util.UUID;

public class RefreshToken {
    private UUID id;
    private String token;
    private Instant expiresAt;
    private String deviceInfo;
    private Boolean revoked;
    private UUID userId;
    private Instant createdAt;
    private Instant updatedAt;


    public RefreshToken(String token, Instant expiresAt, String deviceInfo, UUID userId) {
        this.token = token;
        this.expiresAt = expiresAt;
        this.deviceInfo = deviceInfo;
        this.userId = userId;
        this.revoked = false;
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    public RefreshToken(UUID id, String token, Instant expiresAt, String deviceInfo, boolean revoked, UUID userId, Instant createdAt, Instant updatedAt) {
        this.id = id;
        this.token = token;
        this.expiresAt = expiresAt;
        this.deviceInfo = deviceInfo;
        this.revoked = revoked;
        this.userId = userId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public boolean isExpired() {
        return Instant.now().isAfter(this.expiresAt);
    }

    public void revoke() {
        this.revoked = true;
        this.updatedAt = Instant.now();
    }

    public boolean isValid() {
        return !this.revoked && !isExpired();
    }

    public void renewToken(String token, Instant expiresAt) {
        this.token = token;
        this.expiresAt = expiresAt;
        this.updatedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public String getToken() { return token; }
    public Instant getExpiresAt() { return expiresAt; }
    public String getDeviceInfo() { return deviceInfo; }
    public boolean isRevoked() { return revoked; }
    public UUID getUserId() { return userId; }
    public Instant getCreatedAt() {
        return createdAt;
    }
    public Instant getUpdatedAt() {
        return updatedAt;
    }
}
