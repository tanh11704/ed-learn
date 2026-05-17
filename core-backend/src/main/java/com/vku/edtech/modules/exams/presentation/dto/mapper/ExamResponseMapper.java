package com.vku.edtech.modules.exams.presentation.dto.mapper;

import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ExamResponseMapper {
    ExamResponse toResponse(Exam exam);
}
