package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.application.dto.ExamAttemptSummaryResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptStudentResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptsByGradeResult;
import java.util.List;
import java.util.UUID;

public interface GetExamAttemptStatisticsUseCase {
    ExamAttemptSummaryResult getSummaryByExamId(UUID examId);

    List<ExamAttemptsByGradeResult> getAttemptsByGrade(UUID examId);

    List<ExamAttemptsByGradeResult> getAttemptsByGrade();

    List<ExamAttemptStudentResult> getStudentAttempts(UUID examId);
}
