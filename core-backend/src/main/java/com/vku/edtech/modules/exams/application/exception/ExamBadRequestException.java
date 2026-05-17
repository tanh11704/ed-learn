package com.vku.edtech.modules.exams.application.exception;

public class ExamBadRequestException extends RuntimeException {
    public ExamBadRequestException(String message) {
        super(message);
    }
}
