package com.vku.edtech.modules.badges.domain.model;

import java.util.UUID;

public class Badge {
    private UUID id;
    private String code;
    private String name;
    private String description;
    private BadgeCategory category;
    private String imageUrl;
    private Integer xpReward;

    public Badge() {}

    public Badge(
            UUID id,
            String code,
            String name,
            String description,
            BadgeCategory category,
            String imageUrl,
            Integer xpReward) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.category = category;
        this.imageUrl = imageUrl;
        this.xpReward = xpReward;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BadgeCategory getCategory() {
        return category;
    }

    public void setCategory(BadgeCategory category) {
        this.category = category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getXpReward() {
        return xpReward;
    }

    public void setXpReward(Integer xpReward) {
        this.xpReward = xpReward;
    }
}
