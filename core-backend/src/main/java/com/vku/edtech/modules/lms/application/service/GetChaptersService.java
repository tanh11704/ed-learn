package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.GetChaptersUseCase;
import com.vku.edtech.modules.lms.application.port.out.ChapterQueryPort;
import com.vku.edtech.modules.lms.domain.model.Chapter;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetChaptersService implements GetChaptersUseCase {

    private final ChapterQueryPort chapterQueryPort;

    @Override
    @Transactional(readOnly = true)
    public List<Chapter> getChaptersByCourseId(UUID courseId, String status) {
        return chapterQueryPort.findAllByCourseIdWithLessons(courseId, normalizeStatus(status));
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "ACTIVE";
        }
        String normalized = status.trim().toUpperCase();
        return switch (normalized) {
            case "ALL", "DELETED" -> normalized;
            default -> "ACTIVE";
        };
    }
}
