"use client";

import { useEffect, useMemo, useState } from "react";
import GalleryCard from "../components/GalleryCard";
import TrustStrip from "../components/TrustStrip";
import SubmitBuildModal from "../components/SubmitBuildModal";
import FitmentVisualHero from "../components/FitmentVisualHero";
import { supabase } from "../lib/supabase";
import { galleryExamples } from "../data/gallery";
import {
  MakeKey,
  ModelKey,
  modelSlug,
  normalizeStyle,
  StyleKey,
  TrimData,
} from "../data/fitment";
import { getFitmentData } from "../lib/getFitmentData";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { getVehicleTrims, VehicleTrim } from "../lib/getVehicleTrims";

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
      front: "19x9.5 +22",
      rear: "19x9.5 +22",
      frontTire: "265/35R19",
      rearTire: "265/35R19",
      note: "Aggressive square Tesla setup with improved balance, rotation capability, and cleaner real-world street fitment.",
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
  if (model === "Model 3" || model === "Model Y" || model === "Civic") return "square";
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
  return "text-red-500";
}

function riskPill(risk: string) {
  if (risk.toLowerCase().includes("moderate")) return "bg-yellow-500/15 text-yellow-300 border-yellow-500/30";
  if (risk.toLowerCase().includes("high")) return "bg-red-500/15 text-red-300 border-red-500/30";
  return "bg-red-600/15 text-red-400 border-red-600/30";
}

export default function FitmentPage() {
  const [make, setMake] = useState<MakeKey | null>(null);
  const [model, setModel] = useState<ModelKey | null>(null);
  const [trim, setTrim] = useState<string>("");
  const [style, setStyle] = useState<StyleKey>("flush");
  const [goal, setGoal] = useState<DrivingGoalKey>("street");
  const [configuration, setConfiguration] = useState<ConfigurationKey>("staggered");
  const [copied, setCopied] = useState(false);
  const [submitOpen, setSubmitOpen] = useState(false);
  const [approvedBuilds, setApprovedBuilds] = useState<any[]>([]);
  const [fitmentDb, setFitmentDb] = useState<Record<ModelKey, TrimData[]> | null>(null);
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [vehicleTrims, setVehicleTrims] = useState<VehicleTrim[]>([]);
  
  useEffect(() => {
  let cancelled = false;

  async function loadFitmentData() {
    const data = await getFitmentData();
    if (!cancelled) setFitmentDb(data);
  }

  loadFitmentData();

  return () => {
    cancelled = true;
  };
}, []);

useEffect(() => {
  let cancelled = false;

  async function loadVehicleModels() {
    const data = await getVehicleModels();
    if (!cancelled) setVehicleModels(data);
  }

  loadVehicleModels();

  return () => {
    cancelled = true;
  };
}, []);
  useEffect(() => {
  let cancelled = false;

  async function loadVehicleTrims() {
    const data = await getVehicleTrims();
    if (!cancelled) setVehicleTrims(data);
  }

  loadVehicleTrims();

  return () => {
    cancelled = true;
  };
}, []);
  function getLoadedTrims(model: ModelKey, selectedMake: MakeKey | null = make): string[] {
  if (!selectedMake) return [];

  return vehicleTrims
    .filter((item) => item.make === selectedMake && item.model === model)
    .map((item) => item.trim);
}

function getLoadedTrimData(model: ModelKey, trim: string): TrimData | null {
  const entries = fitmentDb?.[model];
  if (!entries || entries.length === 0) return null;
  return entries.find((entry) => entry.trim === trim) ?? entries[0];
}

  useEffect(() => {
  if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) return;
  
  const params = new URLSearchParams(window.location.search);
  const rawMake = params.get("make");

  if (!rawMake) return;

  const urlMake = vehicleModels.find(
    (item) => item.make.toLowerCase() === rawMake.toLowerCase()
  )?.make as MakeKey | undefined;
  if (!urlMake) return;

  const requestedModel = params.get("model");
  const urlModel =
    vehicleModels.find(
      (item) =>
        item.make === urlMake &&
        (modelSlug(item.model) === modelSlug(requestedModel ?? "") ||
          modelSlug(item.display_name ?? "") === modelSlug(requestedModel ?? ""))
    )?.model as ModelKey | undefined;
  const urlStyle = normalizeStyle(params.get("style"));
  const urlTrim = params.get("trim");
  const urlGoal = params.get("goal");
  const initialGoal: DrivingGoalKey = urlGoal === "track" ? "track" : "street";
  const urlConfiguration = params.get("configuration");

  setMake(urlMake);
  setStyle(urlStyle);
  setGoal(initialGoal);
  setModel(urlModel ?? null);

  if (!urlModel) {
    setTrim("");
    return;
  }

  const recommendedConfiguration = getRecommendedConfiguration(urlModel, initialGoal);
  setConfiguration(
    urlConfiguration === "square" || urlConfiguration === "staggered"
      ? (urlConfiguration as ConfigurationKey)
      : recommendedConfiguration
  );

  const availableTrims = getLoadedTrims(urlModel, urlMake);
  setTrim(urlTrim && availableTrims.includes(urlTrim) ? urlTrim : "");
}, [fitmentDb, vehicleModels, vehicleTrims]);

  const availableMakes = useMemo(() => {
  return (Array.from(new Set(vehicleModels.map((vehicle) => vehicle.make))) as MakeKey[]).sort(
    (a, b) => String(a).localeCompare(String(b))
  );
}, [vehicleModels]);

