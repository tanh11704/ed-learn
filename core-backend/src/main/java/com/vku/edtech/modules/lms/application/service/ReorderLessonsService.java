package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.exception.LmsBadRequestException;
import com.vku.edtech.modules.lms.application.port.in.ReorderLessonsUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ReorderLessonsService implements ReorderLessonsUseCase {

    private final LessonCommandPort lessonCommandPort;
    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional
    @CacheEvict(value = {"courseDetail", "coursePage"}, allEntries = true)
    public void reorder(ReorderLessonsCommand command) {
        Chapter chapter =
                chapterQueryPort
                        .findById(command.chapterId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy chapter"));
        if (Boolean.TRUE.equals(chapter.getIsDeleted())) {
            throw new ResourceNotFoundException("Chapter đã bị xóa");
        }

        chapterQueryPort.lockCourseForOrdering(chapter.getCourseId());
        List<UUID> existingLessonIds =
                lessonCommandPort.findActiveLessonIdsByChapterId(command.chapterId());
        validateFullReorder(existingLessonIds, command.lessonIds(), "Danh sách lesson không hợp lệ");

        for (int index = 0; index < command.lessonIds().size(); index++) {
            lessonCommandPort.updateOrderIndex(command.lessonIds().get(index), -(index + 1));
        }
        lessonCommandPort.flush();

        for (int index = 0; index < command.lessonIds().size(); index++) {
            lessonCommandPort.updateOrderIndex(command.lessonIds().get(index), index + 1);
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
