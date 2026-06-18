"use client";

import { useEffect, useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
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

type HandoffSetup = {
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  title: string;
  verdict: string;
};

export default function ComparePage() {
  const [make, setMake] = useState<MakeKey | null>(null);
  const [model, setModel] = useState<ModelKey | null>(null);
  const [trim, setTrim] = useState("");
  const [style, setStyle] = useState<StyleKey>("flush");

  const [fitmentDb, setFitmentDb] = useState<Record<ModelKey, TrimData[]> | null>(null);
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [vehicleTrims, setVehicleTrims] = useState<VehicleTrim[]>([]);
  const [handoffSetup, setHandoffSetup] = useState<HandoffSetup | null>(null);
  const [fitmentContext, setFitmentContext] = useState({
    goal: "street",
    configuration: "staggered",
  });

  useEffect(() => {
    async function loadData() {
      const [fitment, models, trims] = await Promise.all([
        getFitmentData(),
        getVehicleModels(),
        getVehicleTrims(),
      ]);

      setFitmentDb(fitment);
      setVehicleModels(models);
      setVehicleTrims(trims);
    }

    loadData();
  }, []);

  useEffect(() => {
    if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) return;

    const params = new URLSearchParams(window.location.search);
    const rawMake = params.get("make");
    const requestedModel = params.get("model");
    const requestedTrim = params.get("trim");

    if (!rawMake || !requestedModel || !requestedTrim) return;

    const urlMake = vehicleModels.find(
      (item) => item.make.toLowerCase() === rawMake.toLowerCase()
    )?.make as MakeKey | undefined;
    if (!urlMake) return;

    const urlModel = vehicleModels.find(
      (item) =>
        item.make === urlMake &&
        (modelSlug(item.model) === modelSlug(requestedModel) ||
          modelSlug(item.display_name ?? "") === modelSlug(requestedModel))
    )?.model as ModelKey | undefined;
    if (!urlModel) return;

    const trimExists = vehicleTrims.some(
      (item) =>
        item.make === urlMake &&
        item.model === urlModel &&
        item.trim === requestedTrim
    );
    if (!trimExists) return;

    setMake(urlMake);
    setModel(urlModel);
    setTrim(requestedTrim);
    setStyle(normalizeStyle(params.get("style")));
    setFitmentContext({
      goal: params.get("goal") === "track" ? "track" : "street",
      configuration: params.get("configuration") === "square" ? "square" : "staggered",
    });

    const front = params.get("front");
    const rear = params.get("rear");
    const frontTire = params.get("frontTire");
    const rearTire = params.get("rearTire");
    const title = params.get("title");
    const verdict = params.get("verdict");

    setHandoffSetup(
      front && rear && frontTire && rearTire && title && verdict
        ? { front, rear, frontTire, rearTire, title, verdict }
        : null
    );
  }, [fitmentDb, vehicleModels, vehicleTrims]);

  const makes = useMemo(() => {
    return Array.from(new Set(vehicleModels.map((item) => item.make))).sort((a, b) =>
      String(a).localeCompare(String(b))
    );
  }, [vehicleModels]);

  const availableModels = useMemo(() => {
    if (!make) return [];

    return vehicleModels
      .filter((item) => item.make === make)
      .map((item) => item.model as ModelKey);
  }, [make, vehicleModels]);

  const safeModel =
    model && availableModels.includes(model)
      ? model
      : null;

  const trimsForModel = useMemo(() => {
    if (!make || !safeModel) return [];

    return vehicleTrims.filter(
      (item) => item.make === make && item.model === safeModel
    );
  }, [make, safeModel, vehicleTrims]);

  const safeTrim =
    trim && trimsForModel.some((item) => item.trim === trim)
      ? trim
      : "";

  const trimData = useMemo(() => {
    if (!fitmentDb || !safeModel || !safeTrim) return null;

    return (
      fitmentDb[safeModel]?.find((item) => item.trim === safeTrim) ??
      fitmentDb[safeModel]?.[0] ??
      null
    );
  }, [fitmentDb, safeModel, safeTrim]);

  const preset = trimData?.presets?.[style];
  const current = preset && handoffSetup ? { ...preset, ...handoffSetup } : preset;
  const selectedModelLabel =
    vehicleModels.find(
      (vehicle) => vehicle.make === make && vehicle.model === safeModel
    )?.display_name ?? safeModel;

  const selectedTrimLabel =
    trimsForModel.find((item) => item.trim === safeTrim)?.display_name ?? safeTrim;
  const fitmentHref = useMemo(() => {
    if (!make || !safeModel || !safeTrim) return "/fitment";

    const params = new URLSearchParams({
      make,
      model: safeModel,
      trim: safeTrim,
      style,
      goal: fitmentContext.goal,
      configuration: fitmentContext.configuration,
    });

    return `/fitment?${params.toString()}`;
  }, [make, safeModel, safeTrim, style, fitmentContext]);

  if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
        <div className="mx-auto max-w-7xl text-white/60">Loading compare data...</div>
      </main>
    );
  }

  function handleMakeChange(nextMake: string) {
    setMake(nextMake as MakeKey);
    setModel(null);
    setTrim("");
    setHandoffSetup(null);
  }

  function handleModelChange(nextModel: ModelKey) {
    setModel(nextModel);
    setTrim("");
    setHandoffSetup(null);
  }

  function handleTrimChange(nextTrim: string) {
    setTrim(nextTrim);
    setHandoffSetup(null);
  }

  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <section className="relative isolate min-h-[520px] overflow-hidden border-b border-white/10">
        <img
          src="/compare-hero.jpg"
          alt=""
          className="absolute inset-0 -z-20 h-full w-full object-cover object-[68%_center]"
        />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(90deg,rgba(3,4,6,0.99)_0%,rgba(3,4,6,0.92)_38%,rgba(3,4,6,0.28)_70%,rgba(3,4,6,0.58)_100%)]" />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(0deg,rgba(5,6,9,1)_0%,transparent_48%,rgba(5,6,9,0.16)_100%)]" />

        <div className="mx-auto flex min-h-[520px] max-w-7xl flex-col justify-center px-5 py-12 md:px-8">
          <div className="max-w-xl">
            <p className="text-xs font-bold uppercase tracking-[0.38em] text-red-400/80">
              Offset Lab Compare
            </p>
            <h1 className="mt-4 text-5xl font-black leading-[0.94] tracking-[-0.04em] md:text-6xl">
              See the
              <br />
              Difference.
            </h1>
            <p className="mt-5 text-base leading-7 text-white/60 md:text-lg">
              Compare factory fitment against your next setup.
            </p>
          </div>

          <div className="mt-8 rounded-[1.5rem] border border-white/15 bg-black/75 p-4 shadow-2xl shadow-black/50 backdrop-blur-xl md:p-5">
            <div className="grid gap-3 lg:grid-cols-[0.8fr_1.1fr_1fr_1.35fr_auto] lg:items-end">
              <SelectControl
                label="Make"
                value={make}
                onChange={handleMakeChange}
              >
                <option value="" disabled>
                  Select make
                </option>
                {makes.map((makeName) => (
                  <option key={makeName} value={makeName}>
                    {makeName}
                  </option>
                ))}
              </SelectControl>

              <SelectControl
                label="Vehicle"
                value={safeModel}
                onChange={(value) => handleModelChange(value as ModelKey)}
                disabled={!make}
              >
                <option value="" disabled>
                  Select vehicle
                </option>
                {availableModels.map((item) => {
                  const modelObj = vehicleModels.find(
                    (vehicle) =>
                      vehicle.make === make && vehicle.model === item
                  );

                  return (
                    <option key={item} value={item}>
                      {modelObj?.display_name ?? item}
                    </option>
                  );
                })}
              </SelectControl>

              <SelectControl
                label="Trim"
                value={safeTrim}
                onChange={handleTrimChange}
                disabled={!safeModel}
              >
                <option value="" disabled>
                  Select trim
                </option>
                {trimsForModel.map((item) => (
                  <option key={item.trim} value={item.trim}>
                    {item.display_name ?? item.trim}
                  </option>
                ))}
              </SelectControl>

              <div>
                <p className="mb-2 text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
                  Style
                </p>
                <div className="grid h-14 grid-cols-3 rounded-xl border border-white/10 bg-[#111216] p-1">
                  {([
                    ["oemplus", "OEM+"],
                    ["flush", "Flush"],
                    ["aggressive", "Aggressive"],
                  ] as const).map(([key, label]) => (
                    <button
                      key={key}
                      type="button"
                      onClick={() => {
                        setStyle(key);
                        setHandoffSetup(null);
                      }}
                      className={`rounded-lg px-3 text-xs font-bold transition ${
                        style === key
                          ? "bg-red-500 text-white"
                          : "text-white/45 hover:text-white"
                      }`}
                    >
                      {label}
                    </button>
                  ))}
                </div>
              </div>

              <button
                type="button"
                onClick={() =>
                  document
                    .getElementById("comparison")
                    ?.scrollIntoView({ behavior: "smooth", block: "start" })
                }
                disabled={!make || !safeModel || !safeTrim || !current}
                className="h-14 rounded-xl bg-red-500 px-6 text-xs font-black uppercase tracking-[0.16em] transition hover:bg-red-400 disabled:cursor-not-allowed disabled:bg-red-950 disabled:text-white/35"
              >
                Compare Setup
              </button>
            </div>
          </div>
        </div>
      </section>

      {make && safeModel && safeTrim && trimData && current ? (
        <section
          id="comparison"
          className="scroll-mt-20 px-5 py-14 md:px-8 md:py-20"
        >
          <div className="mx-auto max-w-7xl">
            <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
              <h2 className="mr-2 text-2xl font-black tracking-tight md:text-3xl">
                Factory vs Selected
              </h2>
              {[make, selectedModelLabel, selectedTrimLabel, current.title].map(
                (item, index) => (
                  <div
                    key={`${item}-${index}`}
                    className="flex items-center gap-5 text-sm font-semibold text-white/45"
                  >
                    {index > 0 ? <span className="text-white/25">›</span> : null}
                    <span
                      className={
                        index === 3 ? "text-red-400" : "whitespace-nowrap"
                      }
                    >
                      {item}
                    </span>
                  </div>
                )
              )}
            </div>
            <a
              href={fitmentHref}
              className="mt-4 inline-flex text-sm font-bold text-white/55 transition hover:text-red-400"
            >
              &lt;- Back to Fitment
            </a>

            <div className="mt-7 grid gap-5 xl:grid-cols-[0.92fr_0.92fr_1.1fr]">
              <FitmentTable
                title="Factory Baseline"
                frontWheel={trimData.baseline.front}
                rearWheel={trimData.baseline.rear}
                frontTire={trimData.baseline.tire}
                rearTire={trimData.baseline.tire}
                boltPattern={trimData.baseline.boltPattern}
              />
              <FitmentTable
                title="Selected Fitment"
                frontWheel={current.front}
                rearWheel={current.rear}
                frontTire={current.frontTire}
                rearTire={current.rearTire}
                boltPattern={trimData.baseline.boltPattern}
                selected
              />
              <CompareFitmentVisual
                baselineFront={trimData.baseline.front ?? ""}
                baselineRear={trimData.baseline.rear ?? ""}
                selectedFront={current.front ?? ""}
                selectedRear={current.rear ?? ""}
                baselineTire={trimData.baseline.tire ?? ""}
                selectedTire={current.frontTire ?? ""}
                selectedRearTire={current.rearTire ?? ""}
              />
            </div>

            <div className="mt-6 rounded-[1.6rem] border border-red-500/20 bg-[linear-gradient(135deg,rgba(239,68,68,0.1),rgba(255,255,255,0.025))] p-6 md:p-8">
              <p className="text-xs font-bold uppercase tracking-[0.26em] text-red-300/70">
                Offset Lab Verdict
              </p>
              <p className="mt-4 max-w-4xl text-lg leading-8 text-white/80 md:text-xl">
                {current.verdict}
              </p>
            </div>
          </div>
        </section>
      ) : (
        <section className="px-5 py-16 md:px-8 md:py-24">
          <div className="mx-auto max-w-7xl rounded-[1.6rem] border border-dashed border-white/15 bg-white/[0.025] px-6 py-16 text-center">
            <p className="text-xs font-bold uppercase tracking-[0.3em] text-red-400/75">
              Start Your Comparison
            </p>
            <h2 className="mt-4 text-3xl font-black tracking-tight">
              Choose a vehicle above.
            </h2>
            <p className="mx-auto mt-3 max-w-lg text-sm leading-6 text-white/45">
              We will load its factory baseline and your selected fitment side by side.
            </p>
          </div>
        </section>
      )}
    </main>
  );
}

