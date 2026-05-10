
export interface LoginRequestDto {
  email: string;
  password: string;
}

export interface AuthResponseDto {
  accessToken: string;
  refreshToken: string;
  tokenType?: string;
}

export interface RefreshTokenRequestDto {
  refreshToken: string;
}
