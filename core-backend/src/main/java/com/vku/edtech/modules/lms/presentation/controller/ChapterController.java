package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.CreateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.in.DeleteChapterUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetChaptersUseCase;
import com.vku.edtech.modules.lms.application.port.in.UpdateChapterUseCase;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.presentation.dto.mapper.ChapterResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateChapterRequest;
import com.vku.edtech.modules.lms.presentation.dto.request.UpdateChapterRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.ChapterResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Chương học", description = "API quản lý chương trong khóa học")
@RestController
@RequestMapping("/api/v1/management/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final CreateChapterUseCase createChapterUseCase;
    private final UpdateChapterUseCase updateChapterUseCase;
    private final DeleteChapterUseCase deleteChapterUseCase;
    private final GetChaptersUseCase getChaptersUseCase;
    private final ChapterResponseMapper chapterMapper;

    @Operation(summary = "Lấy danh sách chapter theo course", security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping
    public ResponseEntity<List<ChapterResponse>> getByCourseId(
            @RequestParam UUID courseId,
            @RequestParam(defaultValue = "ACTIVE") String status) {
        List<ChapterResponse> responses =
                getChaptersUseCase.getChaptersByCourseId(courseId, status).stream()
                        .map(chapterMapper::toResponse)
                        .toList();
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "Tạo chapter", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping
    public ResponseEntity<ChapterResponse> create(@Valid @RequestBody CreateChapterRequest request) {
        CreateChapterUseCase.CreateChapterCommand command =
                new CreateChapterUseCase.CreateChapterCommand(
                        request.courseId(), request.title(), request.orderIndex());

        Chapter chapter = createChapterUseCase.createChapter(command);
        return ResponseEntity.ok(chapterMapper.toResponse(chapter));
    }

    @Operation(summary = "Cập nhật chapter", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/{id}")
    public ResponseEntity<ChapterResponse> update(
            @PathVariable("id") UUID id, @RequestBody @Valid UpdateChapterRequest request) {
        UpdateChapterUseCase.UpdateChapterCommand command =
                new UpdateChapterUseCase.UpdateChapterCommand(
                        id, request.courseId(), request.title(), request.orderIndex());
        Chapter chapter = updateChapterUseCase.updateChapter(command);
        return ResponseEntity.ok(chapterMapper.toResponse(chapter));
    }

    @Operation(summary = "Xóa chapter", security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") UUID id) {
        deleteChapterUseCase.deleteChapter(new DeleteChapterUseCase.DeleteChapterCommand(id));
        return ResponseEntity.noContent().build();
    }
}
