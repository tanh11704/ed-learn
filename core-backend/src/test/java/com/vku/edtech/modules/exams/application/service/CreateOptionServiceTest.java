package com.vku.edtech.modules.exams.application.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import com.vku.edtech.modules.exams.application.exception.InvalidQuestionTypeException;
import com.vku.edtech.modules.exams.application.port.out.ExamOptionCommandPort;
import com.vku.edtech.modules.exams.application.port.out.ExamQuestionQueryPort;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionPaperPart;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionType;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class CreateOptionServiceTest {

    private ExamQuestionQueryPort questionQueryPort;
    private ExamOptionCommandPort optionCommandPort;
    private CreateOptionService service;

    @BeforeEach
    void setUp() {
        questionQueryPort = mock(ExamQuestionQueryPort.class);
        optionCommandPort = mock(ExamOptionCommandPort.class);
        service = new CreateOptionService(questionQueryPort, optionCommandPort);
    }

    @Test
    void should_throw_when_short_answer_question_has_option() {
        UUID questionId = UUID.randomUUID();
        when(questionQueryPort.findById(questionId)).thenReturn(Optional.of(buildShortAnswerQuestion(questionId)));

        assertThrows(
                InvalidQuestionTypeException.class,
                () -> service.create(new com.vku.edtech.modules.exams.application.port.in.CreateOptionUseCase.CreateOptionCommand(questionId, "A", true, 1)));
    }

    private ExamQuestion buildShortAnswerQuestion(UUID questionId) {
        return ExamQuestion.builder()
                .id(questionId)
                .examId(UUID.randomUUID())
                .questionType(ExamQuestionType.SHORT_ANSWER)
                .paperPart(ExamQuestionPaperPart.PART_III)
                .content("Câu hỏi")
                .score(1.0)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .options(List.of())
                .build();
    }
}
