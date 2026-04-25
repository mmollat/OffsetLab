"use client";

import { useEffect, useMemo, useState } from "react";
import GalleryCard from "../components/GalleryCard";
import TrustStrip from "../components/TrustStrip";
import SubmitBuildModal from "../components/SubmitBuildModal";
import { supabase } from "../lib/supabase";
import { galleryExamples } from "../data/gallery";
import {
  getDefaultModelForMake,
  getModelsForMake,
  getTrimData,
  getTrims,
  makes,
  MakeKey,
  ModelKey,
  modelSlug,
  normalizeMake,
  normalizeModel,
  normalizeStyle,
  StyleKey,
} from "../data/fitment";

type ConfigurationKey = "staggered" | "square";
type DrivingGoalKey = "street" | "track";

type SquareOverride = {
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  note?: string;
};

type GoalOverrideMap = Partial<Record<ModelKey, Partial<Record<StyleKey, SquareOverride>>>>;

const squareOverrides: GoalOverrideMap = {
  "Model 3": {
    oemplus: {
      front: "20x8.5 +35",
      rear: "20x8.5 +35",
      frontTire: "235/35R20",
      rearTire: "235/35R20",
      note: "Factory-style square Tesla Model 3 setup.",
    },
    flush: {
      front: "19x9.5 +30",
      rear: "19x9.5 +30",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Square flush alternative for better rotation and balanced handling.",
    },
    aggressive: {
      front: "19x10 +25",
      rear: "19x10 +25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger.",
    },
  },
  "Model Y": {
    oemplus: {
      front: "21x9.5 +40",
      rear: "21x9.5 +40",
      frontTire: "255/35R21",
      rearTire: "255/35R21",
      note: "Factory-style square Tesla Model Y setup.",
    },
    flush: {
      front: "20x9.5 +35",
      rear: "20x9.5 +35",
      frontTire: "265/40R20",
      rearTire: "265/40R20",
      note: "Square flush alternative for better rotation and balanced handling.",
    },
    aggressive: {
      front: "21x9.5 +30",
      rear: "21x9.5 +30",
      frontTire: "275/35R21",
      rearTire: "275/35R21",
      note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger.",
    },
  },
  "Model S": {
    flush: {
      front: "21x9.5 +35",
      rear: "21x9.5 +35",
      frontTire: "265/35R21",
      rearTire: "265/35R21",
      note: "Square alternative for owners prioritizing rotation and balance over rear stagger.",
    },
    aggressive: {
      front: "21x10 +30",
      rear: "21x10 +30",
      frontTire: "275/35R21",
      rearTire: "275/35R21",
      note: "Square aggressive alternative for more balanced handling and tire rotation.",
    },
  },
  "Model X": {
    flush: {
      front: "22x10 +30",
      rear: "22x10 +30",
      frontTire: "275/35R22",
      rearTire: "275/35R22",
      note: "Square alternative for owners prioritizing rotation and balanced fitment.",
    },
    aggressive: {
      front: "22x10.5 +28",
      rear: "22x10.5 +28",
      frontTire: "285/35R22",
      rearTire: "285/35R22",
      note: "Square aggressive alternative for more balanced handling and tire rotation.",
    },
  },
  "M3": {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW M3 OEM+ square setup with factory-like balance and easy rotation.",
    },
    flush: {
      front: "20x10 ET15",
      rear: "20x10 ET15",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M3 square street setup. Popular for track-minded owners who still want a strong visual stance.",
    },
    aggressive: {
      front: "20x10 ET12",
      rear: "20x10 ET12",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M3 aggressive square setup prioritizing front-end bite, rotation, and balance.",
    },
  },
  "M4": {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW M4 OEM+ square setup with factory-like balance and easy rotation.",
    },
    flush: {
      front: "20x10 ET15",
      rear: "20x10 ET15",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M4 square street setup. Popular for track-minded owners who still want a strong visual stance.",
    },
    aggressive: {
      front: "20x10 ET12",
      rear: "20x10 ET12",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M4 aggressive square setup prioritizing front-end bite, rotation, and balance.",
    },
  },
};

