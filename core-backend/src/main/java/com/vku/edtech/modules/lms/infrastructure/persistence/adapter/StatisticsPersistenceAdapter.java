package com.vku.edtech.modules.lms.infrastructure.persistence.adapter;

import com.vku.edtech.modules.lms.application.dto.DashboardSummaryResult;
import com.vku.edtech.modules.lms.application.dto.MonthlyEnrollmentResult;
import com.vku.edtech.modules.lms.application.dto.TopCourseResult;
import com.vku.edtech.modules.lms.application.port.out.StatisticsQueryPort;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.EnrollmentStatisticsJpaRepository;
import java.time.Instant;
import java.time.LocalDate;
import java.time.Year;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class StatisticsPersistenceAdapter implements StatisticsQueryPort {

    private final EnrollmentStatisticsJpaRepository enrollmentStatisticsRepository;

    @Override
    public List<TopCourseResult> getTopCourses(int limit) {
        return enrollmentStatisticsRepository.findTopCourses(limit).stream()
                .map(
                        projection ->
                                new TopCourseResult(
                                        projection.getCourseId(),
                                        projection.getTitle(),
                                        projection.getTotalStudents() != null
                                                ? projection.getTotalStudents()
                                                : 0L))
                .collect(Collectors.toList());
    }

    @Override
    public DashboardSummaryResult getDashboardSummary() {
        LocalDate now = LocalDate.now();
        int currentMonth = now.getMonthValue();
        int currentYear = now.getYear();

        YearMonth yearMonth = YearMonth.of(currentYear, currentMonth);
        Instant startDate = yearMonth.atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant();
        Instant endDate =
                yearMonth.plusMonths(1).atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant();

        long totalStudents = enrollmentStatisticsRepository.countTotalStudents();
        long totalActiveCourses = enrollmentStatisticsRepository.countTotalCourses();
        long currentMonthEnrollments =
                enrollmentStatisticsRepository.countCurrentMonthEnrollments(startDate, endDate);
        Long currentMonthRevenue =
                enrollmentStatisticsRepository.sumCurrentMonthRevenue(startDate, endDate);

        return new DashboardSummaryResult(
                totalStudents,
                totalActiveCourses,
                currentMonthEnrollments,
                currentMonthRevenue != null ? currentMonthRevenue : 0L);
    }

    @Override
    public List<MonthlyEnrollmentResult> getMonthlyEnrollments(int year) {
        Instant startDate = Year.of(year).atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant();
        Instant endDate =
                Year.of(year + 1).atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant();

        return enrollmentStatisticsRepository.countMonthlyEnrollments(startDate, endDate).stream()
                .map(
                        projection ->
                                new MonthlyEnrollmentResult(
                                        projection.getMonth(),
                                        projection.getYear(),
                                        projection.getEnrollments() != null
                                                ? projection.getEnrollments()
                                                : 0L))
                .collect(Collectors.toList());
    }
}
