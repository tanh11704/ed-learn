/**
 * Khớp ErrorResponse từ GlobalExceptionHandler (backend).
 */
export interface ErrorResponseDto {
  status: number;
  error: string;
  message: string;
  details?: unknown;
  timestamp?: number;
}