const availableModels = useMemo(() => {
  if (!make) return [];

  return vehicleModels
    .filter((item) => item.make === make)
    .sort((a, b) =>
      (a.display_name ?? a.model).localeCompare(b.display_name ?? b.model, undefined, {
        numeric: true,
        sensitivity: "base",
      })
    )
    .map((item) => item.model as ModelKey);
}, [make, vehicleModels]);

const safeModel =
  make && model && availableModels.includes(model)
    ? model
    : null;
  const trims = useMemo(
  () => (safeModel ? getLoadedTrims(safeModel) : []),
  [safeModel, make, vehicleTrims]
);

const safeTrim =
  trim && trims.includes(trim)
    ? trim
    : "";

const trimData = useMemo(
  () => (safeModel && safeTrim ? getLoadedTrimData(safeModel, safeTrim) : null),
  [safeModel, safeTrim, fitmentDb]
);
  const current = trimData?.presets?.[style];

  const displayedFitment = useMemo(() => {
  if (!current || !safeModel || !make) return null;

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

  const referenceBuilds =
  safeModel && displayedFitment
    ? (galleryExamples[safeModel]?.[style] ?? []).filter((build) => {
    const matchesModel =
      build.tags?.includes(safeModel) ||
      build.label.toLowerCase().includes(safeModel.toLowerCase());

    const hasSquareTag = build.tags?.includes("Square");
    const hasStaggeredTag = build.tags?.includes("Staggered");
    const looksStaggered = build.wheel.includes("/") || build.tags?.includes("Wide Rear");

    const matchesConfiguration =
      build.tags?.includes(configurationTag) ||
      (!hasSquareTag && !hasStaggeredTag && configuration === "staggered" && looksStaggered) ||
      build.match === "Visual Reference";

    return matchesModel && matchesConfiguration;
  })
  : [];

  const communityBuilds: typeof referenceBuilds = [];

  const rawBuilds = [...referenceBuilds, ...communityBuilds];

  const builds = [...rawBuilds].sort(
    (a, b) =>
      (sourceRank[a.sourceType || "community"] ?? 99) -
      (sourceRank[b.sourceType || "community"] ?? 99)
  );

  useEffect(() => {
    if (!make || !safeModel || !safeTrim) return;
    
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
      if (!safeModel) {
  setApprovedBuilds([]);
  return;
}

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
          .eq("model", safeModel);

        if (cancelled) return;

        if (error || !data) {
          setApprovedBuilds([]);
          return;
        }
        const normalizeTrim = (value: string) => {
  const input = value.toLowerCase().replace(/\s+/g, "").trim();

  if (input.includes("typer") || input.includes("ctr")) return "Type R";
  if (input.includes("si") || input.includes("sport")) return "Sport / Si";

  return value;
};
       const filtered = data
  .filter((row) => row && row.image_url)
  .filter((row) => normalizeTrim(String(row.trim || "")) === normalizeTrim(safeTrim));

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
            verificationNote:
  normalize(String(row.fitment_style || "")) === normalizedStyle
    ? "Approved community build closely matched to this model, trim, style, goal, and configuration."
    : "Approved community build used as a visual reference. Specs or setup style may vary slightly.",
tags: [
  String(row.model || safeModel),
  normalize(String(row.fitment_style || "")) === normalizedStyle ? String(expectedStyle) : "Visual Reference",
  "Community",
],
match: normalize(String(row.fitment_style || "")) === normalizedStyle ? "Close Match" as const : "Visual Reference" as const,
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
  if (!safeModel || !safeTrim || !displayedFitment) return;

  const data = {
    title: "Offset Lab",
    text: `${safeModel} ${safeTrim} • ${displayedFitment.title}`,
    url: window.location.href,
  };

  if (navigator.share) await navigator.share(data);
  else await copyLink();
}
if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) {
  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl text-white/60">
        Loading fitment data...
      </div>
    </main>
  );
}
  const selectedModelName =
    vehicleModels.find((item) => item.make === make && item.model === safeModel)?.display_name ??
    safeModel;
  const hasRecommendation = Boolean(make && safeModel && safeTrim && trimData && displayedFitment);
  let compareHref = "/compare";

  if (make && safeModel && safeTrim && displayedFitment) {
    const params = new URLSearchParams({
      make,
      model: safeModel,
      trim: safeTrim,
      style,
      goal,
      configuration,
      front: displayedFitment.front,
      rear: displayedFitment.rear,
      frontTire: displayedFitment.frontTire,
      rearTire: displayedFitment.rearTire,
      title: displayedFitment.title,
      verdict: displayedFitment.verdict,
    });

    compareHref = `/compare?${params.toString()}`;
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050506] text-white">
      <section className="relative isolate overflow-hidden border-b border-white/10">
        <div
          className="absolute inset-0 -z-30 bg-cover bg-[72%_center] md:bg-center"
          style={{ backgroundImage: "url('/fitment-hero.png')" }}
        />
        <div className="absolute inset-0 -z-20 bg-gradient-to-r from-black via-black/85 to-black/10" />
        <div className="absolute inset-0 -z-10 bg-gradient-to-t from-[#050506] via-transparent to-black/30" />

        <div className="mx-auto flex min-h-[410px] max-w-7xl items-center px-5 pb-12 pt-16 lg:min-h-[520px] lg:px-8 lg:pb-36">
          <div className="max-w-2xl">
            <p className="text-xs font-black uppercase tracking-[0.3em] text-red-500">
              Offset Lab Fitment
            </p>
            <h1 className="mt-5 text-5xl font-black leading-[0.96] tracking-[-0.045em] sm:text-6xl">
              Dial In Your
              <span className="block text-red-500">Fitment.</span>
            </h1>
            <p className="mt-6 max-w-xl text-base leading-7 text-white/60 sm:text-lg">
              Vehicle-specific wheel and tire recommendations without the guesswork.
            </p>
          </div>
        </div>

        <div className="relative lg:absolute lg:inset-x-0 lg:bottom-0">
          <div className="mx-auto max-w-7xl px-5 lg:px-8">
            <div className="grid gap-px overflow-hidden rounded-t-xl border border-b-0 border-white/12 bg-white/10 shadow-2xl shadow-black/50 backdrop-blur-xl lg:grid-cols-[1fr_1.4fr_1fr_2.1fr_auto]">
              <Selector label="Make">
                <select
                  value={make ?? ""}
                  onChange={(event) => {
                    const nextMake = event.target.value as MakeKey;
                    setMake(nextMake);
                    setModel(null);
                    setTrim("");
                  }}
                  className="w-full bg-transparent text-sm font-bold outline-none"
                >
                  <option value="" disabled>Select make</option>
                  {availableMakes.map((item) => <option key={item}>{item}</option>)}
                </select>
              </Selector>

              <Selector label="Vehicle">
                <select
                  value={safeModel ?? ""}
                  disabled={!make}
                  onChange={(event) => {
                    const nextModel = event.target.value as ModelKey;
                    setModel(nextModel);
                    setTrim("");
                    setConfiguration(getRecommendedConfiguration(nextModel, goal));
                  }}
                  className="w-full bg-transparent text-sm font-bold outline-none disabled:text-white/30"
                >
                  <option value="" disabled>Select vehicle</option>
                  {availableModels.map((item) => {
                    const entry = vehicleModels.find((vehicle) => vehicle.make === make && vehicle.model === item);
                    return <option key={item} value={item}>{entry?.display_name ?? item}</option>;
                  })}
                </select>
              </Selector>

              <Selector label="Trim">
                <select
                  value={safeTrim}
                  disabled={!safeModel}
                  onChange={(event) => setTrim(event.target.value)}
                  className="w-full bg-transparent text-sm font-bold outline-none disabled:text-white/30"
                >
                  <option value="" disabled>Select trim</option>
                  {vehicleTrims
                    .filter((item) => item.make === make && item.model === safeModel)
                    .map((item) => <option key={item.trim} value={item.trim}>{item.display_name ?? item.trim}</option>)}
                </select>
              </Selector>

              <div className="bg-[#09090b]/95 px-5 py-4">
                <p className="mb-2 text-[10px] font-black uppercase tracking-[0.2em] text-white/35">Style</p>
                <div className="grid grid-cols-3 gap-1 rounded-md border border-white/10 bg-black/35 p-1">
                  {([
                    ["oemplus", "OEM+"],
                    ["flush", "Flush"],
                    ["aggressive", "Aggressive"],
                  ] as const).map(([key, label]) => (
                    <button
                      key={key}
                      onClick={() => setStyle(key)}
                      className={`rounded px-3 py-2 text-xs font-black transition ${
                        style === key ? "bg-red-600 text-white" : "text-white/45 hover:text-white"
                      }`}
                    >
                      {label}
                    </button>
                  ))}
                </div>
              </div>

              <button
                onClick={() => document.getElementById("recommendation")?.scrollIntoView({ behavior: "smooth" })}
                disabled={!hasRecommendation}
                className="min-h-24 bg-red-600 px-7 text-xs font-black uppercase tracking-[0.13em] transition hover:bg-red-500 disabled:cursor-not-allowed disabled:bg-red-950 disabled:text-white/35"
              >
                Build My Setup
              </button>
            </div>
          </div>
        </div>
      </section>

      {!hasRecommendation || !make || !safeModel || !trimData || !displayedFitment ? (
        <section className="mx-auto max-w-7xl px-5 py-20 text-center lg:px-8">
          <p className="text-xs font-black uppercase tracking-[0.25em] text-red-500">Choose Your Platform</p>
          <h2 className="mt-4 text-3xl font-black">Your recommendation starts above.</h2>
          <p className="mx-auto mt-3 max-w-lg text-sm leading-6 text-white/45">
            Select a make, vehicle, trim, and stance style to build a vehicle-specific setup.
          </p>
        </section>
      ) : (
        <>
          <section id="recommendation" className="mx-auto max-w-7xl px-5 py-16 lg:px-8 lg:py-20">
            <div className="flex flex-col gap-5 border-b border-white/10 pb-8 md:flex-row md:items-end md:justify-between">
              <div>
                <p className="text-xs font-black uppercase tracking-[0.25em] text-red-500">Your Recommended Setup</p>
                <h2 className="mt-3 text-3xl font-black tracking-[-0.03em] sm:text-5xl">
                  {displayedFitment.title}
                </h2>
                <p className="mt-3 text-sm text-white/45">
                  {make} <span className="px-2 text-white/20">/</span> {selectedModelName}
                  <span className="px-2 text-white/20">/</span> {safeTrim}
                  <span className="px-2 text-white/20">/</span> {style === "oemplus" ? "OEM+" : style}
                </p>
              </div>
              <span className={`w-fit rounded-full border px-4 py-2 text-[10px] font-black uppercase tracking-[0.18em] ${riskPill(displayedFitment.risk)}`}>
                {displayedFitment.daily >= 7 ? "Daily-Friendly" : "Performance-Focused"}
              </span>
            </div>

            <div className="mt-8 grid gap-5 lg:grid-cols-2">
              <WheelRecommendation
                axle="Front"
                wheel={displayedFitment.front}
                tire={displayedFitment.frontTire}
                poke={displayedFitment.pokeFront}
                inner={displayedFitment.innerFront}
                risk={displayedFitment.risk}
              />
              <WheelRecommendation
                axle="Rear"
                wheel={displayedFitment.rear}
                tire={displayedFitment.rearTire}
                poke={displayedFitment.pokeRear}
                inner={displayedFitment.innerRear}
                risk={displayedFitment.risk}
              />
            </div>

            <div className="mt-5 grid overflow-hidden rounded-xl border border-white/10 bg-white/10 sm:grid-cols-3 sm:gap-px">
              <SummaryMetric label="Outer Poke" value={`${displayedFitment.pokeFront} / ${displayedFitment.pokeRear}`} sub="Front / Rear" />
              <SummaryMetric label="Inner Clearance" value={`${displayedFitment.innerFront} / ${displayedFitment.innerRear}`} sub="Front / Rear" />
              <SummaryMetric label="Diameter Change" value={displayedFitment.diameter} sub={`${trimData.baseline.boltPattern} bolt pattern`} />
            </div>

            <div className="mt-7 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <a href={compareHref} className="text-sm font-bold text-white/65 transition hover:text-red-400">
                Compare against factory -&gt;
              </a>
              <div className="flex gap-3">
                <button onClick={copyLink} className="rounded-md border border-white/15 px-5 py-2.5 text-xs font-black uppercase tracking-[0.12em] hover:bg-white/5">
                  {copied ? "Link Copied" : "Copy Link"}
                </button>
                <button onClick={shareBuild} className="rounded-md bg-red-600 px-5 py-2.5 text-xs font-black uppercase tracking-[0.12em] hover:bg-red-500">
                  Share Build
                </button>
              </div>
            </div>
          </section>

          <section className="border-y border-white/10 bg-[#08080a]">
            <div className="mx-auto grid max-w-7xl gap-5 px-5 py-10 lg:grid-cols-2 lg:px-8">
              <ChoicePanel title="Driving Goal">
                {([
                  ["street", "Street", "Daily usability and visual stance"],
                  ["track", "Track", "Performance, balance, and repeatability"],
                ] as const).map(([key, label, sub]) => (
                  <ChoiceButton
                    key={key}
                    active={goal === key}
                    label={label}
                    sub={sub}
                    onClick={() => {
                      setGoal(key);
                      setConfiguration(getRecommendedConfiguration(safeModel, key));
                    }}
                  />
                ))}
              </ChoicePanel>
              <ChoicePanel title="Wheel Configuration">
                {([
                  ["staggered", "Staggered", getConfigurationHint(safeModel, "staggered", goal)],
                  ["square", "Square", getConfigurationHint(safeModel, "square", goal)],
                ] as const).map(([key, label, sub]) => (
                  <ChoiceButton
                    key={key}
                    active={configuration === key}
                    label={label}
                    sub={sub}
                    onClick={() => setConfiguration(key)}
                  />
                ))}
              </ChoicePanel>
              {goal === "track" ? (
                <p className="text-sm text-red-300/75 lg:col-span-2">{getGoalMessage(make)}</p>
              ) : null}
            </div>
          </section>

          <section className="mx-auto max-w-7xl px-5 py-16 lg:px-8">
            <div className="mb-7">
              <p className="text-xs font-black uppercase tracking-[0.25em] text-red-500">Visual Analysis</p>
              <h2 className="mt-3 text-3xl font-black tracking-[-0.03em]">See What the Numbers Mean.</h2>
            </div>

            <FitmentVisualHero
              title={displayedFitment.title}
              subtitle={displayedFitment.subtitle}
              frontWheel={displayedFitment.front}
              rearWheel={displayedFitment.rear}
              frontTire={displayedFitment.frontTire}
              rearTire={displayedFitment.rearTire}
              pokeFront={displayedFitment.pokeFront}
              pokeRear={displayedFitment.pokeRear}
              innerFront={displayedFitment.innerFront}
              innerRear={displayedFitment.innerRear}
              aggression={displayedFitment.aggression}
              daily={displayedFitment.daily}
              risk={displayedFitment.risk}
            />

            <div className="mt-6 grid gap-5 lg:grid-cols-2">
              <DetailCard title="Verdict" copy={displayedFitment.verdict} />
              <DetailCard title="Alternate Setup" copy={displayedFitment.alternate} />
            </div>

            {displayedFitment.warnings.length > 0 ? (
              <div className="mt-5 rounded-xl border border-yellow-500/20 bg-yellow-500/[0.05] p-6">
                <p className="text-xs font-black uppercase tracking-[0.2em] text-yellow-300">Fitment Notes</p>
                <div className="mt-3 space-y-2 text-sm leading-6 text-white/58">
                  {displayedFitment.warnings.map((warning) => <p key={warning}>{warning}</p>)}
                </div>
              </div>
            ) : null}
          </section>

          <section className="border-t border-white/10 bg-[#08080a]">
            <div className="mx-auto max-w-7xl px-5 py-16 lg:px-8">
              <div className="mb-8 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                <div>
                  <p className="text-xs font-black uppercase tracking-[0.25em] text-red-500">Visual References</p>
                  <h2 className="mt-3 text-3xl font-black tracking-[-0.03em]">See It on the Car.</h2>
                </div>
                <p className="text-sm text-white/40">{builds.length} matched build{builds.length === 1 ? "" : "s"}</p>
              </div>

              <div className="grid gap-6">
                {builds.length > 0 ? (
                  builds.map((build) => <GalleryCard key={build.label} build={build} />)
                ) : (
                  <div className="rounded-xl border border-white/10 bg-white/[0.03] p-10 text-center text-white/45">
                    No visual reference available yet for this setup.
                  </div>
                )}
              </div>

              <section className="mt-8 rounded-xl border border-white/10 bg-white/[0.03] p-6">
                <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                  <div>
                    <p className="text-xl font-black">Have a setup like this?</p>
                    <p className="mt-2 text-sm text-white/50">Share your build with the community and get featured.</p>
                  </div>
                  <button onClick={() => setSubmitOpen(true)} className="rounded-md border border-red-500/40 px-5 py-3 text-sm font-bold text-red-400 hover:bg-red-500/10">
                    Submit Your Build
                  </button>
                </div>
              </section>

              <TrustStrip />
            </div>
          </section>

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
        </>
      )}
    </main>
  );
}

