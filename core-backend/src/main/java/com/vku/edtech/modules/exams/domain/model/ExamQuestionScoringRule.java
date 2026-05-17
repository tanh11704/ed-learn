package com.vku.edtech.modules.exams.domain.model;

import java.math.BigDecimal;

public record ExamQuestionScoringRule(
        ExamQuestionType questionType,
        ExamQuestionPaperPart paperPart,
        BigDecimal scorePerQuestion,
        int numberOfStatements) {}
