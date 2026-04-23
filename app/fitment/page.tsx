"use client";

import { useEffect, useMemo, useState } from "react";
import {
  fitmentData,
  getTrimData,
  getTrims,
  makes,
  modelOptions,
  ModelKey,
  normalizeModel,
  normalizeStyle,
  StyleKey,
  modelSlug,
} from "../data/fitment";

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
  const [make, setMake] = useState("Tesla");
  const [model, setModel] = useState<ModelKey>("Model 3");
  const [trim, setTrim] = useState("Performance");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const urlModel = normalizeModel(params.get("model"));
    const urlStyle = normalizeStyle(params.get("style"));
    const urlTrim = params.get("trim");

    setMake("Tesla");
    setModel(urlModel);
    setStyle(urlStyle);

    const availableTrims = getTrims(urlModel);
    setTrim(urlTrim && availableTrims.includes(urlTrim) ? urlTrim : availableTrims[0]);
  }, []);

  const trims = useMemo(() => getTrims(model), [model]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(() => getTrimData(model, safeTrim), [model, safeTrim]);
  const current = trimData.presets[style];

  useEffect(() => {
    const params = new URLSearchParams();
    params.set("make", make.toLowerCase());
    params.set("model", modelSlug(model));
    params.set("trim", safeTrim);
    params.set("style", style);
    window.history.replaceState({}, "", `${window.location.pathname}?${params.toString()}`);
  }, [make, model, safeTrim, style]);

  async function copyLink() {
    await navigator.clipboard.writeText(window.location.href);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  }

  async function shareBuild() {
    const data = {
      title: "Offset Lab",
      text: `${model} ${safeTrim} • ${current.title}`,
      url: window.location.href,
    };
    if (navigator.share) {
      await navigator.share(data);
    } else {
      await copyLink();
    }
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-black px-5 py-8">
      <div className="mx-auto max-w-6xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-white/35">
            Offset Recommendation
          </p>
          <h1 className="mt-2 text-3xl font-bold md:text-4xl">Find Your Fitment</h1>
          <p className="mt-2 text-white/55">
            Choose your make, model, trim, and target style to see a recommended setup.
          </p>
        </div>

        <div className="mb-6 rounded-2xl border border-white/10 bg-white/[0.03] p-4">
          <p className="mb-3 text-sm uppercase tracking-wide text-white/40">Make</p>
          <div className="flex flex-wrap gap-2">
            {makes.map((item) => (
              <button
                key={item.label}
                disabled={!item.active}
                onClick={() => item.active && setMake(item.label)}
                className={`rounded-full border px-4 py-2 text-sm transition ${
                  item.active
                    ? "border-white/30 bg-white/[0.06] text-white"
                    : "border-white/10 bg-white/[0.02] text-white/55"
                }`}
              >
                {item.label}{!item.active ? " • Coming Soon" : ""}
              </button>
            ))}
          </div>
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
              {modelOptions.map((item) => (
                <option key={item} value={item}>{item}</option>
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
                <option key={item} value={item}>{item}</option>
              ))}
            </select>
          </SelectCard>

          <SelectCard label="Style">
            <div className="grid gap-2 sm:grid-cols-3">
              {([
                ["oemplus", "OEM+"],
                ["flush", "Flush"],
                ["aggressive", "Aggressive"],
              ] as const).map(([key, label]) => (
                <button
                  key={key}
                  onClick={() => setStyle(key)}
                  className={`rounded-xl border px-4 py-3 text-sm font-medium transition ${
                    style === key
                      ? "border-white/30 bg-white/[0.06]"
                      : "border-white/10 bg-white/[0.02] hover:border-white/20 hover:bg-white/[0.04]"
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
          </SelectCard>
        </div>

        <div className="mb-6 flex flex-wrap gap-3">
          <button
            onClick={copyLink}
            className="rounded-2xl border border-white/15 px-5 py-3 text-sm font-semibold transition hover:border-white/30 hover:bg-white/5"
          >
            {copied ? "Link Copied" : "Copy Link"}
          </button>
          <button
            onClick={shareBuild}
            className="rounded-2xl bg-white px-5 py-3 text-sm font-semibold text-black transition hover:scale-[1.02]"
          >
            Share Build
          </button>
        </div>

        <div className="grid gap-6 lg:grid-cols-[1.25fr_0.75fr]">
          <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6 md:p-8">
            <div className="flex flex-col gap-4 border-b border-white/10 pb-6 md:flex-row md:items-end md:justify-between">
              <div>
                <p className="text-sm text-white/45">{make} {model} • {safeTrim}</p>
                <h2 className="mt-1 text-2xl font-bold">{current.title}</h2>
                <p className="mt-2 text-sm text-white/55">{current.subtitle}</p>
              </div>

              <div className={`rounded-full border px-3 py-1 text-sm font-medium ${riskPill(current.risk)}`}>
                Risk: {current.risk}
              </div>
            </div>

            <div className="mt-6 grid gap-4 md:grid-cols-2">
              <SpecCard title="Front" wheel={current.front} tire={current.frontTire} />
              <SpecCard title="Rear" wheel={current.rear} tire={current.rearTire} />
            </div>

            <div className="mt-6 rounded-2xl border border-white/10 bg-black/30 p-5">
              <p className="text-sm uppercase tracking-wide text-white/40">Fitment Metrics</p>
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

            <Panel title="Verdict">
              <p className="text-base leading-7 text-white/80">{current.verdict}</p>
            </Panel>

            <Panel title="Warnings">
              <ul className="space-y-2 text-white/75">
                {current.warnings.map((warning) => <li key={warning}>• {warning}</li>)}
              </ul>
            </Panel>
          </section>

          <aside className="space-y-6">
            <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Scores</p>
              <div className="mt-5 space-y-5">
                <ScoreRow label="Visual Aggression" value={current.aggression} colorClass={scoreColor(current.aggression)} />
                <ScoreRow label="Daily Drivability" value={current.daily} colorClass={scoreColor(current.daily)} />
              </div>
            </div>

            <Panel title="Alternate Setup">
              <p className="text-xl font-semibold">{current.alternate}</p>
              <p className="mt-2 text-sm text-white/55">Good secondary option if you want a different stance or tire strategy.</p>
            </Panel>

            <Panel title="Baseline">
              <div className="space-y-2 text-white/75">
                <p>OEM Front: {trimData.baseline.front}</p>
                <p>OEM Rear: {trimData.baseline.rear}</p>
                <p>OEM Tire: {trimData.baseline.tire}</p>
                <p>Bolt Pattern: {trimData.baseline.boltPattern}</p>
                <p>Center Bore: {trimData.baseline.centerBore}</p>
              </div>
            </Panel>
          </aside>
        </div>

        <section className="mt-8 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
          <p className="text-sm uppercase tracking-wide text-white/40">Screenshot-Ready Build Card</p>
          <p className="mt-2 text-sm text-white/55">Screenshot this card and send it to friends.</p>

          <div className="mt-5 rounded-3xl border border-white/10 bg-black/50 p-6">
            <p className="text-xs uppercase tracking-[0.3em] text-white/35">Offset Lab</p>
            <h3 className="mt-4 text-2xl font-bold">{make} {model} {safeTrim}</h3>
            <p className="mt-1 text-white/60">{current.title}</p>
            <div className="mt-5 grid gap-3 sm:grid-cols-2">
              <SpecMini title="Front" wheel={current.front} tire={current.frontTire} />
              <SpecMini title="Rear" wheel={current.rear} tire={current.rearTire} />
            </div>
            <div className="mt-5 grid gap-3 sm:grid-cols-2">
              <Metric label="Aggression" value={`${current.aggression}/10`} />
              <Metric label="Daily" value={`${current.daily}/10`} />
            </div>
            <p className="mt-5 text-sm text-white/45">offsetlabfitment.com</p>
          </div>
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

function SpecCard({ title, wheel, tire }: { title: string; wheel: string; tire: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-5">
      <p className="text-sm uppercase tracking-wide text-white/40">{title}</p>
      <p className="mt-3 text-3xl font-bold">{wheel}</p>
      <p className="mt-2 text-white/70">{tire}</p>
    </div>
  );
}

function SpecMini({ title, wheel, tire }: { title: string; wheel: string; tire: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-4">
      <p className="text-xs uppercase tracking-wide text-white/35">{title}</p>
      <p className="mt-2 text-lg font-semibold">{wheel}</p>
      <p className="mt-1 text-sm text-white/65">{tire}</p>
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

function Panel({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="mt-6 rounded-2xl border border-white/10 bg-black/30 p-5">
      <p className="mb-3 text-sm uppercase tracking-wide text-white/40">{title}</p>
      {children}
    </div>
  );
}

function ScoreRow({ label, value, colorClass }: { label: string; value: number; colorClass: string }) {
  return (
    <div>
      <div className="mb-2 flex items-center justify-between">
        <p className="text-sm text-white/70">{label}</p>
        <p className={`text-sm font-semibold ${colorClass}`}>{value}/10</p>
      </div>
      <div className="h-2 rounded-full bg-white/10">
        <div className="h-2 rounded-full bg-white" style={{ width: `${value * 10}%` }} />
      </div>
    </div>
  );
}
