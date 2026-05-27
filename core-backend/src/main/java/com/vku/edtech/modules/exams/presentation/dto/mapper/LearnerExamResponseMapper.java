package com.vku.edtech.modules.exams.presentation.dto.mapper;

import com.vku.edtech.modules.exams.domain.model.Exam;
import com.vku.edtech.modules.exams.domain.model.ExamAttempt;
import com.vku.edtech.modules.exams.domain.model.ExamAttemptAnswer;
import com.vku.edtech.modules.exams.domain.model.ExamQuestion;
import com.vku.edtech.modules.exams.domain.model.ExamQuestionOption;
import com.vku.edtech.modules.exams.presentation.dto.response.ExamAttemptResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamAttemptResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamAttemptReviewResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamQuestionOptionResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamQuestionOptionReviewResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamQuestionResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamQuestionReviewResponse;
import com.vku.edtech.modules.exams.presentation.dto.response.LearnerExamSummaryResponse;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class LearnerExamResponseMapper {

    private final ExamAttemptResponseMapper attemptResponseMapper;

    public LearnerExamSummaryResponse toSummary(Exam exam) {
        return new LearnerExamSummaryResponse(
                exam.getId(),
                exam.getTitle(),
                exam.getSubject(),
                exam.getSchoolYear(),
                exam.getDurationMinutes(),
                exam.getTotalQuestions(),
                exam.getDescription(),
                exam.getStatus());
    }

    public LearnerExamAttemptResponse toAttemptResponse(ExamAttempt attempt, Exam exam) {
        return new LearnerExamAttemptResponse(
                attemptResponseMapper.toResponse(attempt),
                toSummary(exam),
                toLearnerQuestions(exam.getQuestions()));
    }

    public LearnerExamAttemptReviewResponse toReviewResponse(
            ExamAttempt attempt, Exam exam, List<ExamAttemptAnswer> answers) {
        Map<UUID, ExamAttemptAnswer> answerByQuestion =
                answers.stream()
                        .collect(Collectors.toMap(ExamAttemptAnswer::getQuestionId, Function.identity()));
        return new LearnerExamAttemptReviewResponse(
                attemptResponseMapper.toResponse(attempt),
                toSummary(exam),
                sortedQuestions(exam.getQuestions()).stream()
                        .map(question -> toReviewQuestion(question, answerByQuestion.get(question.getId())))
                        .toList());
    }

    private List<LearnerExamQuestionResponse> toLearnerQuestions(List<ExamQuestion> questions) {
        return sortedQuestions(questions).stream().map(this::toLearnerQuestion).toList();
    }

    private LearnerExamQuestionResponse toLearnerQuestion(ExamQuestion question) {
        return new LearnerExamQuestionResponse(
                question.getId(),
                question.getExamId(),
                question.getQuestionType().name(),
                question.getPaperPart().name(),
                question.getContent(),
                question.getImageUrl(),
                question.getOrderIndex(),
                question.getScore(),
                sortedOptions(question.getOptions()).stream().map(this::toLearnerOption).toList());
    }

    private LearnerExamQuestionOptionResponse toLearnerOption(ExamQuestionOption option) {
        return new LearnerExamQuestionOptionResponse(
                option.getId(), option.getQuestionId(), option.getContent(), option.getOrderIndex());
    }

    private LearnerExamQuestionReviewResponse toReviewQuestion(
            ExamQuestion question, ExamAttemptAnswer answer) {
        return new LearnerExamQuestionReviewResponse(
                question.getId(),
                question.getExamId(),
                question.getQuestionType().name(),
                question.getPaperPart().name(),
                question.getContent(),
                question.getImageUrl(),
                question.getOrderIndex(),
                question.getScore(),
                question.getCorrectAnswer(),
                answer == null ? null : answer.getSelectedOptionId(),
                answer == null ? null : answer.getAnswerText(),
                answer == null ? null : answer.getCorrect(),
                answer == null ? null : answer.getScore(),
                sortedOptions(question.getOptions()).stream().map(this::toReviewOption).toList());
    }

    private LearnerExamQuestionOptionReviewResponse toReviewOption(ExamQuestionOption option) {
        return new LearnerExamQuestionOptionReviewResponse(
                option.getId(),
                option.getQuestionId(),
                option.getContent(),
                option.isCorrect(),
                option.getOrderIndex());
    }

    private List<ExamQuestion> sortedQuestions(List<ExamQuestion> questions) {
        return questions.stream()
                .sorted(Comparator.comparing(ExamQuestion::getOrderIndex, Comparator.nullsLast(Integer::compareTo)))
                .toList();
    }

    private List<ExamQuestionOption> sortedOptions(List<ExamQuestionOption> options) {
        return options.stream()
                .sorted(Comparator.comparing(ExamQuestionOption::getOrderIndex, Comparator.nullsLast(Integer::compareTo)))
                .toList();
    }
}