function Selector({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="bg-[#09090b]/95 px-5 py-4">
      <span className="mb-2 block text-[10px] font-black uppercase tracking-[0.2em] text-white/35">{label}</span>
      {children}
    </label>
  );
}

function WheelRecommendation({
  axle,
  wheel,
  tire,
  poke,
  inner,
  risk,
}: {
  axle: string;
  wheel: string;
  tire: string;
  poke: string;
  inner: string;
  risk: string;
}) {
  const parts = parseWheel(wheel);

  return (
    <article className="relative overflow-hidden rounded-xl border border-white/10 bg-gradient-to-br from-white/[0.065] to-white/[0.015] p-6 sm:p-8">
      <div className="relative flex items-start justify-between gap-5">
        <div className="relative z-10">
          <p className="text-xs font-black uppercase tracking-[0.22em] text-white/42">{axle} Setup</p>
          <div className="mt-6 flex flex-wrap items-end gap-x-3">
            <span className="text-5xl font-black tracking-[-0.05em] sm:text-6xl">{parts.size}</span>
            <span className="pb-1 text-2xl font-black text-red-500">{parts.offset}</span>
          </div>
          <p className="mt-3 text-lg font-bold text-white/68">{tire}</p>
        </div>
        <WheelGraphic />
      </div>

      <div className="relative mt-8 grid grid-cols-3 gap-px overflow-hidden rounded-lg border border-white/10 bg-white/10">
        <CardStat label="Poke" value={poke} />
        <CardStat label="Inner" value={inner} />
        <CardStat label="Risk" value={risk} small />
      </div>
    </article>
  );
}

