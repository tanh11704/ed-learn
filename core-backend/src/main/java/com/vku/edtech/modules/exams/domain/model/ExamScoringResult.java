package com.vku.edtech.modules.exams.domain.model;

import java.math.BigDecimal;
import java.util.UUID;

public record ExamScoringResult(UUID examId, BigDecimal totalScore, BigDecimal maxScore, String gradingProfile) {}
