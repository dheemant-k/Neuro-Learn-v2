"""Charts for docs/evaluation_attention.md (Evaluation 2) from summary.csv and trajectory.csv here.

    python make_charts.py
"""
import csv
import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
LABELS = {
    "fixed": "Fixed ramp",
    "adaptive": "Original engine (BKT cut-offs)",
    "adaptive_0.20_0.60_levelaware": "Tuned engine",
    "elo_target50": "Difficulty-aware Elo",
    "ramp_remediation": "Ramp with remediation",
    "adaptive_ramp": "Adaptive ramp",
    "random": "Random level",
}
ORDER = list(LABELS)
COLORS = {
    "fixed": "#2a6fdb",
    "adaptive": "#e0533d",
    "adaptive_0.20_0.60_levelaware": "#f2a03d",
    "elo_target50": "#2e9e6b",
    "ramp_remediation": "#8b5cf6",
    "adaptive_ramp": "#0f766e",
    "random": "#9aa3ad",
}
SCENARIOS = {
    "baseline": "Attentive\n(baseline)",
    "inattentive": "Inattentive",
    "frustration_quit": "Attentive +\nquitting",
    "inattentive_quit": "Inattentive +\nquitting",
}


def read(name):
    with open(os.path.join(HERE, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


summary = read("summary.csv")
traj = read("trajectory.csv")


def row(scenario, policy):
    return next(r for r in summary if r["scenario"] == scenario and r["policy"] == policy)


# 1. Mastered by question 30: attentive vs inattentive
fig, ax = plt.subplots(figsize=(11, 4.6))
scs = list(SCENARIOS)
width = 0.8 / len(ORDER)
for i, p in enumerate(ORDER):
    vals = [float(row(s, p)["mastered_by_end"]) * 100 for s in scs]
    ax.bar([j + i * width for j in range(len(scs))], vals, width, label=LABELS[p], color=COLORS[p])
ax.set_xticks([j + width * (len(ORDER) - 1) / 2 for j in range(len(scs))])
ax.set_xticklabels([SCENARIOS[s] for s in scs], fontsize=9)
ax.set_ylabel("% truly mastered by question 30")
ax.set_title("Mastery within 30 questions: attentive vs inattentive learners")
ax.legend(fontsize=8, frameon=False, ncol=4, loc="upper right")
ax.set_ylim(0, 100)
ax.grid(axis="y", alpha=0.25)
fig.tight_layout()
fig.savefig(os.path.join(HERE, "attention_mastery.png"), dpi=150)
plt.close(fig)

# 2. Inattentive + quitting: quit rate vs mastery
fig, ax = plt.subplots(figsize=(9, 4.6))
for p in ORDER:
    r = row("inattentive_quit", p)
    ax.scatter(float(r["quit_rate"]) * 100, float(r["mastered_by_end"]) * 100, s=90, color=COLORS[p],
               label=LABELS[p], zorder=3)
ax.set_xlabel("% who quit early (lower is better)")
ax.set_ylabel("% truly mastered by question 30")
ax.set_title("Inattentive + quitting: keeping students vs moving them on")
ax.grid(alpha=0.25)
ax.legend(fontsize=7.5, frameon=False, loc="center left", bbox_to_anchor=(1.02, 0.5))
fig.tight_layout()
fig.savefig(os.path.join(HERE, "attention_tradeoff.png"), dpi=150)
plt.close(fig)

# 3. Why: the level each ramp serves over time, attentive vs inattentive
fig, ax = plt.subplots(figsize=(7.5, 4.6))
lines = [("baseline", "fixed", "-", "Fixed ramp (ignores answers: same for both groups)"),
         ("baseline", "adaptive_ramp", "-", "Adaptive ramp, attentive"),
         ("inattentive", "adaptive_ramp", "--", "Adaptive ramp, inattentive")]
for sc, p, ls, label in lines:
    rows = [r for r in traj if r["scenario"] == sc and r["policy"] == p]
    ax.plot([int(r["step"]) for r in rows], [float(r["mean_level"]) for r in rows], ls, color=COLORS[p],
            lw=2, label=label)
ax.set_xlabel("Question number")
ax.set_ylabel("Average level served (1 easy – 3 hard)")
ax.set_title("Lapses hold the adaptive ramp at easier levels")
ax.set_ylim(0.9, 3.1)
ax.grid(alpha=0.25)
ax.legend(fontsize=8, frameon=False, loc="lower right")
fig.tight_layout()
fig.savefig(os.path.join(HERE, "attention_levels.png"), dpi=150)
plt.close(fig)

print("charts written to", HERE)
