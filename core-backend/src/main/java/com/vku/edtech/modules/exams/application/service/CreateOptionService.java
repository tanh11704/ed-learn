package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.exception.InvalidQuestionTypeException;
import com.vku.edtech.modules.exams.application.port.in.CreateOptionUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateOptionService implements CreateOptionUseCase {

    private final ExamQuestionQueryPort questionQueryPort;
    private final ExamOptionCommandPort optionCommandPort;

    @Override
    @Transactional
    public ExamQuestionOption create(CreateOptionCommand command) {
        ExamQuestion question =
                questionQueryPort
                        .findById(command.questionId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy câu hỏi"));

        if (question.getQuestionType() == ExamQuestionType.SHORT_ANSWER) {
            throw new InvalidQuestionTypeException("SHORT_ANSWER không sử dụng option");
        }

        if (question.getQuestionType() == ExamQuestionType.TRUE_FALSE) {
            if (question.getOptions().size() >= 4) {
                throw new InvalidQuestionTypeException("TRUE_FALSE chỉ được phép có 4 option");
            }
        }
        if (question.getQuestionType() == ExamQuestionType.MULTIPLE_CHOICE) {
            if (question.getOptions().size() >= 4) {
                throw new InvalidQuestionTypeException("MULTIPLE_CHOICE chỉ được phép có 4 option");
            }
            if (command.correct()
                    && question.getOptions().stream().anyMatch(ExamQuestionOption::isCorrect)) {
                throw new InvalidQuestionTypeException("MULTIPLE_CHOICE chỉ được phép có 1 option đúng");
            }
        }

        ExamQuestionOption option =
                ExamQuestionOption.createNew(
                        command.questionId(), command.content(), command.correct(), command.orderIndex());
        return optionCommandPort.save(option);
    }
}
