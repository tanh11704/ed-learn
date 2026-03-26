package com.vku.edtech.shared.infrastructure.security;

import java.security.Principal;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class JwtUserInfo implements Principal {
    private final UUID id;
    private final String email;
    private final String role;

    @Override
    public String getName() {
        return email;
    }
}
