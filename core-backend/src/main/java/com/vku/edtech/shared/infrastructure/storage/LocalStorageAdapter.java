package com.vku.edtech.shared.infrastructure.storage;

import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.FileStorageException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Component
@ConditionalOnProperty(name = "app.storage.type", havingValue = "local", matchIfMissing = true)
public class LocalStorageAdapter implements FileStoragePort {

    @Value("${app.storage.local-dir:uploads/}")
    private String baseDir;

    @Override
    public String uploadFile(MultipartFile file, String subDirectory) {
        try {
            // 1. Tạo đường dẫn thư mục lưu trữ (VD: uploads/lessons)
            Path uploadPath = Paths.get(baseDir + subDirectory);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 2. Xử lý tên file: Dùng UUID để chống trùng lặp tên file
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + extension;

            // 3. Tiến hành copy file từ request vào ổ cứng
            Path filePath = uploadPath.resolve(uniqueFileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            // 4. Trả về đường dẫn tương đối (chỉ lưu đoạn này vào DB)
            return subDirectory + "/" + uniqueFileName;
        } catch (IOException e) {
            throw new FileStorageException("Lỗi hệ thống: Không thể lưu file giáo trình!", e);
        }
    }
}