const trackOverrides: GoalOverrideMap = {
  "Model 3": {
    oemplus: {
      front: "19x9.5 +30",
      rear: "19x9.5 +30",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Most track-focused Model 3 drivers run square setups for balance and tire rotation.",
    },
    flush: {
      front: "19x9.5 +25",
      rear: "19x9.5 +25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased square Model 3 setup with strong balance and repeatability.",
    },
    aggressive: {
      front: "18x10 +25",
      rear: "18x10 +25",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive track-focused Model 3 square setup prioritizing grip, rotation, and consistency.",
    },
  },
  "Model Y": {
    oemplus: {
      front: "19x9.5 +35",
      rear: "19x9.5 +35",
      frontTire: "275/40R19",
      rearTire: "275/40R19",
      note: "Most track-focused Model Y setups stay square for consistency and tire rotation.",
    },
    flush: {
      front: "19x9.5 +35",
      rear: "19x9.5 +35",
      frontTire: "275/40R19",
      rearTire: "275/40R19",
      note: "Track-biased Model Y square setup focused on consistency and balance.",
    },
    aggressive: {
      front: "20x10 +30",
      rear: "20x10 +30",
      frontTire: "285/35R20",
      rearTire: "285/35R20",
      note: "Aggressive square Model Y track setup emphasizing front-end support and repeatability.",
    },
  },
  "M3": {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW track setups prioritize rotation and consistency over staggered grip.",
    },
    flush: {
      front: "19x10 ET25",
      rear: "19x10 ET25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased BMW M3 square setup with neutral handling and rotation flexibility.",
    },
    aggressive: {
      front: "18x10.5 ET20",
      rear: "18x10.5 ET20",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive BMW M3 square track setup for maximum front-end bite and consistency.",
    },
  },
  "M4": {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW track setups prioritize rotation and consistency over staggered grip.",
    },
    flush: {
      front: "19x10 ET25",
      rear: "19x10 ET25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased BMW M4 square setup with neutral handling and rotation flexibility.",
    },
    aggressive: {
      front: "18x10.5 ET20",
      rear: "18x10.5 ET20",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive BMW M4 square track setup for maximum front-end bite and consistency.",
    },
  },
};

function getRecommendedConfiguration(model: ModelKey, goal: DrivingGoalKey = "street"): ConfigurationKey {
  if (goal === "track") return "square";
  if (model === "Model 3" || model === "Model Y") return "square";
  return "staggered";
}

function getConfigurationHint(model: ModelKey, configuration: ConfigurationKey, goal: DrivingGoalKey) {
  const recommended = getRecommendedConfiguration(model, goal);

  if (goal === "track") {
    if (configuration === "square") return "Track-preferred • Rotation-friendly • Balanced handling";
    return "Track-optional • More rear traction • Can increase understeer";
  }

  if (configuration === "square") {
    if (recommended === "square") return "Factory default • Rotation-friendly • Balanced handling";
    return "Rotation-friendly • Balanced handling • Popular for track use";
  }

  if (recommended === "staggered") return "Factory default • More rear traction • Stronger stance";
  return "Optional for this platform • More rear traction • Stronger stance";
}

function getGoalMessage(make: MakeKey) {
  if (make === "BMW") return "Track setups prioritize rotation and consistency over staggered grip.";
  if (make === "Tesla") return "Most track drivers run square setups for balance and tire rotation.";
  return "Track setups prioritize performance, balance, and repeatability.";
}

function scoreColor(score: number) {
  if (score >= 8) return "text-red-400";
  if (score >= 6) return "text-yellow-300";
  return "text-emerald-400";
}

function riskPill(risk: string) {
  if (risk.toLowerCase().includes("moderate")) return "bg-yellow-500/15 text-yellow-300 border-yellow-500/30";
  if (risk.toLowerCase().includes("high")) return "bg-red-500/15 text-red-300 border-red-500/30";
  return "bg-emerald-500/15 text-emerald-300 border-emerald-500/30";
}

