package com.vku.edtech.identify.application.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.vku.edtech.modules.identity.application.dto.AuthResult;
import com.vku.edtech.modules.identity.application.exception.InvalidCredentialsException;
import com.vku.edtech.modules.identity.application.port.in.LoginUseCase;
import com.vku.edtech.modules.identity.application.port.out.PasswordEncoderPort;
import com.vku.edtech.modules.identity.application.port.out.RefreshTokenCommandPort;
import com.vku.edtech.modules.identity.application.port.out.TokenGeneratorPort;
import com.vku.edtech.modules.identity.application.port.out.UserQueryPort;
import com.vku.edtech.modules.identity.application.service.LoginService;
import com.vku.edtech.modules.identity.domain.model.RefreshToken;
import com.vku.edtech.modules.identity.domain.model.Role;
import com.vku.edtech.modules.identity.domain.model.User;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
public class LoginUserServiceTest {

    @Mock private UserQueryPort userQueryPort;
    @Mock private PasswordEncoderPort passwordEncoderPort;
    @Mock private TokenGeneratorPort tokenGeneratorPort;
    @Mock private RefreshTokenCommandPort refreshTokenCommandPort;

    @InjectMocks private LoginService loginService;

    @Test
    @DisplayName("Đăng nhập thành công - Trả về cặp Token xịn")
    void login_success() {
        String email = "anh.tran@vku.udn.vn";
        String rawPass = "123456";
        String encodedPass = "hashed_password";
        LoginUseCase.LoginCommand command = new LoginUseCase.LoginCommand(email, rawPass);

        User mockUser =
                new User(
                        UUID.randomUUID(),
                        email,
                        encodedPass,
                        "Trần Phước Anh",
                        Role.USER,
                        Instant.now(),
                        Instant.now());

        when(userQueryPort.findByEmail(email)).thenReturn(Optional.of(mockUser));
        when(passwordEncoderPort.matches(rawPass, encodedPass)).thenReturn(true);
        when(tokenGeneratorPort.generateAccessToken(mockUser)).thenReturn("access_token_xyz");
        when(tokenGeneratorPort.generateRefreshToken(mockUser)).thenReturn("refresh_token_abc");

        AuthResult result = loginService.login(command);

        assertNotNull(result);
        assertEquals("access_token_xyz", result.accessToken());

        verify(userQueryPort, times(1)).findByEmail(email);
        verify(refreshTokenCommandPort, times(1)).save(any(RefreshToken.class));
        verify(passwordEncoderPort).matches(rawPass, encodedPass);
    }

    @Test
    @DisplayName("Đăng nhập thất bại - Sai mật khẩu phải ném InvalidCredentialsException")
    void login_WrongPassword_ThrowException() {
        // GIVEN
        String email = "anh.tran@vku.udn.vn";
        String wrongPass = "wrong_pass";
        String correctHashInDb = "hased_password";

        LoginUseCase.LoginCommand command = new LoginUseCase.LoginCommand(email, wrongPass);

        User mockUser =
                new User(
                        UUID.randomUUID(),
                        email,
                        correctHashInDb,
                        "Trần Phước Anh",
                        Role.USER,
                        Instant.now(),
                        Instant.now());

        when(userQueryPort.findByEmail(email)).thenReturn(Optional.of(mockUser));
        when(passwordEncoderPort.matches(wrongPass, correctHashInDb)).thenReturn(false);

        assertThrows(InvalidCredentialsException.class, () -> loginService.login(command));
    }
}
