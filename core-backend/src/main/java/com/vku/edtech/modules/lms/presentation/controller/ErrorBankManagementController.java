package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetErrorBankStatisticsUseCase;
import com.vku.edtech.modules.lms.presentation.dto.response.ErrorBankStudentStatisticResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Error Bank Management", description = "API admin thong ke loi sai hoc vien")
@RestController
@RequestMapping("/api/v1/management/error-bank")
@RequiredArgsConstructor
public class ErrorBankManagementController {

    private final GetErrorBankStatisticsUseCase getErrorBankStatisticsUseCase;

    @Operation(
            summary = "Thong ke loi sai theo hoc vien",
            description = "Tra ve tong so loi sai, so the den han on va cac chi so spaced repetition theo tung hoc vien.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/students/statistics")
    public ResponseEntity<List<ErrorBankStudentStatisticResponse>> getStudentStatistics() {
        return ResponseEntity.ok(
                getErrorBankStatisticsUseCase.getStudentStatistics().stream()
                        .map(
                                item ->
                                        new ErrorBankStudentStatisticResponse(
                                                item.studentId(),
                                                item.studentName(),
                                                item.email(),
                                                item.gradeLevel(),
                                                item.className(),
                                                item.totalErrors(),
                                                item.dueErrors(),
                                                item.reviewedErrors(),
                                                item.masteredErrors(),
                                                item.averageEaseFactor(),
                                                item.averageIntervalDays(),
                                                item.nextReviewDate(),
                                                item.lastUpdatedAt()))
                        .toList());
    }
}
