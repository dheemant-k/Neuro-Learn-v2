import { useEffect, useRef, useState } from "react";
import lexluthorImg from "../assets/lexluthor.png";
import jokerImg from "../assets/joker.png";
import brainiacImg from "../assets/brainiac.png";

// Typewriter hook
function useTypewriter(text, speed = 28) {
  const [typed, setTyped] = useState({ text, count: 0 });
  if (typed.text !== text) {
    setTyped({ text, count: 0 });
  }

  useEffect(() => {
    if (!text) return;
    const timer = setInterval(() => {
      setTyped((prev) => {
        if (prev.text !== text || prev.count >= text.length) return prev;
        return { text, count: prev.count + 1 };
      });
    }, speed);
    return () => clearInterval(timer);
  }, [text, speed]);

  return (text || "").slice(0, typed.text === text ? typed.count : 0);
}

const pick = (list) => list[Math.floor(Math.random() * list.length)];

// Particle burst component
function ParticleBurst({ active, color }) {
  const [dists] = useState(() => Array.from({ length: 12 }, () => 40 + Math.random() * 30));
  const particles = dists.map((_, i) => i);
  if (!active) return null;
  return (
    <div className="absolute inset-0 pointer-events-none overflow-hidden rounded-3xl">
      {particles.map((i) => {
        const angle = (i / particles.length) * 360;
        const dist = dists[i];
        return (
          <div
            key={i}
            className="absolute w-1.5 h-1.5 rounded-full"
            style={{
              background: color,
              top: "50%",
              left: "50%",
              animation: `particleFly${i % 4} 0.6s ease-out forwards`,
              transform: `rotate(${angle}deg) translateX(${dist}px)`,
              opacity: 0,
            }}
          />
        );
      })}
    </div>
  );
}

