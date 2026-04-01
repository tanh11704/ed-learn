package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetLessonDetailUseCase;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.mapper.LessonResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Lesson Learning", description = "API học tập cho học viên")
@RestController
@RequestMapping("/api/v1/learning/lessons")
@RequiredArgsConstructor
public class StudentLessonController {

    private final GetLessonDetailUseCase getLessonDetailUseCase;
    private final LessonResponseMapper lessonResponseMapper;

    @Operation(
            summary = "Lấy chi tiết bài học để học",
            description =
                    "Nếu lesson là preview thì cho xem. Nếu không phải preview thì user phải đăng nhập và đã enrolled khóa học.",
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                @ApiResponse(responseCode = "200", description = "Thành công"),
                @ApiResponse(
                        responseCode = "403",
                        description = "Không có quyền truy cập",
                        content = @Content(schema = @Schema(implementation = Object.class))),
                @ApiResponse(responseCode = "404", description = "Không tìm thấy lesson")
            })
    @GetMapping("/{id}/play")
    public ResponseEntity<LessonResponse> playLesson(@PathVariable("id") UUID id) {
        Lesson lesson =
                getLessonDetailUseCase.getLessonDetail(
                        new GetLessonDetailUseCase.GetLessonDetailQuery(id));
        return ResponseEntity.ok(lessonResponseMapper.toResponse(lesson));
    }
}
