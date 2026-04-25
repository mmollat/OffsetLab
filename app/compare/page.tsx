"use client";

import { useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
import {
  getDefaultModelForMake,
  getModelsForMake,
  getTrimData,
  getTrims,
  makes,
  MakeKey,
  ModelKey,
  StyleKey,
} from "../data/fitment";

type ConfigurationKey = "staggered" | "square";
type DrivingGoalKey = "street" | "track";

type DisplayedPreset = {
  title: string;
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  verdict: string;
};

type OverrideMap = Partial<
  Record<
    ModelKey,
    Partial<
      Record<
        StyleKey,
        {
          front: string;
          rear: string;
          frontTire: string;
          rearTire: string;
          note: string;
        }
      >
    >
  >
>;

/* -----------------------------
   EXISTING OVERRIDES (UNCHANGED)
------------------------------ */

const streetSquareOverrides: OverrideMap = {
  "Model 3": {
    oemplus: { front: "19x8.5 +40", rear: "19x8.5 +40", frontTire: "235/40R19", rearTire: "235/40R19", note: "Factory-style square Tesla Model 3 setup." },
    flush: { front: "20x9 +30", rear: "20x9 +30", frontTire: "245/35R20", rearTire: "245/35R20", note: "Square flush alternative for better rotation and balanced handling." },
    aggressive: { front: "20x9 +25", rear: "20x9 +25", frontTire: "245/35R20", rearTire: "245/35R20", note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger." },
  },
};

const trackSquareOverrides: OverrideMap = {
  "Model 3": {
    oemplus: { front: "19x9.5 +30", rear: "19x9.5 +30", frontTire: "275/35R19", rearTire: "275/35R19", note: "Track-focused square setup." },
    flush: { front: "19x9.5 +25", rear: "19x9.5 +25", frontTire: "275/35R19", rearTire: "275/35R19", note: "Track-biased square setup." },
    aggressive: { front: "18x10 +25", rear: "18x10 +25", frontTire: "295/35R18", rearTire: "295/35R18", note: "Aggressive track setup." },
  },
};

/* -----------------------------
   LOGIC (UNCHANGED CORE)
------------------------------ */

function getRecommendedConfiguration(model: ModelKey, goal: DrivingGoalKey): ConfigurationKey {
  if (goal === "track") return "square";
  if (model === "Model 3" || model === "Model Y") return "square";
  return "staggered";
}

function getDisplayedPreset(
  model: ModelKey,
  style: StyleKey,
  goal: DrivingGoalKey,
  configuration: ConfigurationKey,
  base: ReturnType<typeof getTrimData>["presets"][StyleKey]
): DisplayedPreset {
  if (configuration !== "square") {
    return {
      title: goal === "track" ? `${base.title} • Track Setup` : base.title,
      front: base.front,
      rear: base.rear,
      frontTire: base.frontTire,
      rearTire: base.rearTire,
      verdict: base.verdict,
    };
  }

  const override =
    (goal === "track" ? trackSquareOverrides : streetSquareOverrides)[model]?.[style];

  if (!override) {
    return {
      title: `${base.title} • Square`,
      front: base.front,
      rear: base.front,
      frontTire: base.frontTire,
      rearTire: base.frontTire,
      verdict: `${base.verdict} Square setup selected.`,
    };
  }

  return {
    title: `${base.title} • Square`,
    front: override.front,
    rear: override.rear,
    frontTire: override.frontTire,
    rearTire: override.rearTire,
    verdict: `${base.verdict} ${override.note}`,
  };
}

/* -----------------------------
   PAGE
------------------------------ */

export default function ComparePage() {
  const [make, setMake] = useState<MakeKey>("Tesla");
  const [model, setModel] = useState<ModelKey>("Model S");
  const [trim, setTrim] = useState("Plaid");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [goal, setGoal] = useState<DrivingGoalKey>("street");
  const [configuration, setConfiguration] = useState<ConfigurationKey>("staggered");

  /* ---------- SAFE MODEL ---------- */
  const availableModels = useMemo(() => getModelsForMake(make), [make]);
  const safeModel = availableModels.includes(model)
    ? model
    : getDefaultModelForMake(make);

  /* ---------- SAFE TRIM ---------- */
  const trims = useMemo(() => getTrims(safeModel), [safeModel]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];

  /* ---------- TRIM DATA (KEY FIX) ---------- */
  const trimData = useMemo(
    () => getTrimData(safeModel, safeTrim),
    [safeModel, safeTrim]
  );

  /* ---------- PRESET ---------- */
  const currentPreset = trimData.presets[style];

  const displayed = useMemo(
    () =>
      getDisplayedPreset(
        safeModel,
        style,
        goal,
        configuration,
        currentPreset
      ),
    [safeModel, style, goal, configuration, currentPreset]
  );

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-6xl">

        {/* CONTROLS */}
        <div className="mt-6 grid gap-4 md:grid-cols-5">

          {/* MAKE */}
          <select
            value={make}
            onChange={(e) => {
              const nextMake = e.target.value as MakeKey;
              const nextModel = getDefaultModelForMake(nextMake);

              setMake(nextMake);
              setModel(nextModel);
              setTrim(getTrims(nextModel)[0]);
              setConfiguration(getRecommendedConfiguration(nextModel, goal));
            }}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3"
          >
            {makes.filter((m) => m.active).map((m) => (
              <option key={m.label} value={m.label}>{m.label}</option>
            ))}
          </select>

          {/* MODEL */}
          <select
            value={safeModel}
            onChange={(e) => {
              const next = e.target.value as ModelKey;
              setModel(next);
              setTrim(getTrims(next)[0]);
              setConfiguration(getRecommendedConfiguration(next, goal));
            }}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3"
          >
            {availableModels.map((m) => (
              <option key={m} value={m}>{m}</option>
            ))}
          </select>

          {/* TRIM */}
          <select
            value={safeTrim}
            onChange={(e) => setTrim(e.target.value)}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3"
          >
            {trims.map((t) => (
              <option key={t} value={t}>{t}</option>
            ))}
          </select>

          {/* STYLE */}
          <select
            value={style}
            onChange={(e) => setStyle(e.target.value as StyleKey)}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3"
          >
            <option value="oemplus">OEM+</option>
            <option value="flush">Flush</option>
            <option value="aggressive">Aggressive</option>
          </select>

          {/* GOAL */}
          <select
            value={goal}
            onChange={(e) => {
              const next = e.target.value as DrivingGoalKey;
              setGoal(next);
              setConfiguration(getRecommendedConfiguration(safeModel, next));
            }}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3"
          >
            <option value="street">Street</option>
            <option value="track">Track</option>
          </select>
        </div>

        {/* CARDS */}
        <div className="mt-8 grid gap-6 md:grid-cols-2">
          <Card
            title="OEM (Trim-Based)"
            a={`Front: ${trimData.baseline.front}`}
            b={`Rear: ${trimData.baseline.rear}`}
            c={trimData.baseline.tire}
          />

          <Card
            title="Selected Setup"
            a={`Front: ${displayed.front}`}
            b={`Rear: ${displayed.rear}`}
            c={`${displayed.frontTire} / ${displayed.rearTire}`}
          />
        </div>

        {/* VISUAL (NOW TRIM ACCURATE) */}
        <div className="mt-6">
          <CompareFitmentVisual
            oemFront={trimData.baseline.front}
            oemRear={trimData.baseline.rear}
            selectedFront={displayed.front}
            selectedRear={displayed.rear}
            selectedLabel={displayed.title}
          />
        </div>

        {/* SUMMARY */}
        <div className="mt-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Summary</p>
          <p className="mt-4 text-lg text-white/80">{displayed.verdict}</p>
        </div>
      </div>
    </main>
  );
}

/* -----------------------------
   CARD
------------------------------ */

function Card({ title, a, b, c }: { title: string; a: string; b: string; c: string }) {
  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <p className="text-sm uppercase tracking-wide text-white/40">{title}</p>
      <p className="mt-5 text-2xl font-bold">{a}</p>
      <p className="mt-2 text-2xl font-bold">{b}</p>
      <p className="mt-3 text-white/60">{c}</p>
    </section>
  );
}
