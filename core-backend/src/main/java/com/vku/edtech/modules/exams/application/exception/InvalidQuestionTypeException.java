package com.vku.edtech.modules.exams.application.exception;

public class InvalidQuestionTypeException extends RuntimeException {
    public InvalidQuestionTypeException(String message) {
        super(message);
    }
}