export default function FitmentPage() {
  const [make, setMake] = useState<MakeKey>("Tesla");
  const [model, setModel] = useState<ModelKey>("Model S");
  const [trim, setTrim] = useState("Plaid");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [goal, setGoal] = useState<DrivingGoalKey>("street");
  const [configuration, setConfiguration] = useState<ConfigurationKey>("staggered");
  const [copied, setCopied] = useState(false);
  const [submitOpen, setSubmitOpen] = useState(false);
  const [approvedBuilds, setApprovedBuilds] = useState<any[]>([]);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const urlMake = normalizeMake(params.get("make"));
    const urlModel = normalizeModel(params.get("model"), urlMake);
    const urlStyle = normalizeStyle(params.get("style"));
    const urlTrim = params.get("trim");
    const urlGoal = params.get("goal");
    const initialGoal: DrivingGoalKey = urlGoal === "track" ? "track" : "street";
    const urlConfiguration = params.get("configuration");
    const recommendedConfiguration = getRecommendedConfiguration(urlModel, initialGoal);

    setMake(urlMake);
    setModel(urlModel);
    setStyle(urlStyle);
    setGoal(initialGoal);
    setConfiguration(urlConfiguration === "square" || urlConfiguration === "staggered" ? (urlConfiguration as ConfigurationKey) : recommendedConfiguration);

    const availableTrims = getTrims(urlModel);
    setTrim(urlTrim && availableTrims.includes(urlTrim) ? urlTrim : availableTrims[0]);
  }, []);

  const availableModels = useMemo(() => getModelsForMake(make), [make]);
  const safeModel = availableModels.includes(model) ? model : getDefaultModelForMake(make);
  const trims = useMemo(() => getTrims(safeModel), [safeModel]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(() => getTrimData(safeModel, safeTrim), [safeModel, safeTrim]);
  const current = trimData.presets[style];

  const displayedFitment = useMemo(() => {
    if (configuration !== "square") return current;

    const override = (goal === "track" ? trackOverrides : squareOverrides)[safeModel]?.[style];
    const squareWheel = override?.front ?? current.front;
    const squareRearWheel = override?.rear ?? squareWheel;
    const squareTire = override?.frontTire ?? current.frontTire;
    const squareRearTire = override?.rearTire ?? squareTire;
    const note = override?.note ?? "Square setup selected: same wheel and tire sizing front and rear for simpler rotation and a more balanced configuration.";
    const goalPrefix = goal === "track" ? "Track Setup" : "Square Setup";
    const goalSubtitle = goal === "track" ? "Performance-focused square configuration" : "Same size front and rear";

    return {
      ...current,
      title: `${current.title} • ${goalPrefix}`,
      subtitle: `${current.subtitle} • ${goalSubtitle}`,
      front: squareWheel,
      rear: squareRearWheel,
      frontTire: squareTire,
      rearTire: squareRearTire,
      pokeRear: current.pokeFront,
      innerRear: current.innerFront,
      verdict: `${current.verdict} ${note}${goal === "track" ? ` ${getGoalMessage(make)}` : ""}`,
      warnings: Array.from(
        new Set([
          ...current.warnings,
          goal === "track"
            ? "Track mode uses performance-biased square presets where available."
            : "Square setup selected with platform-aware same-size front/rear specs.",
        ])
      ),
      alternate: current.alternate,
    };
  }, [configuration, current, safeModel, style, goal, make]);

  const sourceRank: Record<string, number> = {
    official: 1,
    wheelBrand: 2,
    community: 3,
  };

  const configurationTag = configuration === "square" ? "Square" : "Staggered";

  const referenceBuilds = (galleryExamples[safeModel]?.[style] ?? []).filter((build) => {
    const matchesModel =
      build.tags?.includes(safeModel) ||
      build.label.toLowerCase().includes(safeModel.toLowerCase());

    const hasSquareTag = build.tags?.includes("Square");
    const hasStaggeredTag = build.tags?.includes("Staggered");
    const looksStaggered = build.wheel.includes("/") || build.tags?.includes("Wide Rear");

    const matchesConfiguration =
      build.tags?.includes(configurationTag) ||
      (!hasSquareTag && !hasStaggeredTag && configuration === "staggered" && looksStaggered) ||
      build.match === "Pending Verified Photo";

    return matchesModel && matchesConfiguration && Boolean(build.imageUrl);
  });

  const communityBuilds = approvedBuilds;

  const rawBuilds = [...referenceBuilds, ...communityBuilds];

  const builds = [...rawBuilds].sort(
    (a, b) =>
      (sourceRank[a.sourceType || "community"] ?? 99) -
      (sourceRank[b.sourceType || "community"] ?? 99)
  );

  useEffect(() => {
    const params = new URLSearchParams();
    params.set("make", make.toLowerCase());
    params.set("model", modelSlug(safeModel));
    params.set("trim", safeTrim);
    params.set("style", style);
    params.set("goal", goal);
    params.set("configuration", configuration);
    window.history.replaceState({}, "", `${window.location.pathname}?${params.toString()}`);
  }, [make, safeModel, safeTrim, style, goal, configuration]);

  useEffect(() => {
    let cancelled = false;

    async function loadApprovedBuilds() {
      setApprovedBuilds([]);

      try {
        const normalize = (value: string) =>
          value
            .toLowerCase()
            .trim()
            .replace(/\s+/g, " ")
            .replace("oem+", "oemplus");

        const expectedStyle =
          goal === "track"
            ? configuration === "square"
              ? `${style} track square`
              : `${style} track staggered`
            : configuration === "square"
              ? `${style} square`
              : style;

        const normalizedStyle = normalize(expectedStyle);

        const { data, error } = await supabase
          .from("build_submissions")
          .select("id, make, model, trim, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, image_url, notes, instagram_handle")
          .eq("status", "approved")
          .eq("model", safeModel)
          .eq("trim", safeTrim);

        if (cancelled) return;

        if (error || !data) {
          setApprovedBuilds([]);
          return;
        }

        const filtered = data.filter((row) => {
          const rowStyle = normalize(String(row.fitment_style || ""));
          return rowStyle === normalizedStyle;
        });

        const mapped = filtered
          .filter((row) => row && row.image_url)
          .map((row) => ({
            label: `${String(row.model || "")} ${String(row.trim || "")}`.trim(),
            imageUrl: String(row.image_url || ""),
            imageStatus: "verified" as const,
            sourceType: "community" as const,
            sourceName: row.instagram_handle ? `@${String(row.instagram_handle).replace(/^@/, "")}` : "Offset Lab Community",
            sourceUrl: row.instagram_handle ? `https://instagram.com/${String(row.instagram_handle).replace(/^@/, "")}` : "#",
            wheel: `${String(row.front_wheel || "")}${row.rear_wheel && row.rear_wheel !== row.front_wheel ? ` / ${String(row.rear_wheel)}` : ""}`,
            tire: `${String(row.front_tire || "")}${row.rear_tire && row.rear_tire !== row.front_tire ? ` / ${String(row.rear_tire)}` : ""}`,
            suspension: "User submitted build",
            note: String(row.notes || "Approved community build"),
            verificationNote: "Approved community-submitted build matched to this exact model, trim, style, goal, and configuration.",
            tags: [String(row.model || safeModel), String(expectedStyle), "Community"],
            match: "Verified Spec Match" as const,
          }));

        setApprovedBuilds(mapped);
      } catch (err) {
        if (!cancelled) {
          console.error("Approved build load failed:", err);
          setApprovedBuilds([]);
        }
      }
    }

    loadApprovedBuilds();

    return () => {
      cancelled = true;
    };
  }, [safeModel, safeTrim, style, goal, configuration]);

  async function copyLink() {
    await navigator.clipboard.writeText(window.location.href);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  }

  async function shareBuild() {
    const data = {
      title: "Offset Lab",
      text: `${safeModel} ${safeTrim} • ${displayedFitment.title}`,
      url: window.location.href,
    };

    if (navigator.share) await navigator.share(data);
    else await copyLink();
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">Offset Lab Gallery</p>
          <h1 className="mt-2 text-3xl font-bold md:text-5xl">
            {safeModel} {safeTrim} <span className="text-emerald-400">| {displayedFitment.title}</span>
          </h1>
          <p className="mt-3 text-white/55">
            Real-world visual references paired with specs, scores, and fitment notes.
          </p>
        </div>

        <div className="grid gap-6 lg:grid-cols-[320px_1fr]">
          <aside className="space-y-5">
            <Panel title="1. Select Make">
              <div className="flex flex-wrap gap-2">
{makes.map((item) => {
  const isSelected = make === item.label;

  return (
    <button
      key={item.label}
      disabled={!item.active}
      onClick={() => {
        if (!item.active) return;
        setMake(item.label);
        const nextModel = getDefaultModelForMake(item.label);
        setModel(nextModel);
        setTrim(getTrims(nextModel)[0]);
        setConfiguration(getRecommendedConfiguration(nextModel, goal));
      }}
      className={`rounded-xl border px-3 py-2 text-sm transition ${
        !item.active
          ? "border-white/10 bg-white/[0.02] text-white/45"
          : isSelected
            ? "border-emerald-400/60 bg-emerald-400/15 text-white"
            : "border-white/10 bg-black/30 text-white/70 hover:border-white/25"
      }`}
    >
      {item.label}
      {!item.active ? " • Soon" : ""}
    </button>
  );
})}
              </div>
            </Panel>

            <Panel title="2. Select Vehicle">
              <div className="space-y-3">
                <select
                  value={safeModel}
                  onChange={(e) => {
                    const next = e.target.value as ModelKey;
                    setModel(next);
                    setTrim(getTrims(next)[0]);
                    setConfiguration(getRecommendedConfiguration(next, goal));
                  }}
                  className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
                >
                  {availableModels.map((item) => (
                    <option key={item} value={item}>
                      {item}
                    </option>
                  ))}
                </select>

                <select
                  value={safeTrim}
                  onChange={(e) => setTrim(e.target.value)}
                  className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
                >
                  {trims.map((item) => (
                    <option key={item} value={item}>
                      {item}
                    </option>
                  ))}
                </select>
              </div>
            </Panel>

            <Panel title="3. Select Style">
              <div className="space-y-2">
                {([
                  ["oemplus", "OEM+", "Subtle & Clean"],
                  ["flush", "Flush", "Balanced stance"],
                  ["aggressive", "Aggressive", "Max fitment"],
                ] as const).map(([key, label, sub]) => (
                  <button
                    key={key}
                    onClick={() => setStyle(key)}
                    className={`w-full rounded-2xl border p-4 text-left transition ${style === key ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30 hover:border-white/25"}`}
                  >
                    <p className="font-semibold">{label}</p>
                    <p className="mt-1 text-sm text-white/45">{sub}</p>
                  </button>
                ))}
              </div>
            </Panel>

            <Panel title="4. Driving Goal">
              <div className="space-y-2">
                {([
                  ["street", "Street", "Visual stance + daily usability"],
                  ["track", "Track", "Performance + balance"],
                ] as const).map(([key, label, sub]) => (
                  <button
                    key={key}
                    onClick={() => {
                      setGoal(key);
                      setConfiguration(getRecommendedConfiguration(safeModel, key));
                    }}
                    className={`w-full rounded-2xl border p-4 text-left transition ${goal === key ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30 hover:border-white/25"}`}
                  >
                    <p className="font-semibold">{label}</p>
                    <p className="mt-1 text-sm text-white/45">{sub}</p>
                  </button>
                ))}
              </div>
              {goal === "track" ? <p className="mt-4 text-sm text-emerald-200/80">{getGoalMessage(make)}</p> : null}
            </Panel>

            <Panel title="5. Configuration">
              <div className="space-y-2">
                {([
                  ["staggered", "Staggered", getConfigurationHint(safeModel, "staggered", goal)],
                  ["square", "Square Setup", getConfigurationHint(safeModel, "square", goal)],
                ] as const).map(([key, label, sub]) => (
                  <button
                    key={key}
                    onClick={() => setConfiguration(key)}
                    className={`w-full rounded-2xl border p-4 text-left transition ${configuration === key ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30 hover:border-white/25"}`}
                  >
                    <p className="font-semibold">{label}</p>
                    <p className="mt-1 text-sm text-white/45">{sub}</p>
                  </button>
                ))}
              </div>
            </Panel>

            <Panel title="6. Your Fitment">
              <div className="space-y-4">
                <FitLine label="Front" wheel={displayedFitment.front} tire={displayedFitment.frontTire} />
                <FitLine label="Rear" wheel={displayedFitment.rear} tire={displayedFitment.rearTire} />
              </div>
              <button onClick={copyLink} className="mt-5 w-full rounded-2xl border border-white/15 px-4 py-3 text-sm font-semibold hover:bg-white/5">
                {copied ? "Link Copied" : "Copy Link"}
              </button>
              <button onClick={shareBuild} className="mt-3 w-full rounded-2xl bg-emerald-400 px-4 py-3 text-sm font-bold text-black hover:bg-emerald-300">
                Share Build
              </button>
            </Panel>

            <Panel title="Fitment Summary">
              <div className="space-y-3 text-sm text-white/70">
                <p>
                  Risk: <span className={`rounded-full border px-2 py-1 ${riskPill(displayedFitment.risk)}`}>{displayedFitment.risk}</span>
                </p>
                <p>
                  Visual Aggression: <span className={scoreColor(displayedFitment.aggression)}>{displayedFitment.aggression}/10</span>
                </p>
                <p>
                  Daily Drivability: <span className={scoreColor(displayedFitment.daily)}>{displayedFitment.daily}/10</span>
                </p>
                <p>Driving Goal: {goal === "track" ? "Track" : "Street"}</p>
                <p>Configuration: {configuration === "square" ? "Square" : "Staggered"}</p>
                <p>Bolt Pattern: {trimData.baseline.boltPattern}</p>
                <p>Center Bore: {trimData.baseline.centerBore}</p>
              </div>
            </Panel>
          </aside>

          <section>
            <div className="mb-6 grid gap-4 md:grid-cols-3">
              <Metric label="Front Poke" value={displayedFitment.pokeFront} />
              <Metric label="Rear Poke" value={displayedFitment.pokeRear} />
              <Metric label="Diameter" value={displayedFitment.diameter} />
            </div>

            <div className="mb-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Verdict</p>
              <p className="mt-3 text-lg leading-8 text-white/80">{displayedFitment.verdict}</p>
            </div>

            <div className="grid gap-6">
              {builds.length > 0 ? (
                builds.map((build) => <GalleryCard key={build.label} build={build} />)
              ) : (
                <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-6 text-center text-white/50">
                  No verified build yet for this exact setup.
                </div>
              )}
            </div>

            <section className="mt-8 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                <div>
                  <p className="text-xl font-bold">Have a setup like this?</p>
                  <p className="mt-2 text-sm text-white/55">Share your build with the community and get featured.</p>
                </div>
                <button onClick={() => setSubmitOpen(true)} className="rounded-2xl border border-emerald-400/40 px-5 py-3 text-center font-semibold text-emerald-300 hover:bg-emerald-400/10">
                  Submit Your Build
                </button>
              </div>
            </section>

            <TrustStrip />
          </section>
        </div>
      </div>

      <SubmitBuildModal
        open={submitOpen}
        onClose={() => setSubmitOpen(false)}
        defaults={{
          year: "",
          make,
          model: safeModel,
          trim: safeTrim,
          fitmentStyle:
            goal === "track"
              ? configuration === "square"
                ? `${style} track square`
                : `${style} track staggered`
              : configuration === "square"
                ? `${style} square`
                : style,
          frontWheel: displayedFitment.front,
          rearWheel: displayedFitment.rear,
          frontTire: displayedFitment.frontTire,
          rearTire: displayedFitment.rearTire,
        }}
      />
    </main>
  );
}

function Panel({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-5">
      <p className="mb-4 text-sm uppercase tracking-wide text-white/40">{title}</p>
      {children}
    </section>
  );
}

function FitLine({ label, wheel, tire }: { label: string; wheel: string; tire: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
      <p className="text-xs uppercase tracking-wide text-white/40">{label}</p>
      <p className="mt-2 font-semibold text-white">{wheel}</p>
      <p className="mt-1 text-sm text-white/55">{tire}</p>
    </div>
  );
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-5">
      <p className="text-xs uppercase tracking-wide text-white/40">{label}</p>
      <p className="mt-2 text-2xl font-bold">{value}</p>
    </div>
  );
}
