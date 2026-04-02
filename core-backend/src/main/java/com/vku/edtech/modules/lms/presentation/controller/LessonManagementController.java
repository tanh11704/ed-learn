package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.CreateLessonUseCase;
import com.vku.edtech.modules.lms.application.port.in.DeleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.in.UpdateLessonUseCase;
import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase;
import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase.UploadLessonMediaCommand;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.mapper.LessonResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateLessonRequest;
import com.vku.edtech.modules.lms.presentation.dto.request.UpdateLessonRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Lesson Management", description = "API quản trị bài học (ADMIN)")
@RestController
@RequestMapping("/api/v1/management/lessons")
@RequiredArgsConstructor
public class LessonManagementController {

    private final UploadLessonMediaUseCase uploadLessonMediaUseCase;
    private final CreateLessonUseCase createLessonUseCase;
    private final UpdateLessonUseCase updateLessonUseCase;
    private final DeleteLessonUseCase deleteLessonUseCase;
    private final LessonResponseMapper lessonResponseMapper;

    @Operation(
            summary = "Tạo lesson",
            description = "Chỉ ADMIN được phép tạo lesson.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping
    public ResponseEntity<LessonResponse> createLesson(
            @Valid @RequestBody CreateLessonRequest request) {
        CreateLessonUseCase.CreateLessonCommand command =
                new CreateLessonUseCase.CreateLessonCommand(
                        UUID.fromString(request.chapterId()),
                        request.title(),
                        request.orderIndex(),
                        request.isPreview());

        Lesson lesson = createLessonUseCase.create(command);
        return ResponseEntity.ok(lessonResponseMapper.toResponse(lesson));
    }

    @Operation(
            summary = "Cập nhật lesson",
            description = "Chỉ ADMIN được phép cập nhật lesson.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/{id}")
    public ResponseEntity<LessonResponse> updateLesson(
            @PathVariable("id") UUID id, @Valid @RequestBody UpdateLessonRequest request) {
        UpdateLessonUseCase.UpdateLessonCommand command =
                new UpdateLessonUseCase.UpdateLessonCommand(
                        id,
                        request.chapterId() == null ? null : UUID.fromString(request.chapterId()),
                        request.title(),
                        request.orderIndex(),
                        request.isPreview());

        Lesson lesson = updateLessonUseCase.update(command);
        return ResponseEntity.ok(lessonResponseMapper.toResponse(lesson));
    }

    @Operation(
            summary = "Xóa mềm lesson",
            description = "Chỉ ADMIN được phép xóa lesson. Hệ thống dùng soft delete.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLesson(@PathVariable("id") UUID id) {
        deleteLessonUseCase.delete(new DeleteLessonUseCase.DeleteLessonCommand(id));
        return ResponseEntity.noContent().build();
    }

    @Operation(
            summary = "Tải lên tệp phương tiện",
            description = "Tải lên tệp video hoặc PDF cho bài học.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/{id}/upload")
    public ResponseEntity<LessonResponse> uploadMedia(
            @Parameter(description = "ID của bài học") @PathVariable("id") UUID lessonId,
            @Parameter(description = "Tệp phương tiện cần tải lên") @RequestParam("file")
                    MultipartFile file,
            @Parameter(description = "Loại tệp: VIDEO hoặc PDF") @RequestParam("mediaType")
                    String mediaType) {
        UploadLessonMediaCommand command = new UploadLessonMediaCommand(lessonId, file, mediaType);

        Lesson updatedLesson = uploadLessonMediaUseCase.uploadMedia(command);
        return ResponseEntity.ok(lessonResponseMapper.toResponse(updatedLesson));
    }
}
