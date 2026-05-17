package com.vku.edtech.modules.exams.domain.service.scoring;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import java.math.BigDecimal;

public interface ExamScoringStrategy {
    boolean supports(ExamQuestion question, ExamQuestionScoringRule rule);

    BigDecimal score(ExamQuestion question, ExamQuestionScoringRule rule, String userAnswer);
}
