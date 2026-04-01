package com.vku.edtech.modules.lms.presentation.controller;

import com.vku.edtech.modules.lms.application.port.in.CreateChapterUseCase;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.modules.lms.presentation.dto.mapper.ChapterResponseMapper;
import com.vku.edtech.modules.lms.presentation.dto.request.CreateChapterRequest;
import com.vku.edtech.modules.lms.presentation.dto.response.ChapterResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Chương học", description = "API quản lý chương trong khóa học")
@RestController
@RequestMapping("/api/v1/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final CreateChapterUseCase createChapterUseCase;
    //    private final UpdateChapterUseCase updateChapterUseCase;
    //    private final DeleteChapterUseCase deleteChapterUseCase;
    //    private final GetChaptersUseCase getChaptersUseCase;
    private final ChapterResponseMapper chapterMapper;

    @PostMapping
    public ResponseEntity<ChapterResponse> create(@RequestBody CreateChapterRequest request) {
        CreateChapterUseCase.CreateChapterCommand command =
                new CreateChapterUseCase.CreateChapterCommand(
                        request.courseId(), request.title(), request.orderIndex());

        Chapter chapter = createChapterUseCase.execute(command);

        return ResponseEntity.ok(chapterMapper.toResponse(chapter));
    }
    //
    //    @PutMapping
    //    public ResponseEntity<ChapterResponse> update(@RequestBody )
}
