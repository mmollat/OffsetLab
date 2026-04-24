"use client";

import { useMemo, useState } from "react";
import CompareFitmentVisual from "../components/CompareFitmentVisual";
import { getTrimData, getTrims, modelOptions, ModelKey, StyleKey } from "../data/fitment";

export default function ComparePage() {
  const [model, setModel] = useState<ModelKey>("Model S");
  const [trim, setTrim] = useState("Plaid");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const trims = useMemo(() => getTrims(model), [model]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(() => getTrimData(model, safeTrim), [model, safeTrim]);
  const current = trimData.presets[style];

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-5xl">
        <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">Setup Comparison</p>
        <h1 className="mt-2 text-3xl font-bold md:text-4xl">Compare Setup</h1>
        <div className="mt-6 grid gap-4 md:grid-cols-3">
          <select value={model} onChange={(e) => { const next = e.target.value as ModelKey; setModel(next); setTrim(getTrims(next)[0]); }} className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
            {modelOptions.map((item) => <option key={item} value={item}>{item}</option>)}
          </select>
          <select value={safeTrim} onChange={(e) => setTrim(e.target.value)} className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
            {trims.map((item) => <option key={item} value={item}>{item}</option>)}
          </select>
          <select value={style} onChange={(e) => setStyle(e.target.value as StyleKey)} className="rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
            <option value="oemplus">OEM+</option><option value="flush">Flush</option><option value="aggressive">Aggressive</option>
          </select>
        </div>
        <div className="mt-8 grid gap-6 md:grid-cols-2">
          <Card title="OEM" a={`Front: ${trimData.baseline.front}`} b={`Rear: ${trimData.baseline.rear}`} c={trimData.baseline.tire} />
          <Card title="Recommended" a={`Front: ${current.front}`} b={`Rear: ${current.rear}`} c={`${current.frontTire} / ${current.rearTire}`} />
        </div>
        <div className="mt-6">
          <CompareFitmentVisual
            oemFront={trimData.baseline.front}
            selectedFront={current.front}
            oemRear={trimData.baseline.rear}
            selectedRear={current.rear}
            selectedLabel={current.title}
          />
        </div>
        <div className="mt-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Summary</p>
          <p className="mt-4 text-lg leading-8 text-white/80">{current.verdict}</p>
        </div>
      </div>
    </main>
  );
}

function Card({ title, a, b, c }: { title: string; a: string; b: string; c: string }) {
  return <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6"><p className="text-sm uppercase tracking-wide text-white/40">{title}</p><p className="mt-5 text-2xl font-bold">{a}</p><p className="mt-2 text-2xl font-bold">{b}</p><p className="mt-3 text-white/60">{c}</p></section>;
}
