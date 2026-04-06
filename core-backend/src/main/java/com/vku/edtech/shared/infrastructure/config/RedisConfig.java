package com.vku.edtech.shared.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJacksonJsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import tools.jackson.databind.DefaultTyping;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.jsontype.BasicPolymorphicTypeValidator;

@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // 1. Cấu hình Serializer cho Key (Khóa)
        // Biến Key thành dạng String chuẩn để người đọc được (ví dụ: "course:detail:1")
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);

        // 2. Cấu hình Serializer cho Value (Giá trị)
        // Tạo "bộ não" ObjectMapper (Jackson 3)
        ObjectMapper objectMapper =
                JsonMapper.builder()
                        .activateDefaultTyping(
                                BasicPolymorphicTypeValidator.builder()
                                        .allowIfSubType("com.vku.edtech")
                                        .build(),
                                DefaultTyping.NON_FINAL)
                        .build();

        // Biến Object Java (Course, Lesson) thành chuỗi JSON
        GenericJacksonJsonRedisSerializer jsonSerializer =
                new GenericJacksonJsonRedisSerializer(objectMapper);
        template.setValueSerializer(jsonSerializer);
        template.setHashValueSerializer(jsonSerializer);

        template.afterPropertiesSet();
        return template;
    }
}
