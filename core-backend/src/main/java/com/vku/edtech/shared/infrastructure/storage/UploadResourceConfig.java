package com.vku.edtech.shared.infrastructure.storage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class UploadResourceConfig implements WebMvcConfigurer {

    @Value("${app.storage.local-dir:uploads/}")
    private String baseDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = baseDir.endsWith("/") ? baseDir : baseDir + "/";
        registry.addResourceHandler("/uploads/**").addResourceLocations("file:" + location);
    }
}
