package com.vku.edtech.modules.identity.infrastructure.persistence.seed;

import com.vku.edtech.modules.identity.application.port.out.PasswordEncoderPort;
import com.vku.edtech.modules.identity.domain.model.Role;
import com.vku.edtech.modules.identity.infrastructure.persistence.entity.UserJpaEntity;
import com.vku.edtech.modules.identity.infrastructure.persistence.repository.JpaUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
public class AdminAccountSeeder implements CommandLineRunner {

    private static final String ADMIN_EMAIL = "admin@gmail.com";
    private static final String ADMIN_PASSWORD = "123456";
    private static final String ADMIN_FULL_NAME = "System Admin";

    private final JpaUserRepository userRepository;
    private final PasswordEncoderPort passwordEncoderPort;

    @Override
    @Transactional
    public void run(String... args) {
        if (userRepository.existsByEmail(ADMIN_EMAIL)) {
            return;
        }

        UserJpaEntity admin =
                UserJpaEntity.builder()
                        .email(ADMIN_EMAIL)
                        .passwordHash(passwordEncoderPort.encode(ADMIN_PASSWORD))
                        .fullName(ADMIN_FULL_NAME)
                        .role(Role.ADMIN)
                        .build();

        userRepository.save(admin);
    }
}
