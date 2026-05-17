package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.CreateOptionUseCase;
import com.vku.edtech.modules.exams.application.port.in.DeleteOptionUseCase;
import com.vku.edtech.modules.exams.application.port.in.GetOptionsUseCase;
import com.vku.edtech.modules.exams.application.port.in.UpdateOptionUseCase;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.presentation.dto.mapper.ExamQuestionOptionResponseMapper;
import com.vku.edtech.modules.exams.presentation.dto.request.CreateOptionRequest;
import com.vku.edtech.modules.exams.presentation.dto.request.UpdateOptionRequest;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamQuestionOptionResponse;
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
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Quản lý Option", description = "API admin để quản lý đáp án của câu hỏi")
@RestController
@RequestMapping("/api/v1/admin/exams/questions/{questionId}/options")
@RequiredArgsConstructor
public class ExamOptionAdminController {

    private final CreateOptionUseCase createOptionUseCase;
    private final UpdateOptionUseCase updateOptionUseCase;
    private final DeleteOptionUseCase deleteOptionUseCase;
    private final GetOptionsUseCase getOptionsUseCase;
    private final ExamQuestionOptionResponseMapper optionResponseMapper;

    @Operation(summary = "Lấy danh sách option theo question", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping
    public ResponseEntity<List<ExamQuestionOptionResponse>> getByQuestionId(
            @PathVariable UUID questionId) {
        List<ExamQuestionOptionResponse> responses =
                getOptionsUseCase.getOptionsByQuestionId(questionId).stream()
                        .map(optionResponseMapper::toResponse)
                        .toList();
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "Tạo option", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping
    public ResponseEntity<ExamQuestionOptionResponse> create(
            @PathVariable UUID questionId, @Valid @RequestBody CreateOptionRequest request) {
        ExamQuestionOption option =
                createOptionUseCase.create(
                        new CreateOptionUseCase.CreateOptionCommand(
                                questionId, request.content(), request.correct(), request.orderIndex()));
        return ResponseEntity.ok(optionResponseMapper.toResponse(option));
    }

    @Operation(summary = "Cập nhật option", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/{optionId}")
    public ResponseEntity<ExamQuestionOptionResponse> update(
            @PathVariable UUID questionId,
            @PathVariable UUID optionId,
            @Valid @RequestBody UpdateOptionRequest request) {
        ExamQuestionOption option =
                updateOptionUseCase.update(
                        new UpdateOptionUseCase.UpdateOptionCommand(
                                optionId, request.content(), request.correct(), request.orderIndex()));
        return ResponseEntity.ok(optionResponseMapper.toResponse(option));
    }

    @Operation(summary = "Xóa option", security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/{optionId}")
    public ResponseEntity<Void> delete(
            @PathVariable UUID questionId, @PathVariable UUID optionId) {
        deleteOptionUseCase.delete(new DeleteOptionUseCase.DeleteOptionCommand(optionId));
        return ResponseEntity.noContent().build();
    }
}
