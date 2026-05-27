package com.vku.edtech.shared.application.ports.out;

import org.springframework.web.multipart.MultipartFile;

public interface FileStoragePort {
    /**
     * @param file File tải lên từ Client
     * @param subDirectory Thư mục con (VD: "lessons", "avatars")
     * @return Đường dẫn file đã lưu để cất vào Database
     */
    String uploadFile(MultipartFile file, String subDirectory);

    /**
     * @param fileUrl Đường dẫn file đã lưu trước đó
     */
    void deleteFile(String fileUrl);
}