function parseWheel(value: string) {
  const match = value.match(/^(.+?)\s+((?:ET)?[+-]?\d+)$/i);
  if (!match) return { size: value, offset: "" };
  const rawOffset = match[2];
  const offset = rawOffset.toUpperCase().startsWith("ET") ? rawOffset.toUpperCase() : `${rawOffset}mm`;
  return { size: match[1], offset };
}

function WheelGraphic() {
  const spokes = Array.from({ length: 10 }, (_, index) => index * 36);

  return (
    <div className="pointer-events-none absolute -right-3 -top-4 hidden h-48 w-48 opacity-90 sm:block lg:-right-1 lg:h-52 lg:w-52">
      <svg viewBox="0 0 220 220" aria-hidden="true" className="h-full w-full drop-shadow-[0_12px_22px_rgba(0,0,0,0.7)]">
        <defs>
          <radialGradient id="tireSurface" cx="42%" cy="36%" r="68%">
            <stop offset="0" stopColor="#34343a" />
            <stop offset="0.58" stopColor="#17181c" />
            <stop offset="1" stopColor="#07080a" />
          </radialGradient>
          <radialGradient id="wheelFace" cx="40%" cy="35%" r="70%">
            <stop offset="0" stopColor="#62646b" />
            <stop offset="0.45" stopColor="#292b31" />
            <stop offset="1" stopColor="#0b0c0f" />
          </radialGradient>
          <linearGradient id="spokeMetal" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stopColor="#a8abb2" />
            <stop offset="0.25" stopColor="#45474e" />
            <stop offset="0.68" stopColor="#17191e" />
            <stop offset="1" stopColor="#777980" />
          </linearGradient>
        </defs>

        <circle cx="110" cy="110" r="100" fill="url(#tireSurface)" stroke="#404147" strokeWidth="3" />
        <circle cx="110" cy="110" r="88" fill="none" stroke="#0a0b0e" strokeWidth="11" strokeDasharray="3 5" opacity="0.9" />
        <circle cx="110" cy="110" r="76" fill="#090a0d" stroke="#696b72" strokeWidth="3" />
        <circle cx="110" cy="110" r="68" fill="url(#wheelFace)" stroke="#24262b" strokeWidth="3" />

        <circle cx="110" cy="110" r="53" fill="#17191d" stroke="#4b4d53" strokeWidth="2" />
        <circle cx="110" cy="110" r="45" fill="none" stroke="#6e7076" strokeWidth="2" strokeDasharray="2 5" opacity="0.55" />
        <path d="M148 79 C159 88 163 102 160 119 L150 119 C152 102 149 91 140 84 Z" fill="#d92d35" opacity="0.9" />

        {spokes.map((rotation) => (
          <g key={rotation} transform={`rotate(${rotation} 110 110)`}>
            <path
              d="M104 106 L94 48 Q96 42 103 40 L110 101 Z"
              fill="url(#spokeMetal)"
              stroke="#777980"
              strokeWidth="0.8"
            />
            <path
              d="M116 106 L126 48 Q124 42 117 40 L110 101 Z"
              fill="#202228"
              stroke="#55575e"
              strokeWidth="0.7"
            />
          </g>
        ))}

        <circle cx="110" cy="110" r="22" fill="#121318" stroke="#7b7d84" strokeWidth="2" />
        <circle cx="110" cy="110" r="10" fill="#050609" stroke="#ef4444" strokeWidth="2.5" />
        {[0, 72, 144, 216, 288].map((rotation) => {
          const radians = ((rotation - 90) * Math.PI) / 180;
          return (
            <circle
              key={rotation}
              cx={110 + Math.cos(radians) * 16}
              cy={110 + Math.sin(radians) * 16}
              r="2.2"
              fill="#b5b7bd"
            />
          );
        })}
        <path d="M44 70 A82 82 0 0 1 88 31" fill="none" stroke="white" strokeWidth="2" opacity="0.13" />
        <path d="M33 132 A82 82 0 0 0 58 171" fill="none" stroke="#ef4444" strokeWidth="2" opacity="0.22" />
      </svg>
    </div>
  );
}

