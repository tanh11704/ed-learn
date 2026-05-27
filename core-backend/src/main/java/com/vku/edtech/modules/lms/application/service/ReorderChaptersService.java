package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.exception.LmsBadRequestException;
import com.vku.edtech.modules.lms.application.port.in.ReorderChaptersUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterCommandPort;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ReorderChaptersService implements ReorderChaptersUseCase {

    private final ChapterCommandPort chapterCommandPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional
    @CacheEvict(value = {"courseDetail", "coursePage"}, allEntries = true)
    public void reorder(ReorderChaptersCommand command) {
        chapterQueryPort.lockCourseForOrdering(command.courseId());
        List<UUID> existingChapterIds =
                chapterCommandPort.findActiveChapterIdsByCourseId(command.courseId());
        validateFullReorder(existingChapterIds, command.chapterIds(), "Danh sách chapter không hợp lệ");

        for (int index = 0; index < command.chapterIds().size(); index++) {
            chapterCommandPort.updateOrderIndex(command.chapterIds().get(index), -(index + 1));
        }
        chapterCommandPort.flush();

        for (int index = 0; index < command.chapterIds().size(); index++) {
            chapterCommandPort.updateOrderIndex(command.chapterIds().get(index), index + 1);
        }
    }

    private void validateFullReorder(List<UUID> existingIds, List<UUID> requestedIds, String message) {
        if (requestedIds == null
                || requestedIds.size() != existingIds.size()
                || new HashSet<>(requestedIds).size() != requestedIds.size()
                || !new HashSet<>(requestedIds).equals(new HashSet<>(existingIds))) {
            throw new LmsBadRequestException(message);
        }
    }
}
