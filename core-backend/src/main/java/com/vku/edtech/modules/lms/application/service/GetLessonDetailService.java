package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetLessonDetailUseCase;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetLessonDetailService implements GetLessonDetailUseCase {

    private final LessonQueryPort lessonQueryPort;

    @Override
    public Lesson getLessonDetail(GetLessonDetailQuery query) {
        return lessonQueryPort
                .findById(query.lessonId())
                .orElseThrow(() -> new ResourceNotFoundException("Lesson not found"));
    }
}
