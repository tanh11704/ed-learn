package com.vku.edtech.shared.exception;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ErrorResponse(
        int status,
        String error,
        String message,
        Object details,
        long timestamp
) {
    public ErrorResponse(int status, String error, String message) {
        this(status, error, message, null, System.currentTimeMillis());
    }

    public ErrorResponse(int status, String error, String message, Object details) {
        this(status, error, message, details, System.currentTimeMillis());
    }
}
