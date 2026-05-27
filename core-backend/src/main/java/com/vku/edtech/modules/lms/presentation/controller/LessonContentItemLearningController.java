package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.service.LessonContentItemService;
import com.vku.edtech.modules.lms.presentation.dto.request.ReviewLessonContentItemRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonContentItemResponse;
import com.vku.edtech.shared.infrastructure.security.JwtUserInfo;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import java.security.Principal;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/learning")
@RequiredArgsConstructor
public class LessonContentItemLearningController {

    private final LessonContentItemService service;

    @GetMapping("/lessons/{lessonId}/content-items")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<List<LessonContentItemResponse>> getItems(
            @PathVariable UUID lessonId,
            @RequestParam(required = false) String type,
            @RequestParam(defaultValue = "false") boolean dueOnly,
            Principal principal) {
        return ResponseEntity.ok(service.getLearningItems(lessonId, type, currentUserIdOrNull(principal), dueOnly));
    }

    @PostMapping("/lesson-content-items/{itemId}/review")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<LessonContentItemResponse> review(
            @PathVariable UUID itemId,
            @Valid @RequestBody ReviewLessonContentItemRequest request,
            Principal principal) {
        return ResponseEntity.ok(service.review(itemId, currentUser(principal).getId(), request.quality()));
    }

    private JwtUserInfo currentUser(Principal principal) {
        return (JwtUserInfo) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
    }

    private UUID currentUserIdOrNull(Principal principal) {
        if (!(principal instanceof UsernamePasswordAuthenticationToken token)
                || !(token.getPrincipal() instanceof JwtUserInfo userInfo)) {
            return null;
        }
        return userInfo.getId();
    }
}
