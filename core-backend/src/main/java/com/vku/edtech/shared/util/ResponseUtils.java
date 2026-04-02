package com.vku.edtech.shared.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vku.edtech.shared.presentation.dto.ErrorResponse;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.http.MediaType;

public class ResponseUtils {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static void sendErrorResponse(
            HttpServletResponse response, int status, String error, String message)
            throws IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");

        ErrorResponse errorResponse = new ErrorResponse(status, error, message);
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
    }
}
