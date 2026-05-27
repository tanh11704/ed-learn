package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.CreateExamUseCase;
import com.vku.edtech.modules.exams.application.port.in.DeleteExamUseCase;
import com.vku.edtech.modules.exams.application.port.in.GetAllExamsUseCase;
import com.vku.edtech.modules.exams.application.port.in.GetExamUseCase;
import com.vku.edtech.modules.exams.application.port.in.UpdateExamUseCase;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.presentation.dto.mapper.ExamResponseMapper;
import com.vku.edtech.modules.exams.presentation.dto.request.CreateExamRequest;
import com.vku.edtech.modules.exams.presentation.dto.request.UpdateExamRequest;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Quản lý đề thi", description = "API admin để tạo, sửa, xóa và xem danh sách đề thi")
@RestController
@RequestMapping("/api/v1/admin/exams")
@RequiredArgsConstructor
public class ExamAdminController {

    private final CreateExamUseCase createExamUseCase;
    private final UpdateExamUseCase updateExamUseCase;
    private final DeleteExamUseCase deleteExamUseCase;
    private final GetAllExamsUseCase getAllExamsUseCase;
    private final GetExamUseCase getExamUseCase;
    private final ExamResponseMapper examResponseMapper;

    @Operation(summary = "Lấy danh sách đề thi", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping
    public ResponseEntity<List<ExamResponse>> getAll(
            @RequestParam(defaultValue = "ACTIVE") String status) {
        List<ExamResponse> responses =
                getAllExamsUseCase.getAllExams(status).stream()
                        .map(examResponseMapper::toResponse)
                        .toList();
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "Lấy chi tiết đề thi", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/{id}")
    public ResponseEntity<ExamResponse> getById(@PathVariable UUID id) {
        Exam exam = getExamUseCase.getExam(new GetExamUseCase.GetExamQuery(id));
        return ResponseEntity.ok(examResponseMapper.toResponse(exam));
    }

    @Operation(summary = "Tạo đề thi", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping
    public ResponseEntity<ExamResponse> create(@Valid @RequestBody CreateExamRequest request) {
        Exam exam =
                createExamUseCase.create(
                        new CreateExamUseCase.CreateExamCommand(
                                request.title(),
                                request.subject(),
                                request.schoolYear(),
                                request.durationMinutes(),
                                request.totalQuestions(),
                                request.description()));
        return ResponseEntity.ok(examResponseMapper.toResponse(exam));
    }

    @Operation(summary = "Cập nhật đề thi", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/{id}")
    public ResponseEntity<ExamResponse> update(
            @PathVariable UUID id, @Valid @RequestBody UpdateExamRequest request) {
        Exam exam =
                updateExamUseCase.update(
                        new UpdateExamUseCase.UpdateExamCommand(
                                id,
                                request.title(),
                                request.subject(),
                                request.schoolYear(),
                                request.durationMinutes(),
                                request.totalQuestions(),
                                request.description(),
                                request.status()));
        return ResponseEntity.ok(examResponseMapper.toResponse(exam));
    }

    @Operation(summary = "Xóa đề thi", security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        deleteExamUseCase.delete(new DeleteExamUseCase.DeleteExamCommand(id));
        return ResponseEntity.noContent().build();
    }
}
