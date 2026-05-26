package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.UpdateLessonVideoUrlUseCase;
import com.vku.edtech.modules.lms.application.port.out.LessonCommandPort;
import com.vku.edtech.modules.lms.application.port.out.LessonQueryPort;
import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import com.vku.edtech.modules.lms.domain.model.Lesson;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.net.URI;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateLessonVideoUrlService implements UpdateLessonVideoUrlUseCase {

    private final LessonCommandPort lessonCommandPort;
    private final LessonQueryPort lessonQueryPort;

    @Override
    @Transactional
    @CacheEvict(value = {"courseDetail", "coursePage"}, allEntries = true)
    public Lesson updateVideoUrl(UpdateLessonVideoUrlCommand command) {
        Lesson lesson =
                lessonQueryPort
                        .findByIdAndNotDeleted(command.lessonId())
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy lesson"));

        String videoUrl = normalizeYoutubeUrl(command.videoUrl());
        lesson.updateVideoUrl(videoUrl);
        return lessonCommandPort.save(lesson);
    }

    private String normalizeYoutubeUrl(String videoUrl) {
        if (videoUrl == null || videoUrl.isBlank()) {
            throw new InvalidDomainDataException("YouTube URL không được để trống");
        }

        String trimmed = videoUrl.trim();
        try {
            URI uri = URI.create(trimmed);
            String host = uri.getHost();
            if (host == null) {
                throw new InvalidDomainDataException("YouTube URL không hợp lệ");
            }
            String normalizedHost = host.toLowerCase();
            boolean isYoutube =
                    normalizedHost.equals("youtube.com")
                            || normalizedHost.endsWith(".youtube.com")
                            || normalizedHost.equals("youtu.be");
            if (!isYoutube) {
                throw new InvalidDomainDataException("Chỉ hỗ trợ link YouTube");
            }
            return trimmed;
        } catch (IllegalArgumentException e) {
            throw new InvalidDomainDataException("YouTube URL không hợp lệ");
        }
    }
}
