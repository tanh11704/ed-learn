package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.exception.InvalidQuestionTypeException;
import com.vku.edtech.modules.exams.application.port.in.UpdateOptionUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionQueryPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateOptionService implements UpdateOptionUseCase {

    private final ExamOptionQueryPort optionQueryPort;
    private final ExamOptionCommandPort optionCommandPort;
    private final ExamQuestionQueryPort questionQueryPort;

    @Override
    @Transactional
    public ExamQuestionOption update(UpdateOptionCommand command) {
        ExamQuestionOption option =
                optionQueryPort
                        .findById(command.optionId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy option"));

        ExamQuestion question =
                questionQueryPort
                        .findById(option.getQuestionId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy câu hỏi"));

        validateQuestionType(question);
        validateSingleCorrectOption(question, option, command.correct());

        option = ExamQuestionOption.createNew(
                option.getQuestionId(),
                command.content() != null ? command.content() : option.getContent(),
                command.correct() != null ? command.correct() : option.isCorrect(),
                command.orderIndex() != null ? command.orderIndex() : option.getOrderIndex());

        return optionCommandPort.save(option);
    }

    private void validateQuestionType(ExamQuestion question) {
        if (question.getQuestionType() == ExamQuestionType.SHORT_ANSWER) {
            throw new InvalidQuestionTypeException("SHORT_ANSWER không sử dụng option");
        }
    }

    private void validateSingleCorrectOption(
            ExamQuestion question, ExamQuestionOption option, Boolean newCorrect) {
        if (question.getQuestionType() != ExamQuestionType.MULTIPLE_CHOICE
                || !Boolean.TRUE.equals(newCorrect)) {
            return;
        }
        boolean anotherCorrectOption =
                question.getOptions().stream()
                        .anyMatch(existing ->
                                existing.isCorrect() && !existing.getId().equals(option.getId()));
        if (anotherCorrectOption) {
            throw new InvalidQuestionTypeException("MULTIPLE_CHOICE chỉ được phép có 1 option đúng");
        }
    }
}
