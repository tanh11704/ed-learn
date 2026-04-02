package com.vku.edtech.modules.identity.application.port.out;

public interface TokenInspectionPort {
    /**
     * Trả về thời gian sống còn lại của Token (tính bằng milliseconds). Nếu token đã hết hạn hoặc
     * không hợp lệ, trả về 0.
     */
    long getRemainingTtlInMillis(String token);
}
