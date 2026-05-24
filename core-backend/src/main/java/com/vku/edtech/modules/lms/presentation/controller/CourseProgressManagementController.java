package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetAdminCourseProgressUseCase;
import com.vku.edtech.modules.lms.presentation.dto.response.AdminCourseProgressResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/management/course-progress")
@RequiredArgsConstructor
@Tag(
        name = "Quan ly tien do hoc",
        description = "API admin theo doi tien do hoc cua hoc vien")
public class CourseProgressManagementController {

    private final GetAdminCourseProgressUseCase getAdminCourseProgressUseCase;

    @Operation(
            summary = "Lay tien do hoc theo khoa hoc",
            description = "Tra ve danh sach hoc vien trong mot khoa hoc kem tien do hoan thanh.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping
    public ResponseEntity<List<AdminCourseProgressResponse>> getCourseProgressByCourse(
            @RequestParam UUID courseId) {
        var responses =
                getAdminCourseProgressUseCase.getCourseProgressByCourseId(courseId).stream()
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
