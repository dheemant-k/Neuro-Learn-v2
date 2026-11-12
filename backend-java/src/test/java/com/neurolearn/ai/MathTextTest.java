package com.neurolearn.ai;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class MathTextTest {

    @Test
    void stripsInlineDelimitersAndConvertsCommonCommands() {
        assertThat(MathText.toPlain("Solve $2x^2 + 3x + 5 = 0$ now")).isEqualTo("Solve 2x^2 + 3x + 5 = 0 now");
        assertThat(MathText.toPlain("$x = 3 \\pm \\sqrt{2}$")).isEqualTo("x = 3 ± √(2)");
        assertThat(MathText.toPlain("$\\Delta = b^{2} - 4ac$")).isEqualTo("Δ = b^2 - 4ac");
        assertThat(MathText.toPlain("$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$")).isEqualTo("x = (-b ± √(b^2 - 4ac))/(2a)");
        assertThat(MathText.toPlain("Area 40 m$^2$")).isEqualTo("Area 40 m^2");
        assertThat(MathText.toPlain("\\(x \\geq 3\\)")).isEqualTo("x ≥ 3");
        assertThat(MathText.toPlain("$\\text{Two distinct real roots}$ ($\\Delta > 0$)")).isEqualTo("Two distinct real roots (Δ > 0)");
    }

    @Test
    void nestedBracesResolveInOnePassAndConversionIsIdempotent() {
        String latex = "$\\frac{a_{1}}{a_{2}} = \\frac{b_{1}}{b_{2}} \\neq \\frac{c_{1}}{\\sqrt{c_{2}}}$";
        String once = MathText.toPlain(latex);
        assertThat(once).isEqualTo("(a_1)/(a_2) = (b_1)/(b_2) ≠ (c_1)/(√(c_2))");
        assertThat(MathText.toPlain(once)).isEqualTo(once);
    }

    @Test
    void plainTextIsLeftAlone() {
        String plain = "Supergirl solves 4x + 3y = 18 and 2x - 3y = 6. Find x.";
        assertThat(MathText.toPlain(plain)).isEqualTo(plain);
        assertThat(MathText.toPlain("x = 2 ± √3")).isEqualTo("x = 2 ± √3");
        assertThat(MathText.toPlain(null)).isNull();
    }

    @Test
    void latexCommandsTurnedIntoControlCharactersAreRepaired() {
        char cr = 13, tab = 9, ff = 12, lf = 10;
        // JSON "\rightarrow" without an escaped backslash decodes to CR + "ightarrow", and so on.
        assertThat(MathText.toPlain("5y = 10 " + cr + "ightarrow y = 2")).isEqualTo("5y = 10 → y = 2");
        assertThat(MathText.toPlain("3 " + tab + "imes 4")).isEqualTo("3 × 4");
        assertThat(MathText.toPlain(ff + "rac{1}{2}")).isEqualTo("1/2");
        assertThat(MathText.toPlain("x " + lf + "eq 3")).isEqualTo("x ≠ 3");
        // Ordinary line breaks are kept.
        assertThat(MathText.toPlain("Step 1: x = 2" + lf + "Step 2: y = 3")).isEqualTo("Step 1: x = 2" + lf + "Step 2: y = 3");
    }

    @Test
    void dollarAmountsBecomeRupees() {
        assertThat(MathText.toPlain("2 crystals cost $15 in total")).isEqualTo("2 crystals cost ₹15 in total");
        assertThat(MathText.toPlain("$2")).isEqualTo("₹2");
        assertThat(MathText.toPlain("A crystal costs $15 and a drive costs $9.")).isEqualTo("A crystal costs ₹15 and a drive costs ₹9.");
        assertThat(MathText.toPlain("Let the width be $x$ metres")).isEqualTo("Let the width be x metres");
    }
}
