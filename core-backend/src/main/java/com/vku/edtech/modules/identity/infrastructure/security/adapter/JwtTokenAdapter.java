package com.vku.edtech.modules.identity.infrastructure.security.adapter;

import com.vku.edtech.modules.identity.application.port.out.TokenGeneratorPort;
import com.vku.edtech.modules.identity.application.port.out.TokenInspectionPort;
import com.vku.edtech.modules.identity.domain.model.User;
import com.vku.edtech.shared.infrastructure.security.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtTokenAdapter implements TokenGeneratorPort, TokenInspectionPort {

    private final JwtProperties jwtProperties;

    @Override
    public String generateAccessToken(User user) {
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("role", user.getRole().name());
        extraClaims.put("userId", user.getId().toString());

        return Jwts.builder()
                .setClaims(extraClaims)
                .setSubject(user.getEmail())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(
                        new Date(
                                System.currentTimeMillis()
                                        + jwtProperties.getAccessTokenExpiration()))
                .signWith(getSignKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    @Override
    public String generateRefreshToken(User user) {
        return UUID.randomUUID().toString();
    }

    @Override
    public long getRefreshTokenExpirationMillis() {
        return jwtProperties.getRefreshTokenExpiration();
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSignKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Key getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtProperties.getSecret());
        return Keys.hmacShaKeyFor(keyBytes);
    }

    @Override
    public long getRemainingTtlInMillis(String token) {
        try {
            Claims claims =
                    Jwts.parserBuilder()
                            .setSigningKey(getSignKey())
                            .build()
                            .parseClaimsJws(token)
                            .getBody();

            long expirationTime = claims.getExpiration().getTime();
            long currentTime = System.currentTimeMillis();

            return Math.max(0, expirationTime - currentTime);

        } catch (ExpiredJwtException e) {
            return 0;
        } catch (Exception e) {
            return 0;
        }
    }
}
