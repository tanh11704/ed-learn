package com.vku.edtech.modules.identity.infrastructure.security.adapter;

import com.vku.edtech.modules.identity.application.port.out.TokenBlacklistPort;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class TokenBlacklistAdapter implements TokenBlacklistPort {

    private final StringRedisTemplate redisTemplate;

    @Override
    public void blacklistToken(String token, long ttl) {
        redisTemplate.opsForValue().set(
                "blacklist:" + token,
                "true",
                ttl,
                TimeUnit.MILLISECONDS
        );
    }
}
