package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.CreateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.in.DeleteCourseUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetCourseMetadataUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.in.UpdateCourseUseCase;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.modules.lms.presentation.dto.mapper.CourseResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateCourseRequest;
import com.vku.edtech.modules.lms.presentation.dto.request.UpdateCourseRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.CourseResponse;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Khóa học", description = "API quản lý khóa học")
@RestController
@RequestMapping("/api/v1/courses")
@RequiredArgsConstructor
public class CourseController {

    private final GetCoursesUseCase getCoursesUseCase;
    private final GetCourseMetadataUseCase getCourseMetadataUseCase;
    private final CreateCourseUseCase createCourseUseCase;
    private final UpdateCourseUseCase updateCourseUseCase;
    private final DeleteCourseUseCase deleteCourseUseCase;
    private final CourseResponseMapper courseResponseMapper;

    @Operation(summary = "Lấy danh sách khóa học", description = "Lấy danh sách khóa học có phân trang, có thể lọc theo chủ đề.")
    @GetMapping
    public ResponseEntity<CustomPage<CourseResponse>> getCourses(
            @RequestParam(required = false) String subject,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        CustomPage<Course> courses =
                getCoursesUseCase.getCourses(
                        new GetCoursesUseCase.GetCoursesQuery(subject, PageRequest.of(page, size)));

        return ResponseEntity.ok(courses.map(courseResponseMapper::toResponse));
    }

    @Operation(summary = "Lấy chi tiết khóa học", description = "Lấy thông tin chi tiết của một khóa học, bao gồm các chương của nó.")
    @GetMapping("/{id}")
    public ResponseEntity<CourseResponse> getCourseDetail(@PathVariable UUID id) {
        Course course =
                getCourseMetadataUseCase.getCourseWithChapters(
                        new GetCourseMetadataUseCase.GetCourseMetadataQuery(id));
        return ResponseEntity.ok(courseResponseMapper.toResponse(course));
    }

    @Operation(summary = "Tạo khóa học mới", security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/admin")
    public ResponseEntity<CourseResponse> createCourse(@Valid @RequestBody CreateCourseRequest request) {
        CreateCourseUseCase.CreateCourseCommand command =
                new CreateCourseUseCase.CreateCourseCommand(request.title(), request.description(), request.subject());
        Course newCourse = createCourseUseCase.createCourse(command);
        return ResponseEntity.ok(courseResponseMapper.toResponse(newCourse));
    }

    @Operation(summary = "Cập nhật khóa học", security = @SecurityRequirement(name = "bearerAuth"))
    @PutMapping("/admin/{id}")
    public ResponseEntity<CourseResponse> updateCourse(
            @PathVariable UUID id, @Valid @RequestBody UpdateCourseRequest request) {
        UpdateCourseUseCase.UpdateCourseCommand command =
                new UpdateCourseUseCase.UpdateCourseCommand(
                        id, request.title(), request.description(), request.subject(), request.thumbnailUrl());
        Course updatedCourse = updateCourseUseCase.updateCourse(command);
        return ResponseEntity.ok(courseResponseMapper.toResponse(updatedCourse));
    }

    @Operation(summary = "Xóa khóa học", security = @SecurityRequirement(name = "bearerAuth"))
    @DeleteMapping("/admin/{id}")
    public ResponseEntity<Void> deleteCourse(@PathVariable UUID id) {
        deleteCourseUseCase.deleteCourse(new DeleteCourseUseCase.DeleteCourseCommand(id));
        return ResponseEntity.noContent().build();
    }
}