const HERO_VILLAIN_DATA = {
  batman: {
    hero: {
      name: "Batman",
      icon: "🦇",
      fallbackText: "B",
      burstColor: "#38bdf8",
      glowRingColor: "rgba(56, 189, 248, 0.9)",
      correctQuotes: [
        "Direct hit. Coordinates verified by the Batcomputer.",
        "Variables isolated. That's tactical deduction.",
        "Linear system cracked. Gotham is under control.",
        "Calculations aligned with forensic precision.",
        "Target neutralized. Stay vigilant.",
      ],
      streakQuotes: (s) => [
        `SHADOW STRIKE! ${s}x Combo! Arkham's network is breaking!`,
        `FORENSIC MASTERY! ${s} consecutive solutions!`,
        `DARK KNIGHT DOMINANCE! ${s} in a row! Gotham is safe!`,
      ],
      idleQuotes: [
        "Patience and deduction. Solve it step by step.",
        "Check the coefficients. Gotham is counting on us.",
        "The evidence always reveals the solution.",
      ],
    },
    villain: {
      id: "joker",
      name: "The Joker",
      img: jokerImg,
      icon: "🃏",
      burstColor: "#10b981",
      glowRingColor: "rgba(168, 85, 247, 0.9)",
      panelLabel: "The Joker panel",
      activeStatus: "✗ That's a Laugh!",
      idleStatus: "🃏 Smylex Gas Ready",
      caretColor: "#10b981",
      tagClass: "bg-purple-950/80 border-emerald-500/50 text-emerald-300",
      tagActiveClass: "bg-gradient-to-r from-purple-900 to-emerald-950 border-emerald-400 text-emerald-200 shadow-emerald-500/30",
      bubbleBorder: "border-emerald-500/60 bg-slate-950/95",
      taunts: [
        "Why so serious? You missed by a mile, Bats! Hahaha!",
        "Did you drop a variable in the chemical vat? Laughable!",
        "Wrong answer, Dark Knight! Arkham's gates are swinging open!",
        "Is that your best calculation? Even the Riddler solves faster than that!",
      ],
      idleQuotes: [
        "Tick-tock, Batman... Gotham's countdown is running!",
        "One wrong sign and the joke's on you! Hahahaha!",
        "Let's put a smile on those algebraic equations!",
      ],
    },
  },
  supergirl: {
    hero: {
      name: "Supergirl",
      icon: "⚡",
      fallbackText: "SG",
      burstColor: "#c084fc",
      glowRingColor: "rgba(192, 132, 252, 0.9)",
      correctQuotes: [
        "Sunlight surge! That coordinate vector balanced cleanly!",
        "DEO telemetry confirmed! We broke their frequency!",
        "Super sonic accuracy! You solved it in record time!",
        "High-speed deduction! National City is rallying!",
        "Exactly right! That's true Kryptonian power!",
      ],
      streakQuotes: (s) => [
        `COSMIC SURGE! ${s}x Combo! National City is safe!`,
        `SUPER SONIC STRIKE! ${s} consecutive solutions!`,
        `KRYPTONIAN ACCURACY! ${s} in a row! Unstoppable!`,
      ],
      idleQuotes: [
        "Deep breath. Trust your speed and calculation.",
        "National City needs us. Break through their grid!",
        "Step by step — you've got this!",
      ],
    },
    villain: {
      id: "brainiac",
      name: "Brainiac",
      img: brainiacImg,
      icon: "🤖",
      burstColor: "#d946ef",
      glowRingColor: "rgba(217, 70, 239, 0.9)",
      panelLabel: "Brainiac panel",
      activeStatus: "✗ Illogical Calculation!",
      idleStatus: "🧠 Tachyon Forcefield",
      caretColor: "#d946ef",
      tagClass: "bg-emerald-950/80 border-fuchsia-500/50 text-fuchsia-300",
      tagActiveClass: "bg-gradient-to-r from-emerald-950 to-fuchsia-950 border-fuchsia-400 text-fuchsia-200 shadow-fuchsia-500/30",
      bubbleBorder: "border-fuchsia-500/60 bg-slate-950/95",
      taunts: [
        "Inefficient. Your biological cognitive pathways lack algebraic precision.",
        "Error detected in biological processing. The 12th-level intellect prevails.",
        "A primitive calculation. My tachyon shield easily dispersed that vector.",
        "Illogical substitution. Resistance to mathematical certainty is futile.",
      ],
      idleQuotes: [
        "National City's energy grid will be cataloged and collected...",
        "Your Kryptonian heritage cannot compensate for flawed arithmetic.",
        "Tachyon matrix operating at 100% capacity.",
      ],
    },
  },
  superman: {
    hero: {
      name: "Superman",
      icon: "🦸",
      fallbackText: "S",
      burstColor: "#38bdf8",
      glowRingColor: "rgba(56, 189, 248, 0.9)",
      correctQuotes: [
        "Direct hit! That coordinate vector balanced perfectly!",
        "Solar Core surging! You decrypted the variable!",
        "Linear equation conquered! That's true hero math!",
        "Flawless! LexCorp's scrambler is destabilized!",
        "Exactly right! Keep this speed and focus alive!",
      ],
      streakQuotes: (s) => [
        `UNSTOPPABLE! ${s}x Combo! Metropolis is rallying!`,
        `DOUBLE IMPACT! ${s} consecutive breaches!`,
        `SUPER SONIC ACCURACY! ${s} in a row! The city is safe!`,
      ],
      idleQuotes: [
        "Focus. Metropolis is counting on you.",
        "Take your time — solve it step by step.",
        "I believe in you. Break through.",
      ],
    },
    villain: {
      id: "lexluthor",
      name: "Lex Luthor",
      img: lexluthorImg,
      icon: "🏢",
      burstColor: "#f87171",
      glowRingColor: "rgba(248, 113, 113, 0.9)",
      panelLabel: "Lex Luthor panel",
      activeStatus: "✗ Deflected!",
      idleStatus: "🔒 Firewall Active",
      caretColor: "#f87171",
      tagClass: "char-name-tag-villain",
      tagActiveClass: "char-name-tag-villain-active",
      bubbleBorder: "border-rose-500/60 bg-slate-950/95",
      taunts: [
        "Did you drop a minus sign? My firewall absorbed that!",
        "Miscalculated! Linear systems need precision!",
        "Did you rush the substitution? LexCorp Grid: 1, Hero: 0!",
        "Mathematically inaccurate! Check your coefficients!",
      ],
      idleQuotes: [
        "Your calculations won't breach my quantum grid...",
        "LexCorp's firewall stands at 100%. Try your best.",
        "Every equation you miss feeds my power supply.",
      ],
    },
  },
};

