package com.vku.edtech.shared.config;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "cors")
public class CorsProperties {
  private String allowedOrigins;

  public List<String> getAllowedOrigins() {
    if (allowedOrigins == null || allowedOrigins.trim().isEmpty()) {
      return List.of("*");
    }
    return Arrays.stream(allowedOrigins.split(","))
        .map(String::trim)
        .filter(origin -> !origin.isBlank())
        .collect(Collectors.toList());
  }

  public void setAllowedOrigins(String allowedOrigins) {
    this.allowedOrigins = allowedOrigins;
  }
}
