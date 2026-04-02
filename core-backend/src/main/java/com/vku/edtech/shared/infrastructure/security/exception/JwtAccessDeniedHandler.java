package com.vku.edtech.shared.infrastructure.security.exception;

import com.vku.edtech.shared.util.ResponseUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

@Component
public class JwtAccessDeniedHandler implements AccessDeniedHandler {
    @Override
    public void handle(
            HttpServletRequest request,
            HttpServletResponse response,
            AccessDeniedException accessDeniedException)
            throws IOException, ServletException {
        ResponseUtils.sendErrorResponse(
                response,
                HttpServletResponse.SC_FORBIDDEN,
                "Forbidden",
                "Bạn không có quyền truy cập vào tài nguyên này.");
    }
}
