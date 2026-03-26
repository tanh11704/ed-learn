package com.vku.edtech.modules.lms.presentation.dto.request;

public record UpdateCourseRequest(
        String title, String description, String subject, String thumbnailUrl) {}
