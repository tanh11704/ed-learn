package com.vku.edtech.modules.badges.infrastructure.persistence.seed;

import com.vku.edtech.modules.badges.domain.model.BadgeCategory;
import com.vku.edtech.modules.badges.infrastructure.persistence.entity.BadgeJpaEntity;
import com.vku.edtech.modules.badges.infrastructure.persistence.repository.BadgeJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
@Profile({"dev", "local"})
@RequiredArgsConstructor
public class BadgeDataSeeder implements CommandLineRunner {

    private final BadgeJpaRepository badgeRepository;

    @Override
    @Transactional
    public void run(String... args) {
        List<BadgeSeedItem> seedItems = List.of(
                new BadgeSeedItem(
                        "STREAK_3",
                        "3 Day Streak",
                        "Learn 3 consecutive days",
                        BadgeCategory.STREAK,
                        "https://cdn.edlearn.local/badges/streak-3.png",
                        10
                ),
                new BadgeSeedItem(
                        "STREAK_7",
                        "7 Day Streak",
                        "Learn 7 consecutive days",
                        BadgeCategory.STREAK,
                        "https://cdn.edlearn.local/badges/streak-7.png",
                        25
                ),
                new BadgeSeedItem(
                        "STREAK_30",
                        "30 Day Streak",
                        "Learn 30 consecutive days",
                        BadgeCategory.STREAK,
                        "https://cdn.edlearn.local/badges/streak-30.png",
                        100
                ),
                new BadgeSeedItem(
                        "SOCIAL_FIRST_HELP",
                        "First Helper",
                        "First time helping another learner",
                        BadgeCategory.SOCIAL,
                        "https://cdn.edlearn.local/badges/social-first-help.png",
                        15
                ),
                new BadgeSeedItem(
                        "SOCIAL_COMMUNITY_VOICE",
                        "Community Voice",
                        "Active participation in the learning community",
                        BadgeCategory.SOCIAL,
                        "https://cdn.edlearn.local/badges/social-community-voice.png",
                        30
                )
        );

        int insertedCount = 0;

        for (BadgeSeedItem seedItem : seedItems) {
            if (badgeRepository.existsByCode(seedItem.code())) {
                continue;
            }

            BadgeJpaEntity badge = BadgeJpaEntity.builder()
                    .code(seedItem.code())
                    .name(seedItem.name())
                    .description(seedItem.description())
                    .category(seedItem.category())
                    .imageUrl(seedItem.imageUrl())
                    .xpReward(seedItem.xpReward())
                    .build();

            badgeRepository.save(badge);
            insertedCount++;
        }

        System.out.println(">> Badge Data Seeder completed. Inserted: " + insertedCount);
    }

    private record BadgeSeedItem(
            String code,
            String name,
            String description,
            BadgeCategory category,
            String imageUrl,
            Integer xpReward
    ) {
    }
}