export default function CharacterReactionPopup({
  hero,
  state, // "idle" | "correct" | "wrong"
  streak = 0,
}) {
  const [bubbleText, setBubbleText] = useState("");
  const [activeSide, setActiveSide] = useState(null); // "hero" | "villain" | null
  const [burstHero, setBurstHero] = useState(false);
  const [burstVillain, setBurstVillain] = useState(false);
  const dismissRef = useRef(null);

  const heroKey = (hero?.id || hero?.name || "superman").toLowerCase().includes("batman")
    ? "batman"
    : (hero?.id || hero?.name || "superman").toLowerCase().includes("supergirl")
    ? "supergirl"
    : "superman";

  const config = HERO_VILLAIN_DATA[heroKey];
  const heroData = config.hero;
  const villainData = config.villain;

  const heroName = hero?.name || heroData.name;
  const heroImg = hero?.image;

  /* eslint-disable react-hooks/set-state-in-effect */
  useEffect(() => {
    clearTimeout(dismissRef.current);
    if (state === "correct") {
      setActiveSide("hero");
      setBurstHero(true);
      setTimeout(() => setBurstHero(false), 700);
      setBubbleText(pick(streak >= 2 ? heroData.streakQuotes(streak) : heroData.correctQuotes));
      dismissRef.current = setTimeout(() => {
        setActiveSide(null);
        setBubbleText("");
      }, 4500);
    } else if (state === "wrong") {
      setActiveSide("villain");
      setBurstVillain(true);
      setTimeout(() => setBurstVillain(false), 700);
      setBubbleText(pick(villainData.taunts));
      dismissRef.current = setTimeout(() => {
        setActiveSide(null);
        setBubbleText("");
      }, 4500);
    } else {
      setActiveSide(null);
      setBubbleText("");
    }
    return () => clearTimeout(dismissRef.current);
  }, [state, streak, heroData, villainData]);
  /* eslint-enable react-hooks/set-state-in-effect */

  // Picked once per mount so idle lines don't change on every re-render.
  const [heroIdle] = useState(() => pick(heroData.idleQuotes));
  const [villainIdle] = useState(() => pick(villainData.idleQuotes));

  const displayHero = activeSide === "hero" ? bubbleText : heroIdle;
  const displayVillain = activeSide === "villain" ? bubbleText : villainIdle;

  const typedHero = useTypewriter(displayHero, 22);
  const typedVillain = useTypewriter(displayVillain, 22);

  return (
    <>
      {/* LEFT: Hero Character Panel */}
      <aside
        className="character-panel character-panel-left"
        aria-label={`${heroName} panel`}
        data-active={activeSide === "hero"}
      >
        {/* Glow ring */}
        <div
          className={`char-avatar-ring ${activeSide === "hero" ? "ring-active-hero" : ""}`}
          style={activeSide === "hero" ? { borderColor: heroData.glowRingColor } : {}}
        >
          <div className="char-burst-container">
            <ParticleBurst active={burstHero} color={heroData.burstColor} />
            {heroImg ? (
              <img
                src={heroImg}
                alt={heroName}
                className="char-avatar-img"
              />
            ) : (
              <div className="char-avatar-fallback char-avatar-fallback-hero">
                {heroData.fallbackText}
              </div>
            )}
            {activeSide === "hero" && streak >= 2 && (
              <div className="streak-badge animate-bounce">
                🔥 {streak}x
              </div>
            )}
          </div>
        </div>

        {/* Name tag */}
        <div className={`char-name-tag ${activeSide === "hero" ? "char-name-tag-hero-active" : "char-name-tag-hero"}`}>
          <span className="char-name-icon">{activeSide === "hero" && streak >= 2 ? "⚡" : heroData.icon}</span>
          <span>{heroName}</span>
        </div>

        {/* Speech bubble */}
        <div className={`speech-bubble speech-bubble-hero ${activeSide === "hero" ? "speech-bubble-active-hero" : ""}`}>
          <div className="speech-bubble-tail speech-bubble-tail-left" />
          <p className="speech-bubble-text">
            {typedHero}
            {typedHero.length < displayHero.length && (
              <span className="tw-caret" />
            )}
          </p>
          {activeSide === "hero" && (
            <div className="speech-bubble-footer speech-bubble-footer-hero">
              {streak >= 2 ? "🔥 Combo Strike!" : "✓ Correct!"}
            </div>
          )}
        </div>
      </aside>

      {/* RIGHT: Villain Character Panel */}
      <aside
        className="character-panel character-panel-right"
        aria-label={villainData.panelLabel}
        data-active={activeSide === "villain"}
      >
        {/* Speech bubble (on right, tails point right) */}
        <div className={`speech-bubble speech-bubble-villain ${activeSide === "villain" ? "speech-bubble-active-villain" : ""}`}>
          <div className="speech-bubble-tail speech-bubble-tail-right" />
          <p className="speech-bubble-text">
            {typedVillain}
            {typedVillain.length < displayVillain.length && (
              <span className="tw-caret" style={{ background: villainData.caretColor }} />
            )}
          </p>
          {activeSide === "villain" && (
            <div className="speech-bubble-footer speech-bubble-footer-villain">
              {villainData.activeStatus}
            </div>
          )}
          {activeSide !== "villain" && (
            <div className="speech-bubble-footer speech-bubble-footer-villain" style={{ opacity: 0.5 }}>
              {villainData.idleStatus}
            </div>
          )}
        </div>

        {/* Name tag */}
        <div className={`char-name-tag ${activeSide === "villain" ? villainData.tagActiveClass : villainData.tagClass}`}>
          <span className="char-name-icon">{villainData.icon}</span>
          <span>{villainData.name}</span>
        </div>

        {/* Glow ring */}
        <div
          className={`char-avatar-ring ${activeSide === "villain" ? villainData.ringActiveClass : ""}`}
          style={activeSide === "villain" ? { borderColor: villainData.glowRingColor } : {}}
        >
          <div className="char-burst-container">
            <ParticleBurst active={burstVillain} color={villainData.burstColor} />
            <img
              src={villainData.img}
              alt={villainData.name}
              className="char-avatar-img"
            />
            {activeSide === "villain" && (
              <div className="streak-badge streak-badge-villain animate-bounce">
                💢
              </div>
            )}
          </div>
        </div>
      </aside>
    </>
  );
}
