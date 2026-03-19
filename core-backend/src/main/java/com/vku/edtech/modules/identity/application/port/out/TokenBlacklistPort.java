package com.vku.edtech.modules.identity.application.port.out;

public interface TokenBlacklistPort {
    void blacklistToken(String token, long ttl);
}
