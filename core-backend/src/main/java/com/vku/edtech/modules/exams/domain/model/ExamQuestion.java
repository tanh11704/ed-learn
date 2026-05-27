package com.vku.edtech.modules.exams.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED, force = true)
@AllArgsConstructor
public class ExamQuestion {
    private final UUID id;
    private UUID examId;
    private ExamQuestionType questionType;
    private ExamQuestionPaperPart paperPart;
    private String content;
    private String imageUrl;
    private Integer orderIndex;
    private Double score;
    private String correctAnswer;
    @Builder.Default private List<ExamQuestionOption> options = new ArrayList<>();
    private final Instant createdAt;
    private Instant updatedAt;

    public static ExamQuestion createNew(
            UUID examId,
            ExamQuestionType questionType,
            ExamQuestionPaperPart paperPart,
            String content,
            String imageUrl,
            Integer orderIndex,
            Double score,
            String correctAnswer) {
        if (examId == null) throw new InvalidDomainDataException("Exam ID không hợp lệ");
        if (questionType == null) throw new InvalidDomainDataException("Loại câu hỏi không hợp lệ");
        if (paperPart == null) throw new InvalidDomainDataException("Phần đề thi không hợp lệ");
        if (content == null || content.isBlank()) {
            throw new InvalidDomainDataException("Nội dung câu hỏi không được để trống");
        }
        if (score == null || score <= 0) {
            throw new InvalidDomainDataException("Điểm câu hỏi phải lớn hơn 0");
        }
        return ExamQuestion.builder()
                .id(UUID.randomUUID())
                .examId(examId)
                .questionType(questionType)
                .paperPart(paperPart)
                .content(content.trim())
                .imageUrl(normalizeImageUrl(imageUrl))
                .orderIndex(orderIndex)
                .score(score)
                .correctAnswer(correctAnswer)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public static ExamQuestion createTrueFalse(
            UUID examId,
            ExamQuestionPaperPart paperPart,
            String content,
            String imageUrl,
            Integer orderIndex,
            Double score,
            List<ExamQuestionOption> options) {
        ExamQuestion question =
                createNew(examId, ExamQuestionType.TRUE_FALSE, paperPart, content, imageUrl, orderIndex, score, null);
        if (options == null || options.size() != 4) {
            throw new InvalidDomainDataException("Đúng/sai phải có đúng 4 option");
        }
        question.options = new ArrayList<>(options);
        return question;
    }

    public static ExamQuestion createMultipleChoice(
            UUID examId,
            ExamQuestionPaperPart paperPart,
            String content,
            String imageUrl,
            Integer orderIndex,
            Double score,
            List<ExamQuestionOption> options) {
        ExamQuestion question =
                createNew(examId, ExamQuestionType.MULTIPLE_CHOICE, paperPart, content, imageUrl, orderIndex, score, null);
        if (options == null || options.size() < 2) {
            throw new InvalidDomainDataException("Trắc nghiệm phải có ít nhất 2 option");
        }
        question.options = new ArrayList<>(options);
        return question;
    }

    public static ExamQuestion createShortAnswer(
            UUID examId,
            ExamQuestionPaperPart paperPart,
            String content,
            String imageUrl,
            Integer orderIndex,
            Double score,
            String correctAnswer) {
        if (correctAnswer == null || correctAnswer.isBlank()) {
            throw new InvalidDomainDataException("Câu trả lời chuẩn không được để trống");
        }
        return createNew(
                examId, ExamQuestionType.SHORT_ANSWER, paperPart, content, imageUrl, orderIndex, score, correctAnswer);
    }

    public void updateDetails(String content, String imageUrl, Integer orderIndex, Double score, String correctAnswer) {
        if (content != null && !content.isBlank()) this.content = content.trim();
        this.imageUrl = normalizeImageUrl(imageUrl);
        if (orderIndex != null) this.orderIndex = orderIndex;
        if (score != null && score > 0) this.score = score;
        this.correctAnswer = correctAnswer;
        this.updatedAt = Instant.now();
    }

    public void addOption(ExamQuestionOption option) {
        if (this.options == null) this.options = new ArrayList<>();
        this.options.add(option);
        this.updatedAt = Instant.now();
    }

    public List<ExamQuestionOption> getOptions() {
        return options == null ? Collections.emptyList() : Collections.unmodifiableList(options);
    }

    private static String normalizeImageUrl(String imageUrl) {
        if (imageUrl == null || imageUrl.isBlank()) {
            return null;
        }
        return imageUrl.trim();
    }
}
