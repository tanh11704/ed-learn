package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetLessonDetailUseCase;
import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase;
import com.vku.edtech.modules.lms.application.port.in.UploadLessonMediaUseCase.UploadLessonMediaCommand;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.mapper.LessonResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Bài học", description = "API quản lý bài học")
@RestController
@RequestMapping("/api/v1/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final GetLessonDetailUseCase getLessonDetailUseCase;
    private final UploadLessonMediaUseCase uploadLessonMediaUseCase;
    private final LessonResponseMapper lessonResponseMapper;

    @Operation(
            summary = "Lấy chi tiết bài học",
            description = "Lấy thông tin chi tiết của một bài học.")
    @GetMapping("/{id}")
    public ResponseEntity<LessonResponse> getLessonDetail(@PathVariable("id") UUID id) {
        Lesson lesson =
                getLessonDetailUseCase.getLessonDetail(
                        new GetLessonDetailUseCase.GetLessonDetailQuery(id));
        return ResponseEntity.ok(lessonResponseMapper.toResponse(lesson));
    }

    @Operation(
            summary = "Tải lên tệp phương tiện",
            description = "Tải lên tệp video hoặc PDF cho bài học.")
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
