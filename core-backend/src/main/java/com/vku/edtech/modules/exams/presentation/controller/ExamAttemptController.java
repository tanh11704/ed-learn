package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.GetMyExamAttemptsUseCase;
import com.vku.edtech.modules.exams.application.port.in.StartExamAttemptUseCase;
import com.vku.edtech.modules.exams.application.port.in.SubmitExamAttemptUseCase;
import com.vku.edtech.modules.exams.presentation.dto.mapper.ExamAttemptResponseMapper;
import com.vku.edtech.modules.exams.presentation.dto.request.StartExamAttemptRequest;
import com.vku.edtech.modules.exams.presentation.dto.request.SubmitExamAttemptRequest;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptResponse;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Exam Attempts", description = "API lam de va lich su lam de cua hoc vien")
@RestController
@RequestMapping("/api/v1/exams")
@RequiredArgsConstructor
public class ExamAttemptController {

    private final StartExamAttemptUseCase startExamAttemptUseCase;
    private final SubmitExamAttemptUseCase submitExamAttemptUseCase;
    private final GetMyExamAttemptsUseCase getMyExamAttemptsUseCase;
    private final ExamAttemptResponseMapper attemptResponseMapper;

    @Operation(summary = "Bat dau lam de", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/{examId}/attempts")
    public ResponseEntity<ExamAttemptResponse> start(
            @PathVariable UUID examId,
            @Valid @RequestBody StartExamAttemptRequest request,
            Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
        var attempt =
                startExamAttemptUseCase.start(
                        new StartExamAttemptUseCase.StartExamAttemptCommand(
                                examId, userInfo.getId(), request.gradeLevel(), request.className()));
        return ResponseEntity.ok(attemptResponseMapper.toResponse(attempt));
    }

    @Operation(summary = "Nop bai lam de", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/attempts/{attemptId}/submit")
    public ResponseEntity<ExamAttemptResponse> submit(
            @PathVariable UUID attemptId,
            @Valid @RequestBody SubmitExamAttemptRequest request,
            Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
        var attempt =
                submitExamAttemptUseCase.submit(
                        new SubmitExamAttemptUseCase.SubmitExamAttemptCommand(
                                attemptId,
                                userInfo.getId(),
                                request.answers().stream()
                                        .map(
                                                answer ->
                                                        new SubmitExamAttemptUseCase.SubmitAnswerCommand(
                                                                answer.questionId(),
                                                                answer.selectedOptionId(),
                                                                answer.answerText()))
                                        .toList()));
        return ResponseEntity.ok(attemptResponseMapper.toResponse(attempt));
    }

    @Operation(summary = "Lich su lam de cua toi", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/attempts/me")
    public ResponseEntity<List<ExamAttemptResponse>> getMyAttempts(Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
        return ResponseEntity.ok(
                getMyExamAttemptsUseCase.getMyAttempts(userInfo.getId()).stream()
                        .map(attemptResponseMapper::toResponse)
                        .toList());
    }
}
