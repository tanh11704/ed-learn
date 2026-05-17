package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.port.in.GetOptionsUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetOptionsService implements GetOptionsUseCase {

    private final ExamOptionQueryPort optionQueryPort;

    @Override
    public List<ExamQuestionOption> getOptionsByQuestionId(UUID questionId) {
        return optionQueryPort.findAllByQuestionId(questionId);
    }
}
