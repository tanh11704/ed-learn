package com.vku.edtech.modules.exams.application.port.in;

import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.util.List;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface CreateQuestionUseCase {
    ExamQuestion create(CreateQuestionCommand command);

    record CreateQuestionCommand(
            UUID examId,
            ExamQuestionType questionType,
            ExamQuestionPaperPart paperPart,
            String content,
            String imageUrl,
            MultipartFile imageFile,
            Integer orderIndex,
            Double score,
            String correctAnswer,
            List<CreateOptionCommand> options) {}

    record CreateOptionCommand(String content, Boolean correct, Integer orderIndex) {}
}
