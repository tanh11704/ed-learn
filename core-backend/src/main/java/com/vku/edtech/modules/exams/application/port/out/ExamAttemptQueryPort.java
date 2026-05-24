package com.vku.edtech.modules.exams.application.port.out;

import com.vku.edtech.modules.exams.application.dto.ExamAttemptSummaryResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptStudentResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptsByGradeResult;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamAttemptQueryPort {
    Optional<ExamAttempt> findById(UUID attemptId);

    List<ExamAttempt> findByUserId(UUID userId);

    ExamAttemptSummaryResult getSummaryByExamId(UUID examId);

    List<ExamAttemptsByGradeResult> getAttemptsByGrade(UUID examId);

    List<ExamAttemptsByGradeResult> getAttemptsByGrade();

    List<ExamAttemptStudentResult> findStudentAttemptsByExamId(UUID examId);
}
