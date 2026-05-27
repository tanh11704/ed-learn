package com.vku.edtech.modules.exams.application.service;

import com.vku.edtech.modules.exams.application.exception.ExamBadRequestException;
import com.vku.edtech.modules.exams.application.exception.ExamNotFoundException;
import com.vku.edtech.modules.exams.application.port.in.UpdateQuestionUseCase;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateQuestionService implements UpdateQuestionUseCase {

    private final ExamQuestionQueryPort questionQueryPort;
    private final ExamQuestionCommandPort questionCommandPort;
    private final FileStoragePort fileStoragePort;

    @Override
    @Transactional
    public ExamQuestion update(UpdateQuestionCommand command) {
        ExamQuestion question =
                questionQueryPort
                        .findById(command.questionId())
                        .orElseThrow(() -> new ExamNotFoundException("Không tìm thấy câu hỏi"));

        String imageUrl = resolveImageUrl(command);
        String correctAnswer = resolveCorrectAnswer(question, command);
        question.updateDetails(
                command.content(),
                imageUrl,
                command.orderIndex(),
                command.score(),
                correctAnswer);
        return questionCommandPort.save(question);
    }

    private String resolveCorrectAnswer(ExamQuestion question, UpdateQuestionCommand command) {
        if (question.getQuestionType() != ExamQuestionType.SHORT_ANSWER) {
            return null;
        }
        if (command.correctAnswer() == null) {
            return question.getCorrectAnswer();
        }
        if (command.correctAnswer().isBlank()) {
            throw new ExamBadRequestException("Câu trả lời chuẩn không được để trống");
        }
        return command.correctAnswer().trim();
    }

    private String resolveImageUrl(UpdateQuestionCommand command) {
        if (command.imageFile() == null || command.imageFile().isEmpty()) {
            return command.imageUrl();
        }
        String contentType = command.imageFile().getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            throw new ExamBadRequestException("File minh họa câu hỏi phải là hình ảnh");
        }
        return fileStoragePort.uploadFile(command.imageFile(), "exam-questions");
    }
}
