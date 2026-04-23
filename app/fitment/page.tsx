"use client";

import { useMemo, useState } from "react";
import {
  getTrimData,
  getTrims,
  teslaModels,
  TeslaModelKey,
  StyleKey,
} from "../data/tesla";

function scoreColor(score: number) {
  if (score >= 8) return "text-red-400";
  if (score >= 6) return "text-yellow-300";
  return "text-green-400";
}

function riskPill(risk: string) {
  if (risk.toLowerCase().includes("moderate")) {
    return "bg-yellow-500/15 text-yellow-300 border-yellow-500/30";
  }
  if (risk.toLowerCase().includes("high")) {
    return "bg-red-500/15 text-red-300 border-red-500/30";
  }
  return "bg-green-500/15 text-green-300 border-green-500/30";
}

export default function FitmentPage() {
  const [model, setModel] = useState<TeslaModelKey>("Model 3");
  const [trim, setTrim] = useState<string>("Performance");
  const [style, setStyle] = useState<StyleKey>("aggressive");

  const trims = useMemo(() => getTrims(model), [model]);

  const safeTrim = trims.includes(trim) ? trim : trims[0];

  const trimData = useMemo(() => getTrimData(model, safeTrim), [model, safeTrim]);
  const current = trimData.presets[style];

  return (
    <main className="min-h-[calc(100vh-73px)] bg-black px-5 py-8">
      <div className="mx-auto max-w-6xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-white/35">
            Offset Recommendation
          </p>
          <h1 className="mt-2 text-3xl font-bold md:text-4xl">Tesla Fitment Finder</h1>
          <p className="mt-2 text-white/55">
            Choose your Tesla model, trim, and target style to see a recommended setup.
          </p>
        </div>

        <div className="mb-6 grid gap-4 md:grid-cols-3">
          <SelectCard label="Model">
            <select
              value={model}
              onChange={(e) => {
                const nextModel = e.target.value as TeslaModelKey;
                setModel(nextModel);
                setTrim(getTrims(nextModel)[0]);
              }}
              className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
            >
              {teslaModels.map((item) => (
                <option key={item} value={item}>
                  {item}
                </option>
              ))}
            </select>
          </SelectCard>

          <SelectCard label="Trim">
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
          </SelectCard>

          <SelectCard label="Style">
            <div className="grid gap-2 sm:grid-cols-3">
              {(
                [
                  ["oemplus", "OEM+"],
                  ["flush", "Flush"],
                  ["aggressive", "Aggressive"],
                ] as const
              ).map(([key, label]) => {
                const active = style === key;
                return (
                  <button
                    key={key}
                    onClick={() => setStyle(key)}
                    className={`rounded-xl border px-4 py-3 text-sm font-medium transition ${
                      active
                        ? "border-white/30 bg-white/[0.06]"
                        : "border-white/10 bg-white/[0.02] hover:border-white/20 hover:bg-white/[0.04]"
                    }`}
                  >
                    {label}
                  </button>
                );
              })}
            </div>
          </SelectCard>
        </div>

        <div className="grid gap-6 lg:grid-cols-[1.25fr_0.75fr]">
          <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6 md:p-8">
            <div className="flex flex-col gap-4 border-b border-white/10 pb-6 md:flex-row md:items-end md:justify-between">
              <div>
                <p className="text-sm text-white/45">{model} • {safeTrim}</p>
                <h2 className="mt-1 text-2xl font-bold">{current.title}</h2>
                <p className="mt-2 text-sm text-white/55">{current.subtitle}</p>
              </div>

              <div
                className={`rounded-full border px-3 py-1 text-sm font-medium ${riskPill(
                  current.risk
                )}`}
              >
                Risk: {current.risk}
              </div>
            </div>

            <div className="mt-6 grid gap-4 md:grid-cols-2">
              <div className="rounded-2xl border border-white/10 bg-black/30 p-5">
                <p className="text-sm uppercase tracking-wide text-white/40">Front</p>
                <p className="mt-3 text-3xl font-bold">{current.front}</p>
                <p className="mt-2 text-white/70">{current.frontTire}</p>
              </div>

              <div className="rounded-2xl border border-white/10 bg-black/30 p-5">
                <p className="text-sm uppercase tracking-wide text-white/40">Rear</p>
                <p className="mt-3 text-3xl font-bold">{current.rear}</p>
                <p className="mt-2 text-white/70">{current.rearTire}</p>
              </div>
            </div>

            <div className="mt-6 rounded-2xl border border-white/10 bg-black/30 p-5">
              <p className="text-sm uppercase tracking-wide text-white/40">
                Fitment Metrics
              </p>

              <div className="mt-4 grid gap-3 md:grid-cols-2">
                <Metric label="Front poke change" value={current.pokeFront} />
                <Metric label="Rear poke change" value={current.pokeRear} />
                <Metric label="Front inner clearance" value={current.innerFront} />
                <Metric label="Rear inner clearance" value={current.innerRear} />
              </div>

              <div className="mt-3">
                <Metric label="Tire diameter change" value={current.diameter} />
              </div>
            </div>

            <div className="mt-6 rounded-2xl border border-white/10 bg-black/30 p-5">
              <p className="text-sm uppercase tracking-wide text-white/40">Verdict</p>
              <p className="mt-3 text-base leading-7 text-white/80">
                {current.verdict}
              </p>
            </div>

            <div className="mt-6 rounded-2xl border border-white/10 bg-black/30 p-5">
              <p className="text-sm uppercase tracking-wide text-white/40">Warnings</p>
              <ul className="mt-3 space-y-2 text-white/75">
                {current.warnings.map((warning) => (
                  <li key={warning}>• {warning}</li>
                ))}
              </ul>
            </div>
          </section>

          <aside className="space-y-6">
            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Scores</p>

              <div className="mt-5 space-y-5">
                <ScoreRow
                  label="Visual Aggression"
                  value={current.aggression}
                  colorClass={scoreColor(current.aggression)}
                />
                <ScoreRow
                  label="Daily Drivability"
                  value={current.daily}
                  colorClass={scoreColor(current.daily)}
                />
              </div>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">
                Alternate Setup
              </p>
              <p className="mt-4 text-xl font-semibold">{current.alternate}</p>
              <p className="mt-2 text-sm text-white/55">
                Good secondary option if you want a different stance or tire strategy.
              </p>
            </div>

            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Baseline</p>
              <div className="mt-4 space-y-2 text-white/75">
                <p>OEM Front: {trimData.baseline.front}</p>
                <p>OEM Rear: {trimData.baseline.rear}</p>
                <p>OEM Tire: {trimData.baseline.tire}</p>
                <p>Bolt Pattern: {trimData.baseline.boltPattern}</p>
                <p>Center Bore: {trimData.baseline.centerBore}</p>
              </div>
            </div>
          </aside>
        </div>
      </div>
    </main>
  );
}

function SelectCard({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-4">
      <p className="mb-3 text-sm uppercase tracking-wide text-white/40">{label}</p>
      {children}
    </div>
  );
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl border border-white/8 bg-white/[0.02] px-4 py-3">
      <p className="text-xs uppercase tracking-wide text-white/35">{label}</p>
      <p className="mt-2 text-lg font-semibold text-white">{value}</p>
    </div>
  );
}

function ScoreRow({
  label,
  value,
  colorClass,
}: {
  label: string;
  value: number;
  colorClass: string;
}) {
  return (
    <div>
      <div className="mb-2 flex items-center justify-between">
        <p className="text-sm text-white/70">{label}</p>
        <p className={`text-sm font-semibold ${colorClass}`}>{value}/10</p>
      </div>
      <div className="h-2 rounded-full bg-white/10">
        <div
          className="h-2 rounded-full bg-white"
          style={{ width: `${value * 10}%` }}
        />
      </div>
    </div>
  );
}
