package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.dto.TopCourseResult;
import com.vku.edtech.modules.lms.application.port.in.GetTopCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.StatisticsQueryPort;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetTopCoursesService implements GetTopCoursesUseCase {

    private final StatisticsQueryPort statisticsQueryPort;

    @Override
    public List<TopCourseResult> getTopCourses(GetTopCoursesQuery query) {
        return statisticsQueryPort.getTopCourses(query.limit());
    }
}
