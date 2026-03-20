package com.vku.edtech.identify.application.service;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.port.in.RegisterUseCase;
import com.vku.edtech.modules.identity.application.port.out.*;
import com.vku.edtech.modules.identity.application.service.RegisterService;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.domain.model.Role;
import com.vku.edtech.modules.identity.domain.model.User;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Instant;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
public class RegisterServiceTest {

    @Mock
    private UserQueryPort userQueryPort;
    @Mock
    private UserCommandPort userCommandPort;
    @Mock
    private PasswordEncoderPort passwordEncoderPort;
    @Mock
    private TokenGeneratorPort tokenGeneratorPort;
    @Mock
    private RefreshTokenCommandPort refreshTokenCommandPort;

    @InjectMocks
    private RegisterService registerService;

    @Test
    @DisplayName("Đăng ký thaành công - Trả về cặp token")
    void register_success() {
        String email = "anh.tran@vku.udn.vn";
        String password = "pass";
        String fullName = "Trần Phước Anh";

        User mockUser = new User(
                UUID.randomUUID(),
                email,
                password,
                fullName,
                Role.USER,
                Instant.now(),
                Instant.now()
        );

        Mockito.when(userQueryPort.existsByEmail(email)).thenReturn(false);
        Mockito.when(passwordEncoderPort.encode(password)).thenReturn("hashPassword");
        Mockito.when(tokenGeneratorPort.generateAccessToken(any(User.class))).thenReturn("access_token");
        Mockito.when(tokenGeneratorPort.generateRefreshToken(any(User.class))).thenReturn("refresh_token");
        Mockito.when(userCommandPort.save(any(User.class))).thenReturn(mockUser);

        RegisterUseCase.RegisterCommand command = new RegisterUseCase.RegisterCommand(email, password, fullName);

        AuthResult result = registerService.register(command);

        assertNotNull(result);
        assertEquals(result.accessToken(), "access_token");
        assertEquals(result.refreshToken(), "refresh_token");

        verify(refreshTokenCommandPort, times(1)).save(any(RefreshToken.class));
        verify(userCommandPort, times(1)).save(any(User.class));

    }
}
