package com.vku.edtech.modules.exams.presentation.dto.mapper;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamQuestionResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", uses = {ExamQuestionOptionResponseMapper.class})
public interface ExamQuestionResponseMapper {
    ExamQuestionResponse toResponse(ExamQuestion question);
}
