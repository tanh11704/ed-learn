package com.vku.edtech.modules.lms.infrastructure.cache;

import com.vku.edtech.modules.lms.application.port.out.CourseCachePort;
import com.vku.edtech.modules.lms.domain.model.Course;
import com.vku.edtech.shared.presentation.dto.CustomPage;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class RedisCourseAdapter implements CourseCachePort {

    private final RedisTemplate<String, Object> redisTemplate;
    private static final String META_PREFIX = "course:detail:";
    private static final String PAGE_PREFIX = "course:page:";
    private static final long TIME_TO_LIVE_FOR_METADATA = 24; // Hours
    private static final long TIME_TO_LIVE_FOR_PAGE = 5; // Minutes

    @Override
    public Course getCourse(UUID id) {
        String key = META_PREFIX + id;
        return (Course) redisTemplate.opsForValue().get(key);
    }

    @Override
    public void saveCourse(Course course) {
        String key = META_PREFIX + course.getId();
        redisTemplate.opsForValue().set(key, course, TIME_TO_LIVE_FOR_METADATA, TimeUnit.HOURS);
    }

    @Override
    public void deleteCourse(UUID id) {
        String key = META_PREFIX + id;
        redisTemplate.delete(key);
    }

    @Override
    public Optional<CustomPage<Course>> getPage(String subject, int page, int size) {
        String key = buildPageKey(subject, page, size);
        Object cached = redisTemplate.opsForValue().get(key);

        if (cached instanceof CustomPage<?> customPage) {
            @SuppressWarnings("unchecked")
            CustomPage<Course> result = (CustomPage<Course>) customPage;
            return Optional.of(result);
        }

        return Optional.empty();
    }

    @Override
    public void savePage(String subject, int page, int size, CustomPage<Course> data) {
        String key = buildPageKey(subject, page, size);
        redisTemplate.opsForValue().set(key, data, TIME_TO_LIVE_FOR_PAGE, TimeUnit.MINUTES);
    }

    private String buildPageKey(String subject, int page, int size) {
        return String.format(
                "%s%s:%d:%d", PAGE_PREFIX, subject != null ? subject : "all", page, size);
    }
}
