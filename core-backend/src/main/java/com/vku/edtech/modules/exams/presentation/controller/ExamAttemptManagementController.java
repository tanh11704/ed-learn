package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.GetExamAttemptStatisticsUseCase;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptSummaryResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptStudentResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptsByGradeResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Exam Attempt Management", description = "API admin thong ke luot lam de")
@RestController
@RequestMapping("/api/v1/management/exam-attempts")
@RequiredArgsConstructor
public class ExamAttemptManagementController {

    private final GetExamAttemptStatisticsUseCase statisticsUseCase;

    @Operation(summary = "Thong ke tong quan theo de", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/exams/{examId}/summary")
    public ResponseEntity<ExamAttemptSummaryResponse> getSummary(@PathVariable UUID examId) {
        var result = statisticsUseCase.getSummaryByExamId(examId);
        return ResponseEntity.ok(
                new ExamAttemptSummaryResponse(
                        result.examId(),
                        result.examTitle(),
                        result.attemptCount(),
                        result.submittedCount(),
                        result.averageScore(),
                        result.highestScore(),
                        result.lowestScore()));
    }

    @Operation(summary = "Thong ke luot lam theo lop trong mot de", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/exams/{examId}/by-grade")
    public ResponseEntity<List<ExamAttemptsByGradeResponse>> getByGrade(
            @PathVariable UUID examId) {
        return ResponseEntity.ok(
                statisticsUseCase.getAttemptsByGrade(examId).stream()
                        .map(
                                item ->
                                        new ExamAttemptsByGradeResponse(
                                                item.gradeLevel(),
                                                item.attemptCount(),
                                                item.submittedCount(),
                                                item.averageScore()))
                        .toList());
    }

    @Operation(summary = "Thong ke luot lam theo lop toan he thong", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/by-grade")
    public ResponseEntity<List<ExamAttemptsByGradeResponse>> getSystemByGrade() {
        return ResponseEntity.ok(
                statisticsUseCase.getAttemptsByGrade().stream()
                        .map(
                                item ->
                                        new ExamAttemptsByGradeResponse(
                                                item.gradeLevel(),
                                                item.attemptCount(),
                                                item.submittedCount(),
                                                item.averageScore()))
                        .toList());
    }

    @Operation(summary = "Danh sach luot lam cua hoc vien trong mot de", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/exams/{examId}/students")
    public ResponseEntity<List<ExamAttemptStudentResponse>> getStudentAttempts(
            @PathVariable UUID examId) {
        return ResponseEntity.ok(
                statisticsUseCase.getStudentAttempts(examId).stream()
                        .map(
                                item ->
                                        new ExamAttemptStudentResponse(
                                                item.attemptId(),
                                                item.examId(),
                                                item.studentId(),
                                                item.studentName(),
                                                item.email(),
                                                item.gradeLevel(),
                                                item.className(),
                                                item.status(),
                                                item.startedAt(),
                                                item.submittedAt(),
                                                item.durationSeconds(),
                                                item.score(),
                                                item.maxScore()))
                        .toList());
    }
}
