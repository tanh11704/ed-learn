package com.vku.edtech.modules.identity.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final UserDetailsService userDetailsService;
    private final JwtService jwtService;
    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        try {
            String authHeader = request.getHeader("Authorization");
            String token = null;
            String username = null;

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);

                Boolean isBlacklisted = redisTemplate.hasKey("blacklist:" + token);
                if (Boolean.TRUE.equals(isBlacklisted)) {
                    sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Token đã bị vô hiệu hóa (Đăng xuất).");
                    return; // Return ngay, chặn không cho code chạy tiếp xuống dưới
                }

                username = jwtService.extractUsername(token);
            }

            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                if (jwtService.isTokenValid(token, userDetails)) {
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities());
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    // Đóng dấu "Đã qua trạm kiểm soát"
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        } catch (ExpiredJwtException e) {
            // Lỗi 1: Token hết thời gian sống
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Token đã hết hạn. Vui lòng refresh token.");
        } catch (JwtException | IllegalArgumentException e) {
            // Lỗi 2: Token bị chỉnh sửa bậy bạ, sai chữ ký (Signature)
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Token không hợp lệ hoặc bị giả mạo.");
        } catch (Exception e) {
            // Lỗi 3: Các ngoại lệ khác
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi trong quá trình xác thực.");
        }

        filterChain.doFilter(request, response);
    }

    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
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
