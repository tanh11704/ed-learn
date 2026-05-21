package com.vku.edtech.modules.lms.infrastructure.security;

import com.vku.edtech.modules.lms.application.port.out.CourseVisibilityPort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class SpringSecurityCourseVisibilityAdapter implements CourseVisibilityPort {

    @Override
    public boolean canViewDeletedCourses() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null
                && authentication.getAuthorities().stream()
                        .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
    }
}
