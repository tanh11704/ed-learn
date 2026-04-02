package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.CreateChapterUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CreateChapterService implements CreateChapterUseCase {

    private final ChapterCommandPort chapterCommandPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    public Chapter execute(CreateChapterCommand command) {
        int finalOrderIdx = command.orderIdx();

        if (finalOrderIdx <= 0) {
            finalOrderIdx = chapterQueryPort.findMaxOrderIdxByCourseId(command.courseId()) + 1;
        }

        Chapter chapter = Chapter.createNew(command.courseId(), command.title(), finalOrderIdx);

        return chapterCommandPort.save(chapter);
    }
}
