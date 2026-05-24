package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.dto.ExamAttemptSummaryResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptStudentResult;
import com.vku.edtech.modules.exams.application.dto.ExamAttemptsByGradeResult;
import com.vku.edtech.modules.exams.application.port.in.GetExamAttemptStatisticsUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamAttemptQueryPort;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetExamAttemptStatisticsService implements GetExamAttemptStatisticsUseCase {

    private final ExamAttemptQueryPort attemptQueryPort;

    @Override
    @Transactional(readOnly = true)
    public ExamAttemptSummaryResult getSummaryByExamId(UUID examId) {
        return attemptQueryPort.getSummaryByExamId(examId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ExamAttemptsByGradeResult> getAttemptsByGrade(UUID examId) {
        return attemptQueryPort.getAttemptsByGrade(examId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ExamAttemptsByGradeResult> getAttemptsByGrade() {
        return attemptQueryPort.getAttemptsByGrade();
    }

    @Override
    public List<ExamAttemptStudentResult> getStudentAttempts(UUID examId) {
        return attemptQueryPort.findStudentAttemptsByExamId(examId);
    }
}