function SelectControl({
  label,
  value,
  onChange,
  disabled = false,
  children,
}: {
  label: string;
  value: string | null;
  onChange: (value: string) => void;
  disabled?: boolean;
  children: React.ReactNode;
}) {
  return (
    <label>
      <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
        {label}
      </span>
      <select
        value={value ?? ""}
        onChange={(event) => onChange(event.target.value)}
        disabled={disabled}
        className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60 disabled:cursor-not-allowed disabled:text-white/25"
      >
        {children}
      </select>
    </label>
  );
}

function FitmentTable({
  title,
  frontWheel,
  rearWheel,
  frontTire,
  rearTire,
  boltPattern,
  selected = false,
}: {
  title: string;
  frontWheel: string;
  rearWheel: string;
  frontTire: string;
  rearTire: string;
  boltPattern: string;
  selected?: boolean;
}) {
  const rows = [
    { label: "Front Wheel", type: "wheel", value: frontWheel },
    { label: "Rear Wheel", type: "wheel", value: rearWheel },
    { label: "Front Tire", type: "tire", value: frontTire },
    { label: "Rear Tire", type: "tire", value: rearTire },
  ];

  return (
    <article
      className={`overflow-hidden rounded-[1.25rem] border bg-[#090a0d] ${
        selected
          ? "border-red-500/70 shadow-[0_0_40px_rgba(239,68,68,0.05)]"
          : "border-white/15"
      }`}
    >
      <p
        className={`px-6 py-5 text-sm font-black uppercase tracking-[0.18em] ${
          selected ? "text-red-400" : "text-white/60"
        }`}
      >
        {title}
      </p>
      <div className="border-t border-white/10 px-5">
        {rows.map((row) => (
          <FitmentRow
            key={row.label}
            label={row.label}
            type={row.type as "wheel" | "tire"}
            value={row.value}
            boltPattern={boltPattern}
            selected={selected}
          />
        ))}
      </div>
    </article>
  );
}

