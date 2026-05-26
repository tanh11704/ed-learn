package com.vku.edtech.shared.infrastructure.storage;

import com.vku.edtech.shared.application.ports.out.FileStoragePort;
import com.vku.edtech.shared.presentation.exception.FileStorageException;
import io.minio.BucketExistsArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.SetBucketPolicyArgs;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Component
@ConditionalOnProperty(name = "app.storage.type", havingValue = "minio")
public class MinioStorageAdapter implements FileStoragePort {

    private final MinioClient minioClient;
    private final String bucket;
    private final String publicUrl;

    public MinioStorageAdapter(
            @Value("${app.storage.minio.endpoint}") String endpoint,
            @Value("${app.storage.minio.public-url}") String publicUrl,
            @Value("${app.storage.minio.access-key}") String accessKey,
            @Value("${app.storage.minio.secret-key}") String secretKey,
            @Value("${app.storage.minio.bucket}") String bucket) {
        this.minioClient =
                MinioClient.builder()
                        .endpoint(endpoint)
                        .credentials(accessKey, secretKey)
                        .build();
        this.publicUrl = stripTrailingSlash(publicUrl);
        this.bucket = bucket;
    }

    @Override
    public String uploadFile(MultipartFile file, String subDirectory) {
        try {
            ensureBucketExists();

            String objectName = buildObjectName(file, subDirectory);
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket(bucket)
                            .object(objectName)
                            .stream(file.getInputStream(), file.getSize(), -1)
                            .contentType(resolveContentType(file))
                            .build());

            return publicUrl + "/" + bucket + "/" + objectName;
        } catch (Exception e) {
            throw new FileStorageException("Lỗi hệ thống: Không thể lưu file lên MinIO!", e);
        }
    }

    private void ensureBucketExists() throws Exception {
        boolean exists =
                minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucket).build());
        if (!exists) {
            minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucket).build());
        }
        minioClient.setBucketPolicy(
                SetBucketPolicyArgs.builder().bucket(bucket).config(publicReadPolicy()).build());
    }

    private String buildObjectName(MultipartFile file, String subDirectory) {
        String originalFilename =
                StringUtils.cleanPath(
                        file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String extension = "";
        int extensionIndex = originalFilename.lastIndexOf('.');
        if (extensionIndex >= 0) {
            extension = originalFilename.substring(extensionIndex);
        }
        return trimSlashes(subDirectory) + "/" + UUID.randomUUID() + extension;
    }

    private String resolveContentType(MultipartFile file) {
        return file.getContentType() == null
                ? "application/octet-stream"
                : file.getContentType();
    }

    private String publicReadPolicy() {
        return """
                {
                  "Version": "2012-10-17",
                  "Statement": [
                    {
                      "Effect": "Allow",
                      "Principal": {"AWS": ["*"]},
                      "Action": ["s3:GetObject"],
                      "Resource": ["arn:aws:s3:::%s/*"]
                    }
                  ]
                }
                """
                .formatted(bucket);
    }

    private static String stripTrailingSlash(String value) {
        return value == null ? "" : value.replaceAll("/+$", "");
    }

    private static String trimSlashes(String value) {
        return value == null ? "" : value.replaceAll("^/+|/+$", "");
    }
}
