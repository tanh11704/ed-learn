package com.vku.edtech.shared.infrastructure.security.exception;

import com.vku.edtech.shared.util.ResponseUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {
    @Override
    public void commence(
            HttpServletRequest request,
            HttpServletResponse response,
            AuthenticationException authException)
            throws IOException, ServletException {
        ResponseUtils.sendErrorResponse(
                response,
                HttpServletResponse.SC_UNAUTHORIZED,
                "Unauthorized",
                "Vui lòng đăng nhập để truy cập.");
    }
}
