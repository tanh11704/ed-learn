package com.vku.edtech.modules.exams.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.time.Instant;
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
public class ExamQuestionOption {
    private final UUID id;
    private UUID questionId;
    private String content;
    private boolean correct;
    private Integer orderIndex;
    private final Instant createdAt;
    private Instant updatedAt;

    public static ExamQuestionOption createNew(
            UUID questionId, String content, boolean correct, Integer orderIndex) {
        if (questionId == null) {
            throw new InvalidDomainDataException("Question ID không hợp lệ");
        }
        if (content == null || content.isBlank()) {
            throw new InvalidDomainDataException("Nội dung lựa chọn không được để trống");
        }
        return ExamQuestionOption.builder()
                .id(UUID.randomUUID())
                .questionId(questionId)
                .content(content.trim())
                .correct(correct)
                .orderIndex(orderIndex)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }
}
