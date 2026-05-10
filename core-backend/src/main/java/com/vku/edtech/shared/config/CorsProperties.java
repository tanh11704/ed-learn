package com.vku.edtech.shared.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "cors")
public class CorsProperties {
  private String allowedOrigins;

  public List<String> getAllowedOrigins() {
    if (allowedOrigins == null || allowedOrigins.trim().isEmpty()) {
      return Arrays.asList("http://localhost:5173", "https://localhost:5173");
    }
    return Arrays.asList(allowedOrigins.split(","));
  }

  public void setAllowedOrigins(String allowedOrigins) {
    this.allowedOrigins = allowedOrigins;
  }
}
