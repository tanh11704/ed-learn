package com.vku.edtech.modules.exams.domain.model;

import com.vku.edtech.modules.lms.domain.exception.InvalidDomainDataException;
import java.math.BigDecimal;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;

public final class Thpt2026ExamProfile {

    public static final String PROFILE_CODE = "THPT_2026";
    public static final BigDecimal MAX_SCORE = BigDecimal.TEN;

    private static final BigDecimal PART_I_SCORE = new BigDecimal("0.25");
    private static final BigDecimal PART_II_SCORE = BigDecimal.ONE;
    private static final BigDecimal PART_III_MATH_SCORE = new BigDecimal("0.5");
    private static final BigDecimal PART_III_OTHER_SCORE = new BigDecimal("0.25");
    private static final Pattern DIACRITICS = Pattern.compile("\\p{M}");

    private static final Map<String, SubjectSpec> SUBJECTS = subjects();

    private Thpt2026ExamProfile() {}

    public static ExamStructure structureFor(String subject) {
        SubjectSpec spec = findSubject(subject);
        return new ExamStructure(
                PROFILE_CODE,
                spec.name(),
                spec.durationMinutes(),
                spec.partICount(),
                spec.partIICount(),
                spec.partIIICount(),
                MAX_SCORE,
                rules(spec));
    }

    public static boolean supports(String subject) {
        return SUBJECTS.containsKey(normalize(subject));
    }

    private static SubjectSpec findSubject(String subject) {
        SubjectSpec spec = SUBJECTS.get(normalize(subject));
        if (spec == null) {
            throw new InvalidDomainDataException("Môn học chưa được hỗ trợ theo cấu trúc THPT 2026");
        }
        return spec;
    }

    private static List<ExamQuestionScoringRule> rules(SubjectSpec spec) {
        List<ExamQuestionScoringRule> baseRules =
                new java.util.ArrayList<>(
                        List.of(
                                new ExamQuestionScoringRule(
                                        ExamQuestionType.MULTIPLE_CHOICE,
                                        ExamQuestionPaperPart.PART_I,
                                        PART_I_SCORE,
                                        1)));

        if (spec.partIICount() > 0) {
            baseRules.add(
                    new ExamQuestionScoringRule(
                            ExamQuestionType.TRUE_FALSE,
                            ExamQuestionPaperPart.PART_II,
                            PART_II_SCORE,
                            4));
        }
        if (spec.partIIICount() > 0) {
            baseRules.add(
                    new ExamQuestionScoringRule(
                            ExamQuestionType.SHORT_ANSWER,
                            ExamQuestionPaperPart.PART_III,
                            spec.partIIIScore(),
                            1));
        }

        return List.copyOf(baseRules);
    }

    private static Map<String, SubjectSpec> subjects() {
        Map<String, SubjectSpec> subjects = new HashMap<>();
        add(subjects, new SubjectSpec("Toán", 90, 12, 4, 6, PART_III_MATH_SCORE), "toan", "math");
        add(subjects, new SubjectSpec("Vật lí", 50, 18, 4, 6, PART_III_OTHER_SCORE), "vat li", "vat ly", "ly", "physics");
        add(subjects, new SubjectSpec("Hóa học", 50, 18, 4, 6, PART_III_OTHER_SCORE), "hoa hoc", "hoa", "chemistry");
        add(subjects, new SubjectSpec("Sinh học", 50, 18, 4, 6, PART_III_OTHER_SCORE), "sinh hoc", "sinh", "biology");
        add(subjects, new SubjectSpec("Địa lí", 50, 18, 4, 6, PART_III_OTHER_SCORE), "dia li", "dia ly", "dia", "geography");
        add(subjects, new SubjectSpec("Lịch sử", 50, 24, 4, 0, null), "lich su", "su", "history");
        add(subjects, new SubjectSpec("Giáo dục kinh tế - pháp luật", 50, 24, 4, 0, null), "giao duc kinh te phap luat", "giao duc kinh te va phap luat", "gdktpl", "gdcd");
        add(subjects, new SubjectSpec("Tin học", 50, 24, 6, 0, null), "tin hoc", "tin", "informatics");
        add(subjects, new SubjectSpec("Công nghệ công nghiệp", 50, 24, 4, 0, null), "cong nghe cong nghiep", "cong nghe", "technology");
        add(subjects, new SubjectSpec("Công nghệ nông nghiệp", 50, 24, 4, 0, null), "cong nghe nong nghiep");
        add(subjects, new SubjectSpec("Ngoại ngữ", 50, 40, 0, 0, null), "ngoai ngu", "tieng anh", "tieng nga", "tieng phap", "tieng duc", "tieng han", "tieng nhat", "tieng trung", "english", "foreign language");
        add(subjects, new SubjectSpec("Ngữ văn", 120, 0, 0, 0, null), "ngu van", "van", "literature");
        return Map.copyOf(subjects);
    }

    private static void add(Map<String, SubjectSpec> subjects, SubjectSpec spec, String... aliases) {
        for (String alias : aliases) {
            subjects.put(normalize(alias), spec);
        }
    }

    private static String normalize(String value) {
        if (value == null) {
            return "";
        }
        String normalized = Normalizer.normalize(value.trim().toLowerCase(Locale.ROOT), Normalizer.Form.NFD);
        return DIACRITICS.matcher(normalized)
                .replaceAll("")
                .replace('đ', 'd')
                .replaceAll("[^a-z0-9]+", " ")
                .trim();
    }

    private record SubjectSpec(
            String name,
            int durationMinutes,
            int partICount,
            int partIICount,
            int partIIICount,
            BigDecimal partIIIScore) {}
}
