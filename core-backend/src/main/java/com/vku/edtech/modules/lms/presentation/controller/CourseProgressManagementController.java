package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetAdminCourseProgressUseCase;
import com.vku.edtech.modules.lms.presentation.dto.response.AdminCourseProgressResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/management/course-progress")
@RequiredArgsConstructor
@Tag(name = "Quản lý tiến độ học", description = "API admin theo dõi tiến độ học của học viên")
public class CourseProgressManagementController {

    private final GetAdminCourseProgressUseCase getAdminCourseProgressUseCase;

    @Operation(
            summary = "Lấy toàn bộ tiến độ học",
            description = "Trả về danh sách đăng ký khóa học kèm tiến độ hoàn thành của từng học viên.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping
    public ResponseEntity<List<AdminCourseProgressResponse>> getCourseProgress() {
        var responses =
                getAdminCourseProgressUseCase.getCourseProgress().stream()
                        .map(
                                item ->
                                        new AdminCourseProgressResponse(
                                                item.enrollmentId(),
                                                item.studentId(),
                                                item.studentName(),
                                                item.email(),
                                                item.courseId(),
                                                item.courseTitle(),
                                                item.enrolledAt(),
                                                item.progressPercent(),
                                                item.completedLessons(),
                                                item.totalLessons(),
                                                item.lastActivity(),
                                                item.status()))
                        .collect(Collectors.toList());

        return ResponseEntity.ok(responses);
    }
}
