package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.EnrollCourseUseCase;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.security.Principal;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/courses")
@RequiredArgsConstructor
@Tag(
        name = "Xử lý Khóa học của Sinh viên",
        description = "Các thao tác đăng ký khóa học - Student API")
public class EnrollmentController {

    private final EnrollCourseUseCase enrollCourseUseCase;

    @Operation(
            summary = "Đăng ký khóa học",
            description =
                    "Đăng ký tham gia một khóa học. Tham số userId được lấy từ token đăng nhập để chống IDOR.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/{id}/enroll")
    public ResponseEntity<Void> enrollCourse(@PathVariable UUID id, Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();

        enrollCourseUseCase.enrollCourse(
                new EnrollCourseUseCase.EnrollCourseCommand(userInfo.getId(), id));

        return ResponseEntity.ok().build();
    }
}
