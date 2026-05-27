package com.vku.edtech.modules.exams.presentation.controller;

import com.vku.edtech.modules.exams.application.port.in.CreateQuestionUseCase;
import com.vku.edtech.modules.exams.application.port.in.UpdateQuestionUseCase;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.presentation.dto.mapper.ExamQuestionResponseMapper;
import com.vku.edtech.modules.exams.presentation.dto.request.CreateOptionRequest;
import com.vku.edtech.modules.exams.presentation.dto.request.CreateQuestionRequest;
import com.vku.edtech.modules.exams.presentation.dto.request.UpdateQuestionRequest;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamQuestionResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Quản lý câu hỏi", description = "API admin để tạo câu hỏi của đề thi")
@RestController
@RequestMapping("/api/v1/admin/exams/questions")
@RequiredArgsConstructor
public class ExamQuestionAdminController {

    private final CreateQuestionUseCase createQuestionUseCase;
    private final UpdateQuestionUseCase updateQuestionUseCase;
    private final ExamQuestionResponseMapper examQuestionResponseMapper;

    @Operation(summary = "Tạo câu hỏi", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ExamQuestionResponse> create(@Valid @RequestBody CreateQuestionRequest request) {
        ExamQuestion question =
                createQuestionUseCase.create(
                        new CreateQuestionUseCase.CreateQuestionCommand(
                                request.examId(),
                                request.questionType(),
                                request.paperPart(),
                                request.content(),
                                request.imageUrl(),
                                null,
                                request.orderIndex(),
                                request.score(),
                                request.correctAnswer(),
                                toOptionCommands(request)));
        return ResponseEntity.ok(examQuestionResponseMapper.toResponse(question));
    }

    @Operation(summary = "Cập nhật câu hỏi", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping(value = "/{questionId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ExamQuestionResponse> update(
            @PathVariable java.util.UUID questionId, @Valid @RequestBody UpdateQuestionRequest request) {
        ExamQuestion question =
                updateQuestionUseCase.update(
                        new UpdateQuestionUseCase.UpdateQuestionCommand(
                                questionId,
                                request.content(),
                                request.imageUrl(),
                                null,
                                request.orderIndex(),
                                request.score(),
                                request.correctAnswer()));
        return ResponseEntity.ok(examQuestionResponseMapper.toResponse(question));
    }

    @Operation(summary = "Cập nhật câu hỏi kèm hình ảnh", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping(value = "/{questionId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ExamQuestionResponse> updateWithImage(
            @PathVariable java.util.UUID questionId,
            @RequestParam String content,
            @RequestParam(required = false) String imageUrl,
            @RequestParam(required = false) Integer orderIndex,
            @RequestParam Double score,
            @RequestParam(required = false) String correctAnswer,
            @RequestPart(value = "imageFile", required = false) MultipartFile imageFile) {
        ExamQuestion question =
                updateQuestionUseCase.update(
                        new UpdateQuestionUseCase.UpdateQuestionCommand(
                                questionId,
                                content,
                                imageUrl,
                                imageFile,
                                orderIndex,
                                score,
                                correctAnswer));
        return ResponseEntity.ok(examQuestionResponseMapper.toResponse(question));
    }

    @Operation(summary = "Tạo câu hỏi kèm hình ảnh", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ExamQuestionResponse> createWithImage(
            @RequestParam java.util.UUID examId,
            @RequestParam com.vku.edtech.modules.exams.domain.model.ExamQuestionType questionType,
            @RequestParam com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart paperPart,
            @RequestParam String content,
            @RequestParam(required = false) String imageUrl,
            @RequestParam(required = false) Integer orderIndex,
            @RequestParam Double score,
            @RequestParam(required = false) String correctAnswer,
            @RequestParam(required = false) String optionsJson,
            @RequestPart(value = "imageFile", required = false) MultipartFile imageFile)
            throws com.fasterxml.jackson.core.JsonProcessingException {
        List<CreateQuestionUseCase.CreateOptionCommand> options = parseOptionsJson(optionsJson);
        ExamQuestion question =
                createQuestionUseCase.create(
                        new CreateQuestionUseCase.CreateQuestionCommand(
                                examId,
                                questionType,
                                paperPart,
                                content,
                                imageUrl,
                                imageFile,
                                orderIndex,
                                score,
                                correctAnswer,
                                options));
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

    private List<CreateQuestionUseCase.CreateOptionCommand> parseOptionsJson(String optionsJson)
            throws com.fasterxml.jackson.core.JsonProcessingException {
        if (optionsJson == null || optionsJson.isBlank()) {
            return List.of();
        }
        com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();
        java.util.List<CreateOptionRequest> options =
                objectMapper.readValue(
                        optionsJson,
                        objectMapper
                                .getTypeFactory()
                                .constructCollectionType(java.util.List.class, CreateOptionRequest.class));
        return options.stream()
                .map(option ->
                        new CreateQuestionUseCase.CreateOptionCommand(
                                option.content(), option.correct(), option.orderIndex()))
                .toList();
    }
}
