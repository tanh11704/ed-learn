package com.vku.edtech.modules.lms.infrastructure.security;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.TestingAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

class SpringSecurityCourseVisibilityAdapterTest {

    private final SpringSecurityCourseVisibilityAdapter adapter =
            new SpringSecurityCourseVisibilityAdapter();

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    @DisplayName("Không có authentication thì không được xem course đã xóa")
    void canViewDeletedCourses_withoutAuthentication_returnsFalse() {
        SecurityContextHolder.clearContext();

        assertFalse(adapter.canViewDeletedCourses());
    }

    @Test
    @DisplayName("User không có ROLE_ADMIN thì không được xem course đã xóa")
    void canViewDeletedCourses_userRole_returnsFalse() {
        SecurityContextHolder.getContext()
                .setAuthentication(
                        new TestingAuthenticationToken("user", "password", "ROLE_USER"));

        assertFalse(adapter.canViewDeletedCourses());
    }

    @Test
    @DisplayName("Admin có ROLE_ADMIN thì được xem course đã xóa")
    void canViewDeletedCourses_adminRole_returnsTrue() {
        SecurityContextHolder.getContext()
                .setAuthentication(
                        new TestingAuthenticationToken("admin", "password", "ROLE_ADMIN"));

        assertTrue(adapter.canViewDeletedCourses());
    }
}
