package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.CreateQuestionUseCase;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.presentation.dto.mapper.ExamQuestionResponseMapper;
import com.vku.edtech.modules.exams.presentation.dto.request.CreateQuestionRequest;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamQuestionResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Quản lý câu hỏi", description = "API admin để tạo câu hỏi của đề thi")
@RestController
@RequestMapping("/api/v1/admin/exams/questions")
@RequiredArgsConstructor
public class ExamQuestionAdminController {

    private final CreateQuestionUseCase createQuestionUseCase;
    private final ExamQuestionResponseMapper examQuestionResponseMapper;

    @Operation(summary = "Tạo câu hỏi", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping
    public ResponseEntity<ExamQuestionResponse> create(@Valid @RequestBody CreateQuestionRequest request) {
        ExamQuestion question =
                createQuestionUseCase.create(
                        new CreateQuestionUseCase.CreateQuestionCommand(
                                request.examId(),
                                request.questionType(),
                                request.paperPart(),
                                request.content(),
                                request.orderIndex(),
                                request.score(),
                                request.correctAnswer(),
                                toOptionCommands(request)));
        return ResponseEntity.ok(examQuestionResponseMapper.toResponse(question));
    }

    private List<CreateQuestionUseCase.CreateOptionCommand> toOptionCommands(
            CreateQuestionRequest request) {
        if (request.options() == null) {
            return List.of();
        }
        return request.options().stream()
                .map(option ->
                        new CreateQuestionUseCase.CreateOptionCommand(
                                option.content(), option.correct(), option.orderIndex()))
                .toList();
    }
}
