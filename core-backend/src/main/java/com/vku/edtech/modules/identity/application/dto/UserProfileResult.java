package com.vku.edtech.modules.identity.application.dto;

import java.util.UUID;

public record UserProfileResult(UUID id, String email, String fullName, String role) {}
