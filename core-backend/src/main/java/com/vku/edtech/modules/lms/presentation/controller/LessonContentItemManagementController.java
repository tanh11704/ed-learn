package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.service.LessonContentItemService;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateLessonContentItemRequest;
import com.vku.edtech.modules.lms.presentation.dto.request.UpdateLessonContentItemRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.LessonContentItemResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/management")
@RequiredArgsConstructor
public class LessonContentItemManagementController {

    private final LessonContentItemService service;

    @GetMapping("/lessons/{lessonId}/content-items")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<List<LessonContentItemResponse>> getItems(
            @PathVariable UUID lessonId, @RequestParam(required = false) String type) {
        return ResponseEntity.ok(service.getAdminItems(lessonId, type));
    }

    @PostMapping("/lessons/{lessonId}/content-items")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<LessonContentItemResponse> create(
            @PathVariable UUID lessonId, @Valid @RequestBody CreateLessonContentItemRequest request) {
        return ResponseEntity.ok(service.create(lessonId, request));
    }

    @PutMapping("/lesson-content-items/{itemId}")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<LessonContentItemResponse> update(
            @PathVariable UUID itemId, @Valid @RequestBody UpdateLessonContentItemRequest request) {
        return ResponseEntity.ok(service.update(itemId, request));
    }

    @DeleteMapping("/lesson-content-items/{itemId}")
    @SecurityRequirement(name = "bearerAuth")
    public ResponseEntity<Void> delete(@PathVariable UUID itemId) {
        service.delete(itemId);
        return ResponseEntity.noContent().build();
    }
}
