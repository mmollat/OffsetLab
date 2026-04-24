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

type OverrideMap = Partial<Record<ModelKey, Partial<Record<StyleKey, { front: string; rear: string; frontTire: string; rearTire: string; note: string }>>>>;

const streetSquareOverrides: OverrideMap = {
  "Model 3": {
    oemplus: { front: "19x8.5 +40", rear: "19x8.5 +40", frontTire: "235/40R19", rearTire: "235/40R19", note: "Factory-style square Tesla Model 3 setup." },
    flush: { front: "20x9 +30", rear: "20x9 +30", frontTire: "245/35R20", rearTire: "245/35R20", note: "Square flush alternative for better rotation and balanced handling." },
    aggressive: { front: "20x9 +25", rear: "20x9 +25", frontTire: "245/35R20", rearTire: "245/35R20", note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger." },
  },
  "Model Y": {
    oemplus: { front: "19x9.5 +45", rear: "19x9.5 +45", frontTire: "255/45R19", rearTire: "255/45R19", note: "Factory-style square Tesla Model Y setup." },
    flush: { front: "20x9.5 +35", rear: "20x9.5 +35", frontTire: "265/40R20", rearTire: "265/40R20", note: "Square flush alternative for better rotation and balanced handling." },
    aggressive: { front: "21x9.5 +30", rear: "21x9.5 +30", frontTire: "275/35R21", rearTire: "275/35R21", note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger." },
  },
  "Model S": {
    flush: { front: "21x9.5 +35", rear: "21x9.5 +35", frontTire: "265/35R21", rearTire: "265/35R21", note: "Square alternative for owners prioritizing rotation and balance over rear stagger." },
    aggressive: { front: "21x10 +30", rear: "21x10 +30", frontTire: "275/35R21", rearTire: "275/35R21", note: "Square aggressive alternative for more balanced handling and tire rotation." },
  },
  "Model X": {
    flush: { front: "22x10 +30", rear: "22x10 +30", frontTire: "275/35R22", rearTire: "275/35R22", note: "Square alternative for owners prioritizing rotation and balanced fitment." },
    aggressive: { front: "22x10.5 +28", rear: "22x10.5 +28", frontTire: "285/35R22", rearTire: "285/35R22", note: "Square aggressive alternative for more balanced handling and tire rotation." },
  },
  "M3": {
    oemplus: { front: "19x9.5 ET20", rear: "19x9.5 ET20", frontTire: "275/35R19", rearTire: "275/35R19", note: "BMW M3 OEM+ square setup with factory-like balance and easy rotation." },
    flush: { front: "20x10 ET15", rear: "20x10 ET15", frontTire: "285/30R20", rearTire: "285/30R20", note: "BMW M3 square street setup. Popular for track-minded owners who still want a strong visual stance." },
    aggressive: { front: "20x10 ET12", rear: "20x10 ET12", frontTire: "285/30R20", rearTire: "285/30R20", note: "BMW M3 aggressive square setup prioritizing front-end bite, rotation, and balance." },
  },
  "M4": {
    oemplus: { front: "19x9.5 ET20", rear: "19x9.5 ET20", frontTire: "275/35R19", rearTire: "275/35R19", note: "BMW M4 OEM+ square setup with factory-like balance and easy rotation." },
    flush: { front: "20x10 ET15", rear: "20x10 ET15", frontTire: "285/30R20", rearTire: "285/30R20", note: "BMW M4 square street setup. Popular for track-minded owners who still want a strong visual stance." },
    aggressive: { front: "20x10 ET12", rear: "20x10 ET12", frontTire: "285/30R20", rearTire: "285/30R20", note: "BMW M4 aggressive square setup prioritizing front-end bite, rotation, and balance." },
  },
};

const trackSquareOverrides: OverrideMap = {
  "Model 3": {
    oemplus: { front: "19x9.5 +30", rear: "19x9.5 +30", frontTire: "275/35R19", rearTire: "275/35R19", note: "Most track-focused Model 3 drivers run square setups for balance and tire rotation." },
    flush: { front: "19x9.5 +25", rear: "19x9.5 +25", frontTire: "275/35R19", rearTire: "275/35R19", note: "Track-biased square Model 3 setup with strong balance and repeatability." },
    aggressive: { front: "18x10 +25", rear: "18x10 +25", frontTire: "295/35R18", rearTire: "295/35R18", note: "Aggressive track-focused Model 3 square setup prioritizing grip, rotation, and consistency." },
  },
  "Model Y": {
    oemplus: { front: "19x9.5 +35", rear: "19x9.5 +35", frontTire: "275/40R19", rearTire: "275/40R19", note: "Most track-focused Model Y setups stay square for consistency and tire rotation." },
    flush: { front: "19x9.5 +35", rear: "19x9.5 +35", frontTire: "275/40R19", rearTire: "275/40R19", note: "Track-biased Model Y square setup focused on consistency and balance." },
    aggressive: { front: "20x10 +30", rear: "20x10 +30", frontTire: "285/35R20", rearTire: "285/35R20", note: "Aggressive square Model Y track setup emphasizing front-end support and repeatability." },
  },
  "M3": {
    oemplus: { front: "19x9.5 ET20", rear: "19x9.5 ET20", frontTire: "275/35R19", rearTire: "275/35R19", note: "BMW track setups prioritize rotation and consistency over staggered grip." },
    flush: { front: "19x10 ET25", rear: "19x10 ET25", frontTire: "275/35R19", rearTire: "275/35R19", note: "Track-biased BMW M3 square setup with neutral handling and rotation flexibility." },
    aggressive: { front: "18x10.5 ET20", rear: "18x10.5 ET20", frontTire: "295/35R18", rearTire: "295/35R18", note: "Aggressive BMW M3 square track setup for maximum front-end bite and consistency." },
  },
  "M4": {
    oemplus: { front: "19x9.5 ET20", rear: "19x9.5 ET20", frontTire: "275/35R19", rearTire: "275/35R19", note: "BMW track setups prioritize rotation and consistency over staggered grip." },
    flush: { front: "19x10 ET25", rear: "19x10 ET25", frontTire: "275/35R19", rearTire: "275/35R19", note: "Track-biased BMW M4 square setup with neutral handling and rotation flexibility." },
    aggressive: { front: "18x10.5 ET20", rear: "18x10.5 ET20", frontTire: "295/35R18", rearTire: "295/35R18", note: "Aggressive BMW M4 square track setup for maximum front-end bite and consistency." },
  },
};

function getRecommendedConfiguration(model: ModelKey, goal: DrivingGoalKey): ConfigurationKey {
  if (goal === "track") return "square";
  if (model === "Model 3" || model === "Model Y") return "square";
  return "staggered";
}

function getDisplayedPreset(model: ModelKey, style: StyleKey, goal: DrivingGoalKey, configuration: ConfigurationKey, base: ReturnType<typeof getTrimData>["presets"][StyleKey]): DisplayedPreset {
  if (configuration !== "square") {
    return {
      title: goal === "track" ? `${base.title} • Track Setup` : base.title,
      front: base.front,
      rear: base.rear,
      frontTire: base.frontTire,
      rearTire: base.rearTire,
      verdict: goal === "track"
        ? `${base.verdict} Track mode keeps this staggered layout as an optional performance direction, but square is usually the preferred baseline.`
        : base.verdict,
    };
  }

  const override = (goal === "track" ? trackSquareOverrides : streetSquareOverrides)[model]?.[style];
  if (!override) {
    return {
      title: goal === "track" ? `${base.title} • Track Square` : `${base.title} • Square Setup`,
      front: base.front,
      rear: base.front,
      frontTire: base.frontTire,
      rearTire: base.frontTire,
      verdict: `${base.verdict} Square configuration selected for better rotation and more balanced handling.`,
    };
  }

  return {
    title: goal === "track" ? `${base.title} • Track Square` : `${base.title} • Square Setup`,
    front: override.front,
    rear: override.rear,
    frontTire: override.frontTire,
    rearTire: override.rearTire,
    verdict: `${base.verdict} ${override.note}`,
  };
}

export default function ComparePage() {
  const [make, setMake] = useState<MakeKey>("Tesla");
  const [model, setModel] = useState<ModelKey>("Model S");
  const [trim, setTrim] = useState("Plaid");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [goal, setGoal] = useState<DrivingGoalKey>("street");
  const [configuration, setConfiguration] = useState<ConfigurationKey>("staggered");

  const availableModels = useMemo(() => getModelsForMake(make), [make]);
  const safeModel = availableModels.includes(model) ? model : getDefaultModelForMake(make);
  const trims = useMemo(() => getTrims(safeModel), [safeModel]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(() => getTrimData(safeModel, safeTrim), [safeModel, safeTrim]);
  const current = trimData.presets[style];
  const displayed = useMemo(() => getDisplayedPreset(safeModel, style, goal, configuration, current), [safeModel, style, goal, configuration, current]);

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-6xl">
        <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">Setup Comparison</p>
        <h1 className="mt-2 text-3xl font-bold md:text-4xl">Compare Setup</h1>

        <div className="mt-6 grid gap-4 md:grid-cols-5">
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
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
          >
            {makes.filter((item) => item.active).map((item) => (
              <option key={item.label} value={item.label}>{item.label}</option>
            ))}
          </select>

          <select
            value={safeModel}
            onChange={(e) => {
              const next = e.target.value as ModelKey;
              setModel(next);
              setTrim(getTrims(next)[0]);
              setConfiguration(getRecommendedConfiguration(next, goal));
            }}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
          >
            {availableModels.map((item) => <option key={item} value={item}>{item}</option>)}
          </select>

          <select value={safeTrim} onChange={(e) => setTrim(e.target.value)} className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
            {trims.map((item) => <option key={item} value={item}>{item}</option>)}
          </select>

          <select value={style} onChange={(e) => setStyle(e.target.value as StyleKey)} className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
            <option value="oemplus">OEM+</option>
            <option value="flush">Flush</option>
            <option value="aggressive">Aggressive</option>
          </select>

          <select
            value={goal}
            onChange={(e) => {
              const nextGoal = e.target.value as DrivingGoalKey;
              setGoal(nextGoal);
              setConfiguration(getRecommendedConfiguration(safeModel, nextGoal));
            }}
            className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
          >
            <option value="street">Street</option>
            <option value="track">Track</option>
          </select>
        </div>

        <div className="mt-4 grid gap-4 md:grid-cols-2">
          <button
            onClick={() => setConfiguration("staggered")}
            className={`rounded-2xl border p-4 text-left ${configuration === "staggered" ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30"}`}
          >
            <p className="font-semibold">Staggered</p>
            <p className="mt-1 text-sm text-white/45">{goal === "track" ? "Optional for track use" : "Rear traction + stronger stance"}</p>
          </button>
          <button
            onClick={() => setConfiguration("square")}
            className={`rounded-2xl border p-4 text-left ${configuration === "square" ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30"}`}
          >
            <p className="font-semibold">Square Setup</p>
            <p className="mt-1 text-sm text-white/45">{goal === "track" ? "Preferred for track balance + rotation" : "Balanced handling + tire rotation"}</p>
          </button>
        </div>

        <div className="mt-8 grid gap-6 md:grid-cols-2">
          <Card title="OEM" a={`Front: ${trimData.baseline.front}`} b={`Rear: ${trimData.baseline.rear}`} c={trimData.baseline.tire} />
          <Card title="Recommended" a={`Front: ${displayed.front}`} b={`Rear: ${displayed.rear}`} c={`${displayed.frontTire} / ${displayed.rearTire}`} />
        </div>

        <div className="mt-6">
          <CompareFitmentVisual
            oemFront={trimData.baseline.front}
            selectedFront={displayed.front}
            oemRear={trimData.baseline.rear}
            selectedRear={displayed.rear}
            selectedLabel={displayed.title}
          />
        </div>

        <div className="mt-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Summary</p>
          <p className="mt-4 text-lg leading-8 text-white/80">{displayed.verdict}</p>
        </div>
      </div>
    </main>
  );
}

function Card({ title, a, b, c }: { title: string; a: string; b: string; c: string }) {
  return <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6"><p className="text-sm uppercase tracking-wide text-white/40">{title}</p><p className="mt-5 text-2xl font-bold">{a}</p><p className="mt-2 text-2xl font-bold">{b}</p><p className="mt-3 text-white/60">{c}</p></section>;
}
