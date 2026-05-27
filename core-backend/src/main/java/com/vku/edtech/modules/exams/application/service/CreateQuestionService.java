package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.CreateQuestionUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQueryPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionScoringRule;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import com.vku.edtech.modules.exams.domain.model.ExamStructure;
import com.vku.edtech.modules.exams.domain.model.Thpt2026ExamProfile;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import java.math.BigDecimal;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CreateQuestionService implements CreateQuestionUseCase {

    private final ExamQueryPort examQueryPort;
    private final ExamQuestionCommandPort questionCommandPort;
    private final ExamQuestionQueryPort questionQueryPort;
    private final ExamOptionCommandPort optionCommandPort;
    private final FileStoragePort fileStoragePort;

    @Override
    @Transactional
    public ExamQuestion create(CreateQuestionCommand command) {
        Exam exam =
                examQueryPort
                        .findById(command.examId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy đề thi"));
        validateThpt2026Question(exam, command);

        ExamQuestion question = buildQuestion(command);
        ExamQuestion savedQuestion = questionCommandPort.save(question);
        List<ExamQuestionOption> savedOptions = saveOptions(savedQuestion, command.options());

        ExamQuestion persistedQuestion =
                questionQueryPort
                .findById(savedQuestion.getId())
                .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy câu hỏi vừa tạo"));
        if (persistedQuestion.getOptions().isEmpty() && !savedOptions.isEmpty()) {
            savedOptions.forEach(persistedQuestion::addOption);
        }
        return persistedQuestion;
    }

    private ExamQuestion buildQuestion(CreateQuestionCommand command) {
        String imageUrl = resolveImageUrl(command);

        if (command.questionType() == ExamQuestionType.SHORT_ANSWER) {
            ensureNoOptions(command.options());
            return ExamQuestion.createShortAnswer(
                    command.examId(),
                    command.paperPart(),
                    command.content(),
                    imageUrl,
                    command.orderIndex(),
                    command.score(),
                    command.correctAnswer());
        }

        if (command.questionType() == ExamQuestionType.TRUE_FALSE) {
            validateOptionCount(command.options(), 4, 4, "TRUE_FALSE phải có đúng 4 option");
        } else if (command.questionType() == ExamQuestionType.MULTIPLE_CHOICE) {
            validateOptionCount(command.options(), 4, 4, "MULTIPLE_CHOICE phải có đúng 4 option");
            validateSingleCorrectOption(command.options());
        }

        return ExamQuestion.createNew(
                command.examId(),
                command.questionType(),
                command.paperPart(),
                command.content(),
                imageUrl,
                command.orderIndex(),
                command.score(),
                null);
    }

    private String resolveImageUrl(CreateQuestionCommand command) {
        if (command.imageFile() == null || command.imageFile().isEmpty()) {
            return command.imageUrl();
        }
        String contentType = command.imageFile().getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            throw new ExamBadRequestException("File minh họa câu hỏi phải là hình ảnh");
        }
        return fileStoragePort.uploadFile(command.imageFile(), "exam-questions");
    }

    private List<ExamQuestionOption> saveOptions(ExamQuestion question, List<CreateOptionCommand> options) {
        if (options == null || options.isEmpty()) {
            return List.of();
        }

        java.util.ArrayList<ExamQuestionOption> savedOptions = new java.util.ArrayList<>();
        for (CreateOptionCommand option : options) {
            savedOptions.add(
                    optionCommandPort.save(
                            ExamQuestionOption.createNew(
                                    question.getId(),
                                    option.content(),
                                    Boolean.TRUE.equals(option.correct()),
                                    option.orderIndex())));
        }
        return savedOptions;
    }

    private void ensureNoOptions(List<CreateOptionCommand> options) {
        if (options != null && !options.isEmpty()) {
            throw new ExamBadRequestException("SHORT_ANSWER không sử dụng option");
        }
    }

    private void validateOptionCount(
            List<CreateOptionCommand> options, int min, int max, String message) {
        int count = options == null ? 0 : options.size();
        if (count < min || count > max) {
            throw new ExamBadRequestException(message);
        }
    }

    private void validateSingleCorrectOption(List<CreateOptionCommand> options) {
        long correctCount =
                options.stream().filter(option -> Boolean.TRUE.equals(option.correct())).count();
        if (correctCount != 1) {
            throw new ExamBadRequestException("MULTIPLE_CHOICE phải có đúng 1 option đúng");
        }
    }

    private void validateThpt2026Question(Exam exam, CreateQuestionCommand command) {
        if (!Thpt2026ExamProfile.supports(exam.getSubject())) {
            return;
        }

        ExamStructure structure = ExamStructure.thpt2026(exam.getSubject());
        ExamQuestionScoringRule rule =
                structure
                        .findRule(command.questionType(), command.paperPart())
                        .orElseThrow(() ->
                                new ExamBadRequestException(
                                        "Loại câu hỏi không khớp phần đề thi THPT 2026"));

        if (BigDecimal.valueOf(command.score()).compareTo(rule.scorePerQuestion()) != 0) {
            throw new ExamBadRequestException("Điểm câu hỏi không khớp thang điểm THPT 2026");
        }

        long currentCount =
                exam.getQuestions().stream()
                        .filter(question -> question.getPaperPart() == command.paperPart())
                        .count();
        int expectedCount = structure.expectedCount(command.paperPart());
        if (currentCount >= expectedCount) {
            throw new ExamBadRequestException("Số câu trong phần đã vượt cấu trúc THPT 2026");
        }
    }
}
