package com.vku.edtech.shared.infrastructure.security.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vku.edtech.shared.infrastructure.security.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Key;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProperties jwtProperties;
    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {
            Boolean isBlacklisted = redisTemplate.hasKey("blacklist:" + token);

            if (Boolean.TRUE.equals(isBlacklisted)) {
                sendErrorResponse(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Token đã bị vô hiệu hóa (Đăng xuất).");
                return; // Return ngay, chặn không cho code chạy tiếp xuống dưới
            }

            Claims claims =
                    Jwts.parserBuilder()
                            .setSigningKey(getSignKey())
                            .build()
                            .parseClaimsJws(token)
                            .getBody();

            String email = claims.getSubject();

            String role = claims.get("role", String.class);
            if (role == null) role = "USER";

            String userIdStr = claims.get("userId", String.class);
            java.util.UUID userId = userIdStr != null ? java.util.UUID.fromString(userIdStr) : null;

            if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                List<SimpleGrantedAuthority> authorities =
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role));

                com.vku.edtech.shared.infrastructure.security.JwtUserInfo jwtUserInfo =
                        new com.vku.edtech.shared.infrastructure.security.JwtUserInfo(
                                userId, email, role);

                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(jwtUserInfo, null, authorities);

                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }

            filterChain.doFilter(request, response);

        } catch (ExpiredJwtException e) {
            // Lỗi 1: Token hết thời gian sống
            sendErrorResponse(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Token đã hết hạn. Vui lòng refresh token.");
            return;
        } catch (JwtException | IllegalArgumentException e) {
            // Lỗi 2: Token bị chỉnh sửa bậy bạ, sai chữ ký (Signature)
            sendErrorResponse(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Token không hợp lệ hoặc bị giả mạo.");
            return;
        } catch (Exception e) {
            // Lỗi 3: Các ngoại lệ khác
            sendErrorResponse(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Đã xảy ra lỗi trong quá trình xác thực.");
            return;
        }
    }

    private Key getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtProperties.getSecret());
        return Keys.hmacShaKeyFor(keyBytes);
    }

    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message)
            throws IOException {
        response.setStatus(statusCode);
        // Báo cho client biết cục dữ liệu trả về là JSON (UTF-8 để không lỗi font tiếng Việt)
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");

        // Tạo cấu trúc JSON trả về
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("status", statusCode);
        errorDetails.put("error", statusCode == 401 ? "Unauthorized" : "Internal Server Error");
        errorDetails.put("message", message);
        errorDetails.put("timestamp", System.currentTimeMillis());

        // Dùng ObjectMapper ép Map thành JSON string và đẩy thẳng ra output stream
        response.getWriter().write(objectMapper.writeValueAsString(errorDetails));
    }
}
