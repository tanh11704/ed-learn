package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetCoursesUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetCoursesService implements GetCoursesUseCase {

    //    private final CourseCachePort courseCachePort;
    private final CourseQueryPort courseQueryPort;

    @Override
    @Cacheable(
            value = "coursePage",
            key =
                    "(#query.subject() != null  ? #query.subject() : 'ALL') + '_' + #query.pageable().pageNumber + #query.pageable().pageSize",
            sync = true)
    public CustomPage<Course> getCourses(GetCoursesQuery query) {
        String safeSubject = (query.subject() != null) ? query.subject().trim() : null;
        Page<Course> springPage = courseQueryPort.findCourses(safeSubject, query.pageable());
        //        return courseCachePort
        //                .getPage(
        //                        query.subject(),
        //                        query.pageable().getPageNumber(),
        //                        query.pageable().getPageSize())
        //                .map(cached -> toSpringPage(cached, query))
        //                .orElseGet(() -> loadFromDatabaseAndCache(query));
        return CustomPage.from(springPage);
    }

    //    private Page<Course> loadFromDatabaseAndCache(GetCoursesQuery query) {
    //        Page<Course> page = courseQueryPort.findCourses(query.subject(), query.pageable());
    //
    //        courseCachePort.savePage(
    //                query.subject(),
    //                query.pageable().getPageNumber(),
    //                query.pageable().getPageSize(),
    //                CustomPage.from(page));
    //
    //        return page;
    //    }
    //
    //    private Page<Course> toSpringPage(CustomPage<Course> cachedPage, GetCoursesQuery query) {
    //        return new PageImpl<>(
    //                cachedPage.getContent(), query.pageable(), cachedPage.getTotalElements());
    //    }
}
