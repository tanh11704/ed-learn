package com.vku.edtech.modules.lms.presentation.exception;

import com.vku.edtech.modules.lms.application.exception.LmsBadRequestException;
import com.vku.edtech.modules.lms.application.exception.LmsForbiddenException;
import com.vku.edtech.modules.lms.application.exception.LmsNotFoundException;
import com.vku.edtech.shared.presentation.dto.ErrorResponse;
import java.util.HashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice(basePackages = "com.vku.edtech.modules.lms")
public class LmsExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }

        String firstErrorMessage =
                errors.values().stream().findFirst().orElse("Dữ liệu đầu vào không hợp lệ");

        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse(HttpStatus.BAD_REQUEST.value(), "Bad Request", firstErrorMessage, errors));
    }

    @ExceptionHandler(LmsNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(LmsNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ErrorResponse(HttpStatus.NOT_FOUND.value(), "Not Found", ex.getMessage()));
    }

    @ExceptionHandler(LmsBadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(LmsBadRequestException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse(HttpStatus.BAD_REQUEST.value(), "Bad Request", ex.getMessage()));
    }

    @ExceptionHandler(LmsForbiddenException.class)
    public ResponseEntity<ErrorResponse> handleForbidden(LmsForbiddenException ex) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(new ErrorResponse(HttpStatus.FORBIDDEN.value(), "Forbidden", ex.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGlobalException(Exception ex) {
        log.error("LMS CRITICAL ERROR", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse(
                        HttpStatus.INTERNAL_SERVER_ERROR.value(),
                        "Internal Server Error",
                        "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau."));
    }
}