function FitmentRow({
  label,
  value,
  type,
  boltPattern,
  selected = false,
}: {
  label: string;
  value: string;
  type: "wheel" | "tire";
  boltPattern: string;
  selected?: boolean;
}) {
  const wheel = parseWheelDisplay(value);
  const tireDiameter = parseTireDiameter(value);

  return (
    <div className="grid min-h-[82px] grid-cols-[42px_1fr_auto] items-center gap-3 border-b border-white/10 last:border-b-0">
      <FitmentIcon type={type} />
      <p className="text-sm font-semibold text-white/70">{label}</p>
      {type === "wheel" && wheel ? (
        <div className="grid grid-cols-[auto_auto_auto] items-center gap-4 text-right text-sm font-semibold text-white/60">
          <span>
            {wheel.diameter} x{" "}
            <strong className={selected ? "text-red-400" : "text-white/75"}>
              {wheel.width}J
            </strong>
          </span>
          <strong className={selected ? "text-red-400" : "text-white/75"}>
            {wheel.offset > 0 ? "+" : ""}
            {wheel.offset}mm
          </strong>
          <span className="text-white/50">{boltPattern || "—"}</span>
        </div>
      ) : (
        <div className="grid grid-cols-[auto_auto] items-center gap-5 text-right text-sm font-semibold">
          <strong className={selected ? "text-red-400" : "text-white/75"}>
            {value}
          </strong>
          <span className="text-white/50">
            {tireDiameter ? `${Math.round(tireDiameter)}mm` : "—"}
          </span>
        </div>
      )}
    </div>
  );
}

