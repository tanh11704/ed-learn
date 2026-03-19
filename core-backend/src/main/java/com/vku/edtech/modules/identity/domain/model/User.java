package com.vku.edtech.modules.identity.domain.model;

import java.time.Instant;
import java.util.UUID;

public class User {
    private UUID id;
    private String email;
    private String passwordHash;
    private String fullName;
    private Role role;
    private Instant createdAt;
    private Instant updatedAt;

    public User(String email, String rawPassword, String fullName) {
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }
        this.email = email;
        this.passwordHash = rawPassword;
        this.fullName = fullName;
        this.role = Role.USER;
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    public User(UUID id, String email, String passwordHash, String fullName, Role role, Instant createdAt, Instant updatedAt) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.role = role;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public void updateProfile(String newFullName) {
        if (newFullName != null && !newFullName.trim().isEmpty()) {
            this.fullName = newFullName;
            this.updatedAt = Instant.now();
        }
    }

    public void changePassword(String newPasswordHash) {
        this.passwordHash = newPasswordHash;
        this.updatedAt = Instant.now();
    }

    public UUID getId() { return id; }
    public String getEmail() { return email; }
    public String getPasswordHash() { return passwordHash; }
    public String getFullName() { return fullName; }
    public Role getRole() { return role; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
}
