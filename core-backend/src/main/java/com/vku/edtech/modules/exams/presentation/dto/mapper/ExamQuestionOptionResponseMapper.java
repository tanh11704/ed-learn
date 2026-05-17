package com.vku.edtech.modules.exams.presentation.dto.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamQuestionOptionResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ExamQuestionOptionResponseMapper {
    ExamQuestionOptionResponse toResponse(ExamQuestionOption option);
}
