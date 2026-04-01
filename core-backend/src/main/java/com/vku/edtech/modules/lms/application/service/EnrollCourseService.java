package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.EnrollCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.application.port.out.EnrollmentCommandPort;
import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import com.vku.edtech.modules.lms.domain.model.Enrollment;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class EnrollCourseService implements EnrollCourseUseCase {

    private final CourseQueryPort courseQueryPort;
    private final EnrollmentCommandPort enrollmentCommandPort;

    @Override
    @Transactional
    public Enrollment enrollCourse(EnrollCourseCommand command) {
        // Kiểm tra course tồn tại
        courseQueryPort
                .findByIdWithChapters(command.courseId())
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy khóa học"));

        // Kiểm tra xem đã đăng ký chưa
        if (enrollmentCommandPort.existsByUserIdAndCourseId(command.userId(), command.courseId())) {
            throw new InvalidDomainDataException("User đã đăng ký khóa học này rồi");
        }

        // Tạo Entity logic (Mặc định giá 0L tạm thời)
        Enrollment enrollment = Enrollment.createNew(command.userId(), command.courseId(), 0L);

        // Lưu
        return enrollmentCommandPort.save(enrollment);
    }
}
