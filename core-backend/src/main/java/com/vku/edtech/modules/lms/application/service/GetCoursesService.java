package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.application.port.out.CourseVisibilityPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCoursesService implements GetCoursesUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseVisibilityPort courseVisibilityPort;

    @Override
    @Cacheable(
            value = "coursePage",
            key =
                    "(#query.subject() != null  ? #query.subject() : 'ALL') + '_' + #query.pageable().pageNumber + #query.pageable().pageSize + '_' + #root.target.canViewDeletedCourses()",
            sync = true)
    public CustomPage<Course> getCourses(GetCoursesQuery query) {
        String safeSubject = (query.subject() != null) ? query.subject().trim() : null;
        Page<Course> springPage =
                courseQueryPort.findCourses(safeSubject, query.pageable(), canViewDeletedCourses());

        return CustomPage.from(springPage);
    }

    public boolean canViewDeletedCourses() {
        return courseVisibilityPort.canViewDeletedCourses();
    }

}