function CardStat({ label, value, small = false }: { label: string; value: string; small?: boolean }) {
  return (
    <div className="bg-[#09090b] px-3 py-4">
      <p className="text-[9px] font-black uppercase tracking-[0.17em] text-white/30">{label}</p>
      <p className={`mt-1 font-black text-white/75 ${small ? "text-xs" : "text-base"}`}>{value}</p>
    </div>
  );
}

function SummaryMetric({ label, value, sub }: { label: string; value: string; sub: string }) {
  return (
    <div className="bg-[#09090b] p-5 sm:p-6">
      <p className="text-[10px] font-black uppercase tracking-[0.18em] text-white/32">{label}</p>
      <p className="mt-2 text-xl font-black">{value}</p>
      <p className="mt-1 text-xs text-white/30">{sub}</p>
    </div>
  );
}

function ChoicePanel({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-xl border border-white/10 bg-white/[0.025] p-5">
      <p className="mb-4 text-xs font-black uppercase tracking-[0.2em] text-white/38">{title}</p>
      <div className="grid gap-2 sm:grid-cols-2">{children}</div>
    </div>
  );
}

function ChoiceButton({
  active,
  label,
  sub,
  onClick,
}: {
  active: boolean;
  label: string;
  sub: string;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={`rounded-lg border p-4 text-left transition ${
        active ? "border-red-500/55 bg-red-500/10" : "border-white/10 bg-black/25 hover:border-white/25"
      }`}
    >
      <p className="font-black">{label}</p>
      <p className="mt-1 text-xs leading-5 text-white/42">{sub}</p>
    </button>
  );
}

function DetailCard({ title, copy }: { title: string; copy: string }) {
  return (
    <div className="rounded-xl border border-white/10 bg-white/[0.025] p-6">
      <p className="text-xs font-black uppercase tracking-[0.2em] text-white/38">{title}</p>
      <p className="mt-3 leading-7 text-white/70">{copy}</p>
    </div>
  );
}
