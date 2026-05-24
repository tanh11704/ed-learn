package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.domain.model.ExamAttempt;

public interface ExamAttemptCommandPort {
    ExamAttempt save(ExamAttempt attempt);
}
