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
public class Exam {
    private final UUID id;
    private String title;
    private String subject;
    private Integer schoolYear;
    private Integer durationMinutes;
    private Integer totalQuestions;
    private String description;
    private String status;
    @Builder.Default private List<ExamQuestion> questions = new ArrayList<>();
    private final Instant createdAt;
    private Instant updatedAt;

    public static Exam createNew(
            String title,
            String subject,
            Integer schoolYear,
            Integer durationMinutes,
            Integer totalQuestions,
            String description) {
        if (title == null || title.isBlank()) {
            throw new InvalidDomainDataException("Tiêu đề đề thi không được để trống");
        }
        if (subject == null || subject.isBlank()) {
            throw new InvalidDomainDataException("Môn học không được để trống");
        }
        if (schoolYear == null || schoolYear < 2000) {
            throw new InvalidDomainDataException("Năm học không hợp lệ");
        }
        if (durationMinutes == null || durationMinutes <= 0) {
            throw new InvalidDomainDataException("Thời gian làm bài phải lớn hơn 0");
        }
        if (totalQuestions == null || totalQuestions < 0) {
            throw new InvalidDomainDataException("Số câu hỏi không hợp lệ");
        }

        return Exam.builder()
                .id(UUID.randomUUID())
                .title(title.trim())
                .subject(subject.trim())
                .schoolYear(schoolYear)
                .durationMinutes(durationMinutes)
                .totalQuestions(totalQuestions)
                .description(description)
                .status("DRAFT")
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
    }

    public void updateDetails(
            String title,
            String subject,
            Integer schoolYear,
            Integer durationMinutes,
            Integer totalQuestions,
            String description) {
        if (title != null && !title.isBlank()) this.title = title.trim();
        if (subject != null && !subject.isBlank()) this.subject = subject.trim();
        if (schoolYear != null) this.schoolYear = schoolYear;
        if (durationMinutes != null && durationMinutes > 0) this.durationMinutes = durationMinutes;
        if (totalQuestions != null && totalQuestions >= 0) this.totalQuestions = totalQuestions;
        this.description = description;
        this.updatedAt = Instant.now();
    }

    public void setStatus(String status) {
        this.status = status;
        this.updatedAt = Instant.now();
    }

    public void addQuestion(ExamQuestion question) {
        if (questions == null) questions = new ArrayList<>();
        questions.add(question);
    }

    public List<ExamQuestion> getQuestions() {
        return questions == null ? Collections.emptyList() : Collections.unmodifiableList(questions);
    }
}
