"use client";

import { useMemo, useState } from "react";
import {
  getTrimData,
  getTrims,
  modelOptions,
  ModelKey,
  StyleKey,
} from "../data/fitment";

export default function ComparePage() {
  const [model, setModel] = useState<ModelKey>("Model 3");
  const [trim, setTrim] = useState("Performance");
  const [style, setStyle] = useState<StyleKey>("aggressive");

  const trims = useMemo(() => getTrims(model), [model]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(() => getTrimData(model, safeTrim), [model, safeTrim]);
  const current = trimData.presets[style];

  return (
    <main className="min-h-[calc(100vh-73px)] bg-black px-5 py-8">
      <div className="mx-auto max-w-5xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-white/35">Setup Comparison</p>
          <h1 className="mt-2 text-3xl font-bold md:text-4xl">Compare Setup</h1>
          <p className="mt-2 text-white/55">
            Compare the OEM baseline against a recommended setup.
          </p>
        </div>

        <div className="mb-6 grid gap-4 md:grid-cols-3">
          <SelectCard label="Model">
            <select
              value={model}
              onChange={(e) => {
                const nextModel = e.target.value as ModelKey;
                setModel(nextModel);
                setTrim(getTrims(nextModel)[0]);
              }}
              className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
            >
              {modelOptions.map((item) => <option key={item} value={item}>{item}</option>)}
            </select>
          </SelectCard>

          <SelectCard label="Trim">
            <select
              value={safeTrim}
              onChange={(e) => setTrim(e.target.value)}
              className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
            >
              {trims.map((item) => <option key={item} value={item}>{item}</option>)}
            </select>
          </SelectCard>

          <SelectCard label="Style">
            <select
              value={style}
              onChange={(e) => setStyle(e.target.value as StyleKey)}
              className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none"
            >
              <option value="oemplus">OEM+</option>
              <option value="flush">Flush</option>
              <option value="aggressive">Aggressive</option>
            </select>
          </SelectCard>
        </div>

        <div className="grid gap-6 md:grid-cols-2">
          <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
            <p className="text-sm uppercase tracking-wide text-white/40">OEM</p>
            <div className="mt-5 space-y-3 text-white/80">
              <p className="text-2xl font-bold">Front: {trimData.baseline.front}</p>
              <p className="text-2xl font-bold">Rear: {trimData.baseline.rear}</p>
              <p>{trimData.baseline.tire}</p>
              <p className="text-sm text-white/45">{model} • {safeTrim}</p>
            </div>
          </section>

          <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
            <p className="text-sm uppercase tracking-wide text-white/40">Recommended</p>
            <div className="mt-5 space-y-3 text-white/80">
              <p className="text-2xl font-bold">Front: {current.front}</p>
              <p className="text-2xl font-bold">Rear: {current.rear}</p>
              <p>{current.frontTire} / {current.rearTire}</p>
              <p className="text-sm text-white/45">{current.title}</p>
            </div>
          </section>
        </div>

        <section className="mt-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Comparison Metrics</p>
          <div className="mt-5 grid gap-3 md:grid-cols-3">
            <MetricCard label="Front poke" value={current.pokeFront} detail="Outward change" />
            <MetricCard label="Front inner" value={current.innerFront} detail="Suspension side change" />
            <MetricCard label="Diameter" value={current.diameter} detail="Overall tire diameter change" />
          </div>
        </section>

        <section className="mt-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Summary</p>
          <p className="mt-4 text-lg leading-8 text-white/80">{current.verdict}</p>
        </section>
      </div>
    </main>
  );
}

function SelectCard({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-4">
      <p className="mb-3 text-sm uppercase tracking-wide text-white/40">{label}</p>
      {children}
    </div>
  );
}

function MetricCard({ label, value, detail }: { label: string; value: string; detail: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-5">
      <p className="text-xs uppercase tracking-wide text-white/35">{label}</p>
      <p className="mt-3 text-2xl font-bold">{value}</p>
      <p className="mt-2 text-sm text-white/55">{detail}</p>
    </div>
  );
}
