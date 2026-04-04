package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.CompleteLessonUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetLessonDetailUseCase;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.modules.lms.presentation.dto.mapper.LessonResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonResponse;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.security.Principal;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Lesson Learning", description = "API học tập của học viên")
@RestController
@RequestMapping("/api/v1/learning/lessons")
@RequiredArgsConstructor
public class StudentLessonController {

    private final GetLessonDetailUseCase getLessonDetailUseCase;
    private final CompleteLessonUseCase completeLessonUseCase;
    private final LessonResponseMapper lessonResponseMapper;

    @Operation(
            summary = "Lấy nội dung lesson để học",
            description =
                    "Nếu lesson là preview thì cho truy cập. Nếu không phải preview thì yêu cầu user đã enrolled.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/{id}/play")
    public ResponseEntity<LessonResponse> playLesson(@PathVariable("id") UUID id) {
        Lesson lesson =
                getLessonDetailUseCase.getLessonDetail(
                        new GetLessonDetailUseCase.GetLessonDetailQuery(id));
        return ResponseEntity.ok(lessonResponseMapper.toResponse(lesson));
    }

    @Operation(
            summary = "Đánh dấu hoàn thành lesson",
            description =
                    "Tracking tiến độ học tập theo user hiện tại. API idempotent: gọi lại nếu đã completed thì vẫn success.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/{lessonId}/complete")
    public ResponseEntity<Void> completeLesson(@PathVariable UUID lessonId, Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();

        completeLessonUseCase.complete(
                new CompleteLessonUseCase.CompleteLessonCommand(userInfo.getId(), lessonId));

        return ResponseEntity.ok().build();
    }
}