function FitmentIcon({ type }: { type: "wheel" | "tire" }) {
  if (type === "tire") {
    return (
      <svg viewBox="0 0 42 42" className="h-9 w-9 text-white/55" fill="none">
        <ellipse cx="20" cy="21" rx="10" ry="16" stroke="currentColor" strokeWidth="2" />
        <ellipse cx="23" cy="21" rx="8" ry="16" stroke="currentColor" />
        <ellipse cx="26" cy="21" rx="6" ry="15" stroke="currentColor" opacity=".55" />
        <path d="M12 9l7 3M10 15l8 2M10 22l8 1M11 29l8-1M14 35l6-3" stroke="currentColor" opacity=".6" />
      </svg>
    );
  }

  return (
    <svg viewBox="0 0 42 42" className="h-9 w-9 text-white/55" fill="none">
      <circle cx="21" cy="21" r="17" stroke="currentColor" strokeWidth="2" />
      <circle cx="21" cy="21" r="12" stroke="currentColor" />
      <circle cx="21" cy="21" r="3" stroke="currentColor" />
      {[0, 72, 144, 216, 288].map((rotation) => (
        <path
          key={rotation}
          d="M21 18L18 9L22 6L24 18"
          stroke="currentColor"
          transform={`rotate(${rotation} 21 21)`}
        />
      ))}
    </svg>
  );
}

function parseWheelDisplay(value: string) {
  const match = value.match(
    /(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+|et)?\s*(-?\d+)/i
  );
  if (!match) return null;
  return {
    diameter: match[1],
    width: match[2],
    offset: Number(match[3]),
  };
}

function parseTireDiameter(value: string) {
  const match = value.match(/(\d{3})\/(\d{2})R(\d{2})/i);
  if (!match) return null;
  return Number(match[3]) * 25.4 + 2 * Number(match[1]) * (Number(match[2]) / 100);
}
