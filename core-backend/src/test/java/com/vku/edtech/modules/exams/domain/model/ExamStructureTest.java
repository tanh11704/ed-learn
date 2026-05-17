package com.vku.edtech.modules.exams.domain.model;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class ExamStructureTest {

    @Test
    void thpt2026_math_structure_should_match_official_format() {
        ExamStructure structure = ExamStructure.thpt2026("Toán");

        assertEquals(90, structure.durationMinutes());
        assertEquals(12, structure.partICount());
        assertEquals(4, structure.partIICount());
        assertEquals(6, structure.partIIICount());
        assertEquals(22, structure.totalQuestions());
        assertEquals(BigDecimal.TEN, structure.maxScore());
        assertEquals(
                new BigDecimal("0.5"),
                structure
                        .findRule(ExamQuestionType.SHORT_ANSWER, ExamQuestionPaperPart.PART_III)
                        .orElseThrow()
                        .scorePerQuestion());
    }

    @Test
    void thpt2026_foreign_language_structure_should_only_use_part_i() {
        ExamStructure structure = ExamStructure.thpt2026("Tiếng Anh");

        assertEquals(50, structure.durationMinutes());
        assertEquals(40, structure.partICount());
        assertEquals(0, structure.partIICount());
        assertEquals(0, structure.partIIICount());
        assertEquals(40, structure.totalQuestions());
    }
}
