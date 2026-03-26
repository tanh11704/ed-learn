package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetUserEnrolledCoursesUseCase;
import com.vku.edtech.modules.lms.presentation.dto.response.EnrolledCourseResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "Góc học tập của Sinh viên", description = "Các API dành riêng cho người dùng xem khóa học của mình")
public class StudentLearningController {

    private final GetUserEnrolledCoursesUseCase getUserEnrolledCoursesUseCase;

    @Operation(
            summary = "Khóa học của tôi",
            description = "Lấy danh sách các khóa học mà sinh viên đang đăng nhập đã tham gia.",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @GetMapping("/my-courses")
    public ResponseEntity<List<EnrolledCourseResponse>> getMyCourses(Principal principal) {
        JwtUserInfo userInfo = (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
        
        var query = new GetUserEnrolledCoursesUseCase.GetUserEnrolledCoursesQuery(userInfo.getId());
        var results = getUserEnrolledCoursesUseCase.getEnrolledCourses(query);

        var responses = results.stream()
                .map(res -> new EnrolledCourseResponse(res.courseId(), res.title(), res.thumbnailUrl(), res.enrolledDate()))
                .collect(Collectors.toList());

        return ResponseEntity.ok(responses);
    }
}
