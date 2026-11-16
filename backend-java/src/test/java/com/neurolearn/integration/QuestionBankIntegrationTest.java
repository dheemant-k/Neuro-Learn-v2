package com.neurolearn.integration;

import com.neurolearn.entity.Question;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * The seeded question bank must make every rule in the app reachable. "Mastered" needs two correct level-3
 * answers in a section, and the ramp starts every student at level 1, so each section needs level-3
 * questions, and each hero needs questions at every level (Chapter 2 once had almost no level-3 questions,
 * so no quadratics section could be mastered).
 */
class QuestionBankIntegrationTest extends IntegrationTestBase {

    private static final List<String> SECTIONS = List.of(
            "intro", "graphing", "pair_of_equations", "substitution", "elimination", "word_problems",
            "quad_intro", "quad_factoring", "quad_formula", "quad_discriminant", "quad_graphing", "quad_word_problems");
    private static final List<String> HEROES = List.of("batman", "superman", "supergirl");

    @Test
    void everySectionHasEnoughLevelThreeQuestionsToBeMastered() {
        for (String section : SECTIONS) {
            assertThat(questionRepository.findByTopicAndDifficulty(section, 3).size())
                    .as(section + " level-3 questions").isGreaterThanOrEqualTo(2);
        }
    }

    @Test
    void everyHeroHasQuestionsAtEveryLevelOfEveryQuadraticsSection() {
        for (String section : SECTIONS.subList(6, SECTIONS.size())) {
            for (String hero : HEROES) {
                for (int level = 1; level <= 3; level++) {
                    List<Question> own = questionRepository.findByTopicAndDifficultyAndCharacterTheme(section, level, hero);
                    assertThat(own).as(section + " / " + hero + " / level " + level).isNotEmpty();
                }
            }
        }
    }
}
