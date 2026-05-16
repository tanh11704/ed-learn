package com.vku.edtech.modules.lms.application.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.lms.application.port.in.CreateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class CreateCourseServiceTest {

    @Mock private CourseCommandPort courseCommandPort;

    @InjectMocks private CreateCourseService createCourseService;

    @Test
    @DisplayName("Tạo course mới sẽ lưu domain đúng dữ liệu")
    void createCourse_success() {
        CreateCourseUseCase.CreateCourseCommand command =
                new CreateCourseUseCase.CreateCourseCommand(
                        "Spring Boot", "Khóa học backend", "CNTT");

        when(courseCommandPort.save(org.mockito.ArgumentMatchers.any(Course.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Course result = createCourseService.createCourse(command);

        assertNotNull(result);
        assertEquals("Spring Boot", result.getTitle());
        assertEquals("Khóa học backend", result.getDescription());
        assertEquals("CNTT", result.getSubject());
        verify(courseCommandPort).save(org.mockito.ArgumentMatchers.any(Course.class));
    }
}
