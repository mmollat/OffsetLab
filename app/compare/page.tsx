"use client";

import { useEffect, useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
import {
  MakeKey,
  ModelKey,
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

      if (models.length > 0) {
        const first = models[0];
        setMake(first.make as MakeKey);
        setModel(first.model as ModelKey);

        const firstTrim =
          trims.find(
            (t) => t.make === first.make && t.model === first.model
          )?.trim ?? "";

        setTrim(firstTrim);
      }
    }

    loadData();
  }, []);

  const availableModels = useMemo(() => {
    if (!make) return [];
    return vehicleModels
      .filter((m) => m.make === make)
      .map((m) => m.model as ModelKey);
  }, [make, vehicleModels]);

  const trimsForModel = useMemo(() => {
    if (!make || !model) return [];
    return vehicleTrims.filter(
      (t) => t.make === make && t.model === model
    );
  }, [make, model, vehicleTrims]);

  const trimData = useMemo(() => {
    if (!fitmentDb || !model || !trim) return null;
    return (
      fitmentDb[model]?.find((t) => t.trim === trim) ??
      fitmentDb[model]?.[0] ??
      null
    );
  }, [fitmentDb, model, trim]);

  const current = trimData?.presets?.[style];

  if (!fitmentDb || !model || !current) {
    return (
      <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
        <div className="mx-auto max-w-7xl">Loading...</div>
      </main>
    );
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8 text-white">
      <div className="mx-auto max-w-7xl grid gap-6 lg:grid-cols-[320px_1fr]">

        <aside className="space-y-5">

          {/* MAKE */}
          <div>
            <p className="mb-2 text-sm text-white/40">Make</p>
            <div className="flex flex-wrap gap-2">
              {[...new Set(vehicleModels.map((m) => m.make))].map((mk) => (
                <button
                  key={mk}
                  onClick={() => {
                    setMake(mk as MakeKey);

                    const nextModel =
                      vehicleModels.find((v) => v.make === mk)?.model as ModelKey;

                    setModel(nextModel);

                    const nextTrim =
                      vehicleTrims.find(
                        (t) => t.make === mk && t.model === nextModel
                      )?.trim ?? "";

                    setTrim(nextTrim);
                  }}
                  className="rounded-xl border border-white/10 px-3 py-2 text-sm"
                >
                  {mk}
                </button>
              ))}
            </div>
          </div>

          {/* MODEL */}
          <div>
            <p className="mb-2 text-sm text-white/40">Model</p>
            <select
              value={model ?? ""}
              onChange={(e) => {
                const next = e.target.value as ModelKey;
                setModel(next);

                const nextTrim =
                  vehicleTrims.find(
                    (t) => t.make === make && t.model === next
                  )?.trim ?? "";

                setTrim(nextTrim);
              }}
              className="w-full rounded-xl bg-black/40 p-3"
            >
              {availableModels.map((m) => {
                const obj = vehicleModels.find(
                  (x) => x.make === make && x.model === m
                );

                return (
                  <option key={m} value={m}>
                    {obj?.display_name ?? m}
                  </option>
                );
              })}
            </select>
          </div>

          {/* TRIM */}
          <div>
            <p className="mb-2 text-sm text-white/40">Trim</p>
            <select
              value={trim}
              onChange={(e) => setTrim(e.target.value)}
              className="w-full rounded-xl bg-black/40 p-3"
            >
              {trimsForModel.map((t) => (
                <option key={t.trim} value={t.trim}>
                  {t.display_name ?? t.trim}
                </option>
              ))}
            </select>
          </div>

        </aside>

        <section className="space-y-6">
          <CompareFitmentVisual
            baselineFront={trimData.baseline.front}
            baselineRear={trimData.baseline.rear}
            selectedFront={current.front}
            selectedRear={current.rear}
            pokeFront={current.pokeFront}
            pokeRear={current.pokeRear}
          />
        </section>

      </div>
    </main>
  );
}
