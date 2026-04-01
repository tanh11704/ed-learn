package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetDashboardSummaryUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetMonthlyEnrollmentsUseCase;
import com.vku.edtech.modules.lms.application.port.in.GetTopCoursesUseCase;
import com.vku.edtech.modules.lms.presentation.dto.response.DashboardSummaryResponse;
import com.vku.edtech.modules.lms.presentation.dto.response.MonthlyEnrollmentResponse;
import com.vku.edtech.modules.lms.presentation.dto.response.TopCourseResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(
        name = "Thống kê",
        description =
                "API API quản lý các số liệu thống kê chung (Dashboard, Doanh thu, Lượt đăng ký)")
@RestController
@RequestMapping("/api/v1/statistics")
@RequiredArgsConstructor
public class StatisticsController {

    private final GetTopCoursesUseCase getTopCoursesUseCase;
    private final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
    private final GetMonthlyEnrollmentsUseCase getMonthlyEnrollmentsUseCase;

    @Operation(
            summary = "Lấy danh sách Top khóa học nổi bật",
            description = "Trả về danh sách 5 khóa học có số lượng sinh viên đăng ký nhiều nhất.")
    @GetMapping("/top-courses")
    public ResponseEntity<List<TopCourseResponse>> getTopCourses() {
        var query = new GetTopCoursesUseCase.GetTopCoursesQuery(5);
        var results = getTopCoursesUseCase.getTopCourses(query);
        var responses =
                results.stream()
                        .map(
                                res ->
                                        new TopCourseResponse(
                                                res.courseId(), res.title(), res.totalStudents()))
                        .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @Operation(
            summary = "Lấy dữ liệu tổng quan cho Dashboard",
            description =
                    "Trả về tổng số học viên, tổng số khóa học đang active, tổng doanh thu và lượt đăng ký trong tháng hiện tại.")
    @GetMapping("/summary")
    public ResponseEntity<DashboardSummaryResponse> getDashboardSummary() {
        var query = new GetDashboardSummaryUseCase.GetDashboardSummaryQuery();
        var result = getDashboardSummaryUseCase.getDashboardSummary(query);
        var response =
                new DashboardSummaryResponse(
                        result.totalStudents(),
                        result.totalActiveCourses(),
                        result.currentMonthEnrollments(),
                        result.currentMonthRevenue());
        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Lấy số lượt đăng ký mới theo từng tháng",
            description =
                    "Trả về dữ liệu số lượng lượt đăng ký theo từng tháng trong năm nay (hoặc theo năm truyền vào) để vẽ biểu đồ.")
    @GetMapping("/monthly-enrollments")
    public ResponseEntity<List<MonthlyEnrollmentResponse>> getMonthlyEnrollments(
            @RequestParam(name = "year", required = false) Integer year) {
        int targetYear = year != null ? year : LocalDate.now().getYear();
        var query = new GetMonthlyEnrollmentsUseCase.GetMonthlyEnrollmentsQuery(targetYear);
        var results = getMonthlyEnrollmentsUseCase.getMonthlyEnrollments(query);
        var responses =
                results.stream()
                        .map(
                                res ->
                                        new MonthlyEnrollmentResponse(
                                                res.month(), res.year(), res.enrollments()))
                        .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }
}
