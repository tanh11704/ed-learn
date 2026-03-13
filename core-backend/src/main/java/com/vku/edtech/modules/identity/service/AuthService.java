package com.vku.edtech.modules.identity.service;

import com.vku.edtech.modules.identity.dto.request.LoginRequest;
import com.vku.edtech.modules.identity.dto.request.RegisterRequest;
import com.vku.edtech.modules.identity.dto.response.AuthResponse;

public interface AuthService {
    AuthResponse register(RegisterRequest req);

    AuthResponse login(LoginRequest req);
}
