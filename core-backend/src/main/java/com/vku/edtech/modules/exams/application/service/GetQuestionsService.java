package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.port.in.GetQuestionsUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GetQuestionsService implements GetQuestionsUseCase {

    private final ExamQuestionQueryPort questionQueryPort;

    @Override
    public List<ExamQuestion> getQuestionsByExamId(UUID examId) {
        return questionQueryPort.findAllByExamId(examId);
    }
}
