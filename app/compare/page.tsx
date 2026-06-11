"use client";

import { useEffect, useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
import { MakeKey, ModelKey, StyleKey, TrimData } from "../data/fitment";
import { getFitmentData } from "../lib/getFitmentData";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { getVehicleTrims, VehicleTrim } from "../lib/getVehicleTrims";

export default function ComparePage() {
  const [make, setMake] = useState<MakeKey | null>(null);
  const [model, setModel] = useState<ModelKey | null>(null);
  const [trim, setTrim] = useState("");
  const [style, setStyle] = useState<StyleKey>("flush");

  const [fitmentDb, setFitmentDb] = useState<Record<ModelKey, TrimData[]> | null>(null);
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [vehicleTrims, setVehicleTrims] = useState<VehicleTrim[]>([]);

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

      const first = models[0];

      if (first) {
        setMake(first.make as MakeKey);
        setModel(first.model as ModelKey);

        const firstTrim =
          trims.find((t) => t.make === first.make && t.model === first.model)?.trim ?? "";

        setTrim(firstTrim);
      }
    }

    loadData();
  }, []);

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
      : availableModels.length > 0
        ? availableModels[0]
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
      : trimsForModel[0]?.trim ?? "";

  const trimData = useMemo(() => {
    if (!fitmentDb || !safeModel || !safeTrim) return null;

    return (
      fitmentDb[safeModel]?.find((item) => item.trim === safeTrim) ??
      fitmentDb[safeModel]?.[0] ??
      null
    );
  }, [fitmentDb, safeModel, safeTrim]);

  const current = trimData?.presets?.[style];
  const selectedModelLabel =
    vehicleModels.find(
      (vehicle) => vehicle.make === make && vehicle.model === safeModel
    )?.display_name ?? safeModel;

  const selectedTrimLabel =
    trimsForModel.find((item) => item.trim === safeTrim)?.display_name ?? safeTrim;

  if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
        <div className="mx-auto max-w-7xl text-white/60">Loading compare data...</div>
      </main>
    );
  }

  if (!make || !safeModel || !safeTrim || !trimData || !current) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
        <div className="mx-auto max-w-7xl">
          No compare data found for this setup.
        </div>
      </main>
    );
  }

  function handleMakeChange(nextMake: string) {
    setMake(nextMake as MakeKey);

    const nextModel = vehicleModels.find(
      (vehicle) => vehicle.make === nextMake
    )?.model as ModelKey | undefined;

    if (!nextModel) return;
    setModel(nextModel);

    const nextTrim =
      vehicleTrims.find(
        (vehicleTrim) =>
          vehicleTrim.make === nextMake && vehicleTrim.model === nextModel
      )?.trim ?? "";

    setTrim(nextTrim);
  }

  function handleModelChange(nextModel: ModelKey) {
    setModel(nextModel);

    const nextTrim =
      vehicleTrims.find(
        (vehicleTrim) =>
          vehicleTrim.make === make && vehicleTrim.model === nextModel
      )?.trim ?? "";

    setTrim(nextTrim);
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
              >
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
                onChange={setTrim}
              >
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
                      onClick={() => setStyle(key)}
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
                className="h-14 rounded-xl bg-red-500 px-6 text-xs font-black uppercase tracking-[0.16em] transition hover:bg-red-400"
              >
                Compare Setup
              </button>
            </div>
          </div>
        </div>
      </section>

      <section
        id="comparison"
        className="scroll-mt-20 px-5 py-14 md:px-8 md:py-20"
      >
        <div className="mx-auto max-w-7xl">
          <div className="flex flex-col gap-4 border-b border-white/10 pb-8 md:flex-row md:items-end md:justify-between">
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.32em] text-red-400/70">
                Factory vs Selected
              </p>
              <h2 className="mt-3 text-3xl font-black tracking-tight md:text-5xl">
                {selectedTrimLabel}
              </h2>
              <p className="mt-3 text-sm text-white/45">
                {make} / {selectedModelLabel} / {current.title}
              </p>
            </div>
            <div className="w-fit rounded-full border border-red-500/30 bg-red-500/10 px-4 py-2 text-xs font-bold uppercase tracking-[0.16em] text-red-300">
              Risk: {current.risk}
            </div>
          </div>

          <div className="mt-8 grid gap-6 lg:grid-cols-2">
            <CompareCard title="Factory Baseline">
              <Spec label="Front Wheel" value={trimData.baseline.front} />
              <Spec label="Rear Wheel" value={trimData.baseline.rear} />
              <Spec label="Factory Tire" value={trimData.baseline.tire} />
              <Spec label="Bolt Pattern" value={trimData.baseline.boltPattern} />
              <Spec label="Center Bore" value={trimData.baseline.centerBore} />
            </CompareCard>

            <CompareCard title="Selected Fitment" selected>
              <Spec label="Front Wheel" value={current.front} selected />
              <Spec label="Rear Wheel" value={current.rear} selected />
              <Spec label="Front Tire" value={current.frontTire} selected />
              <Spec label="Rear Tire" value={current.rearTire} selected />
              <Spec label="Front Poke" value={current.pokeFront} selected />
              <Spec label="Rear Poke" value={current.pokeRear} selected />
              <Spec label="Diameter Change" value={current.diameter} selected />
            </CompareCard>
          </div>

          <div className="mt-6 rounded-[1.6rem] border border-white/10 bg-white/[0.025] p-4 md:p-6">
            <p className="text-xs font-bold uppercase tracking-[0.26em] text-white/35">
              Technical View
            </p>
            <div className="mt-5">
              <CompareFitmentVisual
                baselineFront={trimData.baseline.front ?? ""}
                selectedFront={current.front ?? ""}
                baselineTire={trimData.baseline.tire ?? ""}
                selectedTire={current.frontTire ?? ""}
              />
            </div>
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
    </main>
  );
}

function SelectControl({
  label,
  value,
  onChange,
  children,
}: {
  label: string;
  value: string | null;
  onChange: (value: string) => void;
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
        className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60"
      >
        {children}
      </select>
    </label>
  );
}

function CompareCard({
  title,
  selected = false,
  children,
}: {
  title: string;
  selected?: boolean;
  children: React.ReactNode;
}) {
  return (
    <article
      className={`rounded-[1.6rem] border p-5 md:p-6 ${
        selected
          ? "border-red-500/25 bg-red-500/[0.045]"
          : "border-white/10 bg-white/[0.025]"
      }`}
    >
      <p
        className={`text-xs font-bold uppercase tracking-[0.26em] ${
          selected ? "text-red-300/70" : "text-white/35"
        }`}
      >
        {title}
      </p>
      <div className="mt-5 grid gap-3 sm:grid-cols-2">{children}</div>
    </article>
  );
}

function Spec({
  label,
  value,
  selected = false,
}: {
  label: string;
  value?: string;
  selected?: boolean;
}) {
  return (
    <div
      className={`rounded-xl border p-4 ${
        selected
          ? "border-red-500/15 bg-red-500/[0.035]"
          : "border-white/10 bg-black/25"
      }`}
    >
      <p className="text-[10px] font-bold uppercase tracking-[0.2em] text-white/35">
        {label}
      </p>
      <p className={`mt-2 font-bold ${selected ? "text-red-100" : "text-white"}`}>
        {value || "—"}
      </p>
    </div>
  );
}
