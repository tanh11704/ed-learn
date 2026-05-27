package com.vku.edtech.modules.lms.application.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.vku.edtech.modules.lms.application.port.out.EnrollmentQueryPort;
import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonContentItemJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonContentItemReviewJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.entity.LessonJpaEntity;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.LessonContentItemJpaRepository;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.LessonContentItemReviewJpaRepository;
import com.vku.edtech.modules.lms.infrastructure.persistence.repository.LessonJpaRepository;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateLessonContentItemRequest;
import com.vku.edtech.modules.lms.presentation.dto.request.UpdateLessonContentItemRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonContentItemResponse;
import com.vku.edtech.shared.presentation.exception.ForbiddenException;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LessonContentItemService {

    private final LessonJpaRepository lessonRepository;
    private final LessonContentItemJpaRepository itemRepository;
    private final LessonContentItemReviewJpaRepository reviewRepository;
    private final EnrollmentQueryPort enrollmentQueryPort;
    private final ObjectMapper objectMapper;

    @Transactional(readOnly = true)
    public List<LessonContentItemResponse> getAdminItems(UUID lessonId, String type) {
        ensureLessonExists(lessonId);
        return itemRepository.findActiveByLessonIdAndType(lessonId, normalizeType(type)).stream()
                .map(item -> toResponse(item, null))
                .toList();
    }

    @Transactional
    public LessonContentItemResponse create(UUID lessonId, CreateLessonContentItemRequest request) {
        LessonJpaEntity lesson = ensureLessonExists(lessonId);
        validatePayload(request.type(), request.prompt(), request.answer(), request.options(), request.correctOption());
        int orderIndex =
                request.orderIndex() == null
                        ? nextOrderIndex(lessonId)
                        : request.orderIndex();

        LessonContentItemJpaEntity item =
                LessonContentItemJpaEntity.builder()
                        .lesson(lesson)
                        .type(request.type())
                        .prompt(request.prompt().trim())
                        .answer(request.answer().trim())
                        .explanation(trimToNull(request.explanation()))
                        .optionsJson(toJson(request.options()))
                        .correctOption(trimToNull(request.correctOption()))
                        .orderIndex(orderIndex)
                        .isDeleted(false)
                        .build();
        return toResponse(itemRepository.save(item), null);
    }

    @Transactional
    public LessonContentItemResponse update(UUID itemId, UpdateLessonContentItemRequest request) {
        LessonContentItemJpaEntity item =
                itemRepository
                        .findByIdAndIsDeletedFalse(itemId)
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nội dung bài học"));

        String type = request.type() == null ? item.getType() : request.type();
        String prompt = request.prompt() == null ? item.getPrompt() : request.prompt();
        String answer = request.answer() == null ? item.getAnswer() : request.answer();
        List<String> options = request.options() == null ? fromJson(item.getOptionsJson()) : request.options();
        String correctOption =
                request.correctOption() == null ? item.getCorrectOption() : request.correctOption();
        validatePayload(type, prompt, answer, options, correctOption);

        String normalizedPrompt = prompt.trim();
        String normalizedAnswer = answer.trim();
        String normalizedCorrectOption = trimToNull(correctOption);
        boolean reviewContentChanged =
                !Objects.equals(type, item.getType())
                        || !Objects.equals(normalizedPrompt, item.getPrompt())
                        || !Objects.equals(normalizedAnswer, item.getAnswer())
                        || !Objects.equals(options, fromJson(item.getOptionsJson()))
                        || !Objects.equals(normalizedCorrectOption, item.getCorrectOption());

        item.setType(type);
        item.setPrompt(normalizedPrompt);
        item.setAnswer(normalizedAnswer);
        if (request.explanation() != null) item.setExplanation(trimToNull(request.explanation()));
        if (request.options() != null) item.setOptionsJson(toJson(request.options()));
        if (request.correctOption() != null) item.setCorrectOption(normalizedCorrectOption);
        if (request.orderIndex() != null) item.setOrderIndex(request.orderIndex());

        if (reviewContentChanged) {
            reviewRepository.deleteByItemId(itemId);
        }

        return toResponse(itemRepository.save(item), null);
    }

    @Transactional
    public void delete(UUID itemId) {
        LessonContentItemJpaEntity item =
                itemRepository
                        .findByIdAndIsDeletedFalse(itemId)
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nội dung bài học"));
        itemRepository.delete(item);
    }

    @Transactional(readOnly = true)
    public List<LessonContentItemResponse> getLearningItems(
            UUID lessonId, String type, UUID userId, boolean dueOnly) {
        ensureLearnerCanAccessLesson(lessonId, userId);
        List<LessonContentItemJpaEntity> items =
                itemRepository.findActiveByLessonIdAndType(lessonId, normalizeType(type));
        List<UUID> ids = items.stream().map(LessonContentItemJpaEntity::getId).toList();
        Map<UUID, LessonContentItemReviewJpaEntity> reviews =
                ids.isEmpty() || userId == null
                        ? Collections.emptyMap()
                        : reviewRepository.findByItemIdInAndUserId(ids, userId).stream()
                                .collect(Collectors.toMap(r -> r.getItem().getId(), r -> r));
        Instant now = Instant.now();
        return items.stream()
                .filter(
                        item -> {
                            if (!dueOnly) return true;
                            LessonContentItemReviewJpaEntity review = reviews.get(item.getId());
                            return review == null || !review.getNextReviewDate().isAfter(now);
                        })
                .map(item -> toLearnerListResponse(item, reviews.get(item.getId())))
                .toList();
    }

    @Transactional
    public LessonContentItemResponse review(UUID itemId, UUID userId, int quality) {
        if (quality < 0 || quality > 5) {
            throw new InvalidDomainDataException("quality phải nằm trong khoảng từ 0 đến 5");
        }
        LessonContentItemJpaEntity item =
                itemRepository
                        .findByIdAndIsDeletedFalse(itemId)
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nội dung bài học"));
        ensureLearnerCanAccessLesson(item.getLesson().getId(), userId);
        LessonContentItemReviewJpaEntity review =
                reviewRepository
                        .findByItemIdAndUserId(itemId, userId)
                        .orElseGet(
                                () ->
                                        LessonContentItemReviewJpaEntity.builder()
                                                .item(item)
                                                .userId(userId)
                                                .repetitionCount(0)
                                                .easeFactor(2.5)
                                                .intervalDays(1)
                                                .nextReviewDate(Instant.now())
                                                .build());
        applySm2(review, quality);
        return toResponse(item, reviewRepository.save(review));
    }

    private LessonJpaEntity ensureLessonExists(UUID lessonId) {
        return lessonRepository
                .findByIdAndNotDeleted(lessonId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy bài học"));
    }

    private void ensureLearnerCanAccessLesson(UUID lessonId, UUID userId) {
        LessonJpaEntity lesson = ensureLessonExists(lessonId);
        if (lesson.isPreview()) {
            return;
        }

        UUID courseId =
                lessonRepository
                        .findCourseIdByLessonId(lessonId)
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy course của lesson"));
        if (userId == null) {
            throw new ForbiddenException("Bạn cần đăng ký khóa học để truy cập bài học này");
        }
        if (!enrollmentQueryPort.existsByUserIdAndCourseId(userId, courseId)) {
            throw new ForbiddenException("Bạn cần đăng ký khóa học để truy cập bài học này");
        }
    }

    private int nextOrderIndex(UUID lessonId) {
        Integer maxOrder = itemRepository.findMaxOrderIndexByLessonId(lessonId);
        return maxOrder == null ? 1 : maxOrder + 1;
    }

    private void validatePayload(
            String type, String prompt, String answer, List<String> options, String correctOption) {
        if (!"FLASHCARD".equals(type) && !"EXERCISE".equals(type)) {
            throw new InvalidDomainDataException("Loại nội dung không hợp lệ");
        }
        if (prompt == null || prompt.isBlank() || answer == null || answer.isBlank()) {
            throw new InvalidDomainDataException("Nội dung và đáp án không được để trống");
        }
        if ("EXERCISE".equals(type) && (options == null || options.size() < 2 || correctOption == null || correctOption.isBlank())) {
            throw new InvalidDomainDataException("Bài tập cần tối thiểu 2 lựa chọn và đáp án đúng");
        }
    }

    private String normalizeType(String type) {
        return type == null || type.isBlank() ? null : type.toUpperCase();
    }

    private void applySm2(LessonContentItemReviewJpaEntity review, int quality) {
        int repetitionCount = review.getRepetitionCount();
        double easeFactor = review.getEaseFactor();
        int intervalDays = review.getIntervalDays();

        if (quality >= 3) {
            repetitionCount += 1;
            if (repetitionCount == 1) {
                intervalDays = 1;
            } else if (repetitionCount == 2) {
                intervalDays = 3;
            } else {
                intervalDays = Math.max(1, (int) Math.round(intervalDays * easeFactor));
            }
            easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
            if (easeFactor < 1.3) easeFactor = 1.3;
        } else {
            repetitionCount = 0;
            intervalDays = 1;
        }

        review.setRepetitionCount(repetitionCount);
        review.setEaseFactor(easeFactor);
        review.setIntervalDays(intervalDays);
        review.setNextReviewDate(Instant.now().plus(intervalDays, ChronoUnit.DAYS));
    }

    private LessonContentItemResponse toResponse(
            LessonContentItemJpaEntity item, LessonContentItemReviewJpaEntity review) {
        return new LessonContentItemResponse(
                item.getId(),
                item.getLesson().getId(),
                item.getType(),
                item.getPrompt(),
                item.getAnswer(),
                item.getExplanation(),
                fromJson(item.getOptionsJson()),
                item.getCorrectOption(),
                item.getOrderIndex(),
                review == null ? null : review.getRepetitionCount(),
                review == null ? null : review.getEaseFactor(),
                review == null ? null : review.getIntervalDays(),
                review == null ? null : review.getNextReviewDate());
    }

    private LessonContentItemResponse toLearnerListResponse(
            LessonContentItemJpaEntity item, LessonContentItemReviewJpaEntity review) {
        boolean hideExerciseAnswer = "EXERCISE".equals(item.getType());
        return new LessonContentItemResponse(
                item.getId(),
                item.getLesson().getId(),
                item.getType(),
                item.getPrompt(),
                hideExerciseAnswer ? null : item.getAnswer(),
                hideExerciseAnswer ? null : item.getExplanation(),
                fromJson(item.getOptionsJson()),
                hideExerciseAnswer ? null : item.getCorrectOption(),
                item.getOrderIndex(),
                review == null ? null : review.getRepetitionCount(),
                review == null ? null : review.getEaseFactor(),
                review == null ? null : review.getIntervalDays(),
                review == null ? null : review.getNextReviewDate());
    }

    private String toJson(List<String> options) {
        if (options == null) return null;
        try {
            return objectMapper.writeValueAsString(options);
        } catch (JsonProcessingException e) {
            throw new InvalidDomainDataException("Không thể lưu lựa chọn bài tập");
        }
    }

    private List<String> fromJson(String value) {
        if (value == null || value.isBlank()) return List.of();
        try {
            return objectMapper.readValue(value, new TypeReference<>() {});
        } catch (JsonProcessingException e) {
            return List.of();
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.isBlank()) return null;
        return value.trim();
    }
}
