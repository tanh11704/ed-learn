package com.vku.edtech.modules.lms.application.service;

import com.vku.edtech.modules.lms.application.port.in.UpdateCourseUseCase;
import com.vku.edtech.modules.lms.application.port.out.CourseCommandPort;
import com.vku.edtech.modules.lms.application.port.out.CourseQueryPort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.ResourceNotFoundException;
import java.net.URI;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

@Service
@RequiredArgsConstructor
@Slf4j
public class UpdateCourseService implements UpdateCourseUseCase {

    private final CourseQueryPort courseQueryPort;
    private final CourseCommandPort courseCommandPort;
    private final FileStoragePort fileStoragePort;

    //    private final CourseCachePort courseCachePort;

    @Override
    @Transactional
    @Caching(
            evict = {
                @CacheEvict(value = "courseDetail", key = "#command.courseId()"),
                @CacheEvict(value = "coursePage", allEntries = true)
            })
    public Course updateCourse(UpdateCourseCommand command) {
        Course course =
                courseQueryPort
                        .findByIdWithChapters(command.courseId())
                        .orElseThrow(
                                () -> new ResourceNotFoundException("Không tìm thấy khóa học"));

        String oldThumbnailUrl = course.getThumbnailUrl();
        boolean replacingUploadedThumbnail = false;
        String thumbnailUrl = command.thumbnailUrl();
        if (command.thumbnailFile() != null && !command.thumbnailFile().isEmpty()) {
            thumbnailUrl = fileStoragePort.uploadFile(command.thumbnailFile(), "courses");
            replacingUploadedThumbnail = true;
        }

        course.updateDetails(command.title(), command.description(), command.subject(), thumbnailUrl);

        Course updated = courseCommandPort.save(course);
        if (replacingUploadedThumbnail && shouldDeleteOldThumbnail(oldThumbnailUrl, thumbnailUrl)) {
            deleteOldThumbnailAfterCommit(oldThumbnailUrl);
        }
        //        courseCachePort.deleteCourse(updated.getId());
        return updated;
    }

    private boolean shouldDeleteOldThumbnail(String oldThumbnailUrl, String newThumbnailUrl) {
        return oldThumbnailUrl != null
                && !oldThumbnailUrl.isBlank()
                && !oldThumbnailUrl.equals(newThumbnailUrl)
                && isManagedCourseThumbnail(oldThumbnailUrl);
    }

    private boolean isManagedCourseThumbnail(String thumbnailUrl) {
        String path = thumbnailUrl.trim();
        boolean absoluteUrl = false;
        try {
            URI uri = URI.create(path);
            if (uri.getScheme() != null && uri.getHost() != null) {
                absoluteUrl = true;
                path = uri.getPath();
            }
        } catch (IllegalArgumentException ignored) {
            return false;
        }

        path = path.replaceAll("^/+", "");
        return path.startsWith("courses/") || (absoluteUrl && path.contains("/courses/"));
    }

    private void deleteOldThumbnailAfterCommit(String oldThumbnailUrl) {
        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            deleteOldThumbnailBestEffort(oldThumbnailUrl);
            return;
        }

        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        deleteOldThumbnailBestEffort(oldThumbnailUrl);
                    }
                });
    }

    private void deleteOldThumbnailBestEffort(String oldThumbnailUrl) {
        try {
            fileStoragePort.deleteFile(oldThumbnailUrl);
        } catch (RuntimeException e) {
            log.warn("Không thể xóa thumbnail cũ của khóa học: {}", oldThumbnailUrl, e);
        }
    }
}
