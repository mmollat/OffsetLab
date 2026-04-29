"use client";

import { useEffect, useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
import {
  MakeKey,
  ModelKey,
  normalizeMake,
  normalizeModel,
  normalizeStyle,
  StyleKey,
  TrimData,
} from "../data/fitment";
import { getFitmentData } from "../lib/getFitmentData";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { getVehicleTrims, VehicleTrim } from "../lib/getVehicleTrims";

export default function ComparePage() {
  const [make, setMake] = useState<MakeKey | null>(null);
  const [model, setModel] = useState<ModelKey | null>(null);
  const [trim, setTrim] = useState("");
  const [style, setStyle] = useState<StyleKey>("aggressive");

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
  }

  loadData();
}, []);

  const makes = useMemo(() => {
    return Array.from(new Set(vehicleModels.map((item) => item.make))).map((label) => ({
      label: label as MakeKey,
      active: true,
    }));
  }, [vehicleModels]);

  const availableModels = useMemo(() => {
    if (!make) return [];
    return vehicleModels
      .filter((item) => item.make === make)
      .map((item) => item.model as ModelKey);
  }, [make, vehicleModels]);

  const safeModel =
    make && model && availableModels.includes(model)
      ? model
      : availableModels.length > 0
        ? availableModels[0]
        : null;

  const trims = useMemo(() => {
    if (!make || !safeModel) return [];

    return vehicleTrims
      .filter((item) => item.make === make && item.model === safeModel)
      .map((item) => item.trim);
  }, [make, safeModel, vehicleTrims]);

  const safeTrim = trim && trims.includes(trim) ? trim : trims[0] ?? "";

  const trimData = useMemo(() => {
    if (!fitmentDb || !safeModel || !safeTrim) return null;

    const entries = fitmentDb[safeModel];
    if (!entries || entries.length === 0) return null;

    return entries.find((entry) => entry.trim === safeTrim) ?? entries[0];
  }, [fitmentDb, safeModel, safeTrim]);

  const current = trimData?.presets?.[style];

  useEffect(() => {
    if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) return;

    const params = new URLSearchParams(window.location.search);
    const rawMake = params.get("make");

    if (!rawMake) {
  const firstMake = vehicleModels[0]?.make as MakeKey;
  const firstModel = vehicleModels[0]?.model as ModelKey;

  if (!firstMake || !firstModel) return;

  setMake(firstMake);
  setModel(firstModel);

  const firstTrim =
    vehicleTrims.find(
      (item) => item.make === firstMake && item.model === firstModel
    )?.trim ?? "";

  setTrim(firstTrim);
  return;
}

    const urlMake = normalizeMake(rawMake);
    const rawModel = params.get("model")?.replace(/[-_]/g, " ").toLowerCase().trim();

const urlModel =
  vehicleModels.find(
    (item) =>
      item.make === urlMake &&
      item.model.toLowerCase().replace(/[-_]/g, " ").trim() === rawModel
  )?.model as ModelKey ||
  normalizeModel(params.get("model"), urlMake);
    const urlStyle = normalizeStyle(params.get("style"));
    const urlTrim = params.get("trim");

    setMake(urlMake);
    setModel(urlModel);
    setStyle(urlStyle);

    const availableUrlTrims = vehicleTrims
      .filter((item) => item.make === urlMake && item.model === urlModel)
      .map((item) => item.trim);

    setTrim(urlTrim && availableUrlTrims.includes(urlTrim) ? urlTrim : availableUrlTrims[0] ?? "");
  }, [fitmentDb, vehicleModels, vehicleTrims]);

  useEffect(() => {
    if (!make || !safeModel || !safeTrim) return;

    const params = new URLSearchParams();
    params.set("make", String(make).toLowerCase());
    params.set("model", String(safeModel).toLowerCase().replace(/\s+/g, "-"));
    params.set("trim", safeTrim);
    params.set("style", style);

    window.history.replaceState({}, "", `${window.location.pathname}?${params.toString()}`);
  }, [make, safeModel, safeTrim, style]);

  if (!fitmentDb || vehicleModels.length === 0 || vehicleTrims.length === 0) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
        <div className="mx-auto max-w-7xl text-white/60">Loading compare data...</div>
      </main>
    );
  }

  if (!make || !safeModel || !trimData || !current) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
        <div className="mx-auto max-w-7xl">
          <div className="mb-8">
            <p className="text-xs uppercase tracking-[0.25em] text-red-400/70">
              Offset Lab Compare
            </p>
            <h1 className="mt-2 text-3xl font-bold md:text-5xl">
              Compare <span className="text-red-500">Fitment</span>
            </h1>
            <p className="mt-3 text-white/55">
              Choose a make to compare your fitment setup.
            </p>
          </div>

          <Panel title="1. Select Make">
            <div className="flex flex-wrap gap-2">
              {makes.map((item) => (
                <button
                  key={item.label}
                  onClick={() => {
                    setMake(item.label);
                    const nextModel = vehicleModels.find(
                      (vehicle) => vehicle.make === item.label
                    )?.model as ModelKey;

                    if (!nextModel) return;

                    setModel(nextModel);

                    const nextTrim =
                      vehicleTrims.find(
                        (vehicleTrim) =>
                          vehicleTrim.make === item.label && vehicleTrim.model === nextModel
                      )?.trim ?? "";

                    setTrim(nextTrim);
                  }}
                  className="rounded-xl border border-white/10 bg-black/30 px-3 py-2 text-sm text-white/70 transition hover:border-white/25"
                >
                  {item.label}
                </button>
              ))}
            </div>
          </Panel>
        </div>
      </main>
    );
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-red-400/70">
            Offset Lab Compare
          </p>
          <h1 className="mt-2 text-3xl font-bold md:text-5xl">
            {safeModel} {safeTrim}{" "}
            <span className="text-red-500">| {current.title}</span>
          </h1>
          <p className="mt-3 text-white/55">
            Compare factory baseline specs against your selected fitment.
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
                      onClick={() => {
                        setMake(item.label);

                        const nextModel = vehicleModels.find(
                          (vehicle) => vehicle.make === item.label
                        )?.model as ModelKey;

                        if (!nextModel) return;

                        setModel(nextModel);

                        const nextTrim =
                          vehicleTrims.find(
                            (vehicleTrim) =>
                              vehicleTrim.make === item.label &&
                              vehicleTrim.model === nextModel
                          )?.trim ?? "";

                        setTrim(nextTrim);
                      }}
                      className={`rounded-xl border px-3 py-2 text-sm transition ${
                        isSelected
                          ? "border-red-500/60 bg-red-500/15 text-white"
                          : "border-white/10 bg-black/30 text-white/70 hover:border-white/25"
                      }`}
                    >
                      {item.label}
                    </button>
                  );
                })}
              </div>
            </Panel>

            <Panel title="2. Select Vehicle">
              <div className="space-y-3">
                <select
                  value={safeModel ?? ""}
                  onChange={(e) => {
                    const next = e.target.value as ModelKey;
                    setModel(next);

                    const nextTrim =
                      vehicleTrims.find(
                        (vehicleTrim) =>
                          vehicleTrim.make === make && vehicleTrim.model === next
                      )?.trim ?? "";

                    setTrim(nextTrim);
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
                {[
                  ["oemplus", "OEM+", "Subtle & Clean"],
                  ["flush", "Flush", "Balanced stance"],
                  ["aggressive", "Aggressive", "Max fitment"],
                ].map(([key, label, sub]) => (
                  <button
                    key={key}
                    onClick={() => setStyle(key as StyleKey)}
                    className={`w-full rounded-2xl border p-4 text-left transition ${
                      style === key
                        ? "border-red-500/60 bg-red-500/10"
                        : "border-white/10 bg-black/30 hover:border-white/25"
                    }`}
                  >
                    <p className="font-semibold">{label}</p>
                    <p className="mt-1 text-sm text-white/45">{sub}</p>
                  </button>
                ))}
              </div>
            </Panel>
          </aside>

          <section className="space-y-6">
            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Baseline</p>
              <div className="mt-4 grid gap-4 md:grid-cols-2">
                <Spec label="Front Wheel" value={trimData.baseline.front} />
                <Spec label="Rear Wheel" value={trimData.baseline.rear} />
                <Spec label="Factory Tire" value={trimData.baseline.tire} />
                <Spec label="Bolt Pattern" value={trimData.baseline.boltPattern} />
                <Spec label="Center Bore" value={trimData.baseline.centerBore} />
              </div>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">
                Selected Fitment
              </p>
              <div className="mt-4 grid gap-4 md:grid-cols-2">
                <Spec label="Front Wheel" value={current.front} />
                <Spec label="Rear Wheel" value={current.rear} />
                <Spec label="Front Tire" value={current.frontTire} />
                <Spec label="Rear Tire" value={current.rearTire} />
                <Spec label="Front Poke" value={current.pokeFront} />
                <Spec label="Rear Poke" value={current.pokeRear} />
                <Spec label="Diameter Change" value={current.diameter} />
                <Spec label="Risk" value={current.risk} />
              </div>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Visual Compare</p>
              <div className="mt-6">
                <CompareFitmentVisual
  baselineFront={trimData.baseline.front ?? ""}
  baselineRear={trimData.baseline.rear ?? ""}
  selectedFront={current.front ?? ""}
  selectedRear={current.rear ?? ""}
  pokeFront={current.pokeFront ?? ""}
  pokeRear={current.pokeRear ?? ""}
/>
              </div>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Verdict</p>
              <p className="mt-3 text-lg leading-8 text-white/80">{current.verdict}</p>
            </div>
          </section>
        </div>
      </div>
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

function Spec({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
      <p className="text-xs uppercase tracking-wide text-white/40">{label}</p>
      <p className="mt-2 font-semibold text-white">{value}</p>
    </div>
  );
}
