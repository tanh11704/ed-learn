package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.GetDueErrorBankCardsUseCase;
import com.vku.edtech.modules.lms.application.port.in.ReviewErrorBankCardUseCase;
import com.vku.edtech.modules.lms.presentation.dto.request.ReviewErrorBankCardRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.ErrorBankCardResponse;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "Error Bank Learning", description = "API ôn tập lỗi sai với spaced repetition")
@RestController
@RequestMapping("/api/v1/learning/error-bank")
@RequiredArgsConstructor
public class ErrorBankLearningController {

    private final GetDueErrorBankCardsUseCase getDueErrorBankCardsUseCase;
    private final ReviewErrorBankCardUseCase reviewErrorBankCardUseCase;

    @Operation(
            summary = "Lấy danh sách thẻ lỗi sai đến hạn ôn",
            description = "Lấy các thẻ có nextReviewDate <= now() của user hiện tại.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @GetMapping("/due")
    public ResponseEntity<List<ErrorBankCardResponse>> getDueCards(Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();

        var cards =
                getDueErrorBankCardsUseCase.getDueCards(
                        new GetDueErrorBankCardsUseCase.GetDueErrorBankCardsQuery(
                                userInfo.getId()));

        var response =
                cards.stream()
                        .map(
                                c ->
                                        new ErrorBankCardResponse(
                                                c.getId(),
                                                c.getQuestionContent(),
                                                c.getWrongAnswer(),
                                                c.getCorrectAnswer(),
                                                c.getRepetitionCount(),
                                                c.getEaseFactor(),
                                                c.getIntervalDays(),
                                                c.getNextReviewDate()))
                        .toList();

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Báo cáo kết quả ôn thẻ lỗi sai",
            description =
                    "Nhận quality (0..5) và cập nhật lịch ôn theo thuật toán SM-2 cơ bản cho thẻ tương ứng.",
            security = @SecurityRequirement(name = "bearerAuth"))
    @PostMapping("/{id}/review")
    public ResponseEntity<Void> reviewCard(
            @PathVariable("id") UUID id,
            @Valid @RequestBody ReviewErrorBankCardRequest request,
            Principal principal) {
        JwtUserInfo userInfo =
                (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();

        reviewErrorBankCardUseCase.review(
                new ReviewErrorBankCardUseCase.ReviewErrorBankCardCommand(
                        userInfo.getId(), id, request.quality()));

        return ResponseEntity.ok().build();
    }
}
