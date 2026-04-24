"use client";

import { useEffect, useMemo, useState } from "react";
import GalleryCard from "../components/GalleryCard";
import TrustStrip from "../components/TrustStrip";
import SubmitBuildModal from "../components/SubmitBuildModal";
import { supabase } from "../lib/supabase";
import { galleryExamples } from "../data/gallery";
import {
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
  return "text-emerald-400";
}

function riskPill(risk: string) {
  if (risk.toLowerCase().includes("moderate")) return "bg-yellow-500/15 text-yellow-300 border-yellow-500/30";
  if (risk.toLowerCase().includes("high")) return "bg-red-500/15 text-red-300 border-red-500/30";
  return "bg-emerald-500/15 text-emerald-300 border-emerald-500/30";
}

export default function FitmentPage() {
  const [make, setMake] = useState("Tesla");
  const [model, setModel] = useState<ModelKey>("Model S");
  const [trim, setTrim] = useState("Plaid");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [copied, setCopied] = useState(false);
  const [submitOpen, setSubmitOpen] = useState(false);
  const [approvedBuilds, setApprovedBuilds] = useState<any[]>([]);

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
  const builds = approvedBuilds.length > 0 ? approvedBuilds : galleryExamples[model]?.[style] ?? [];

  useEffect(() => {
    const params = new URLSearchParams();
    params.set("make", make.toLowerCase());
    params.set("model", modelSlug(model));
    params.set("trim", safeTrim);
    params.set("style", style);
    window.history.replaceState({}, "", `${window.location.pathname}?${params.toString()}`);
  }, [make, model, safeTrim, style]);

  useEffect(() => {
    async function loadApprovedBuilds() {
      try {
        const { data, error } = await supabase
          .from("build_submissions")
          .select("id, make, model, trim, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, image_url, notes, instagram_handle")
          .eq("status", "approved")
          .eq("model", model)
          .eq("trim", safeTrim);

        if (error || !data) {
          setApprovedBuilds([]);
          return;
        }

        const normalize = (value: string) => value.toLowerCase().replace(/\s+/g, "").replace("oem+", "oemplus");
        const normalizedStyle = normalize(style);
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
            sourceName: row.instagram_handle ? `@${String(row.instagram_handle).replace(/^@/, "")}` : "Offset Lab Community",
            sourceUrl: row.instagram_handle ? `https://instagram.com/${String(row.instagram_handle).replace(/^@/, "")}` : "#",
            wheel: `${String(row.front_wheel || "")}${row.rear_wheel && row.rear_wheel !== row.front_wheel ? ` / ${String(row.rear_wheel)}` : ""}`,
            tire: `${String(row.front_tire || "")}${row.rear_tire && row.rear_tire !== row.front_tire ? ` / ${String(row.rear_tire)}` : ""}`,
            suspension: "User submitted build",
            note: String(row.notes || "Approved community build"),
            verificationNote: "Approved community-submitted build matched to this model and style.",
            tags: [String(row.model || model), String(style), "Community"],
            match: "Verified Spec Match" as const,
          }));

        setApprovedBuilds(mapped);
      } catch (err) {
        console.error("Approved build load failed:", err);
        setApprovedBuilds([]);
      }
    }

    loadApprovedBuilds();
  }, [model, safeTrim, style]);

  async function copyLink() {
    await navigator.clipboard.writeText(window.location.href);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  }

  async function shareBuild() {
    const data = { title: "Offset Lab", text: `${model} ${safeTrim} • ${current.title}`, url: window.location.href };
    if (navigator.share) await navigator.share(data);
    else await copyLink();
  }

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8">
          <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">Offset Lab Gallery</p>
          <h1 className="mt-2 text-3xl font-bold md:text-5xl">
            {model} {safeTrim} <span className="text-emerald-400">| {current.title}</span>
          </h1>
          <p className="mt-3 text-white/55">
            Real-world visual references paired with specs, scores, and fitment notes.
          </p>
        </div>

        <div className="grid gap-6 lg:grid-cols-[320px_1fr]">
          <aside className="space-y-5">
            <Panel title="1. Select Make">
              <div className="flex flex-wrap gap-2">
                {makes.map((item) => (
                  <button key={item.label} disabled={!item.active} onClick={() => item.active && setMake(item.label)}
                    className={`rounded-xl border px-3 py-2 text-sm ${item.active ? "border-emerald-400/40 bg-emerald-400/10 text-white" : "border-white/10 bg-white/[0.02] text-white/45"}`}>
                    {item.label}{!item.active ? " • Soon" : ""}
                  </button>
                ))}
              </div>
            </Panel>

            <Panel title="2. Select Vehicle">
              <div className="space-y-3">
                <select value={model} onChange={(e) => { const next = e.target.value as ModelKey; setModel(next); setTrim(getTrims(next)[0]); }} className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
                  {modelOptions.map((item) => <option key={item} value={item}>{item}</option>)}
                </select>
                <select value={safeTrim} onChange={(e) => setTrim(e.target.value)} className="w-full rounded-xl border border-white/10 bg-black/40 px-4 py-3 outline-none">
                  {trims.map((item) => <option key={item} value={item}>{item}</option>)}
                </select>
              </div>
            </Panel>

            <Panel title="3. Select Style">
              <div className="space-y-2">
                {([["oemplus", "OEM+", "Subtle & Clean"], ["flush", "Flush", "Balanced stance"], ["aggressive", "Aggressive", "Max fitment"]] as const).map(([key, label, sub]) => (
                  <button key={key} onClick={() => setStyle(key)} className={`w-full rounded-2xl border p-4 text-left transition ${style === key ? "border-emerald-400/60 bg-emerald-400/10" : "border-white/10 bg-black/30 hover:border-white/25"}`}>
                    <p className="font-semibold">{label}</p>
                    <p className="mt-1 text-sm text-white/45">{sub}</p>
                  </button>
                ))}
              </div>
            </Panel>

            <Panel title="4. Your Fitment">
              <div className="space-y-4">
                <FitLine label="Front" wheel={current.front} tire={current.frontTire} />
                <FitLine label="Rear" wheel={current.rear} tire={current.rearTire} />
              </div>
              <button onClick={copyLink} className="mt-5 w-full rounded-2xl border border-white/15 px-4 py-3 text-sm font-semibold hover:bg-white/5">{copied ? "Link Copied" : "Copy Link"}</button>
              <button onClick={shareBuild} className="mt-3 w-full rounded-2xl bg-emerald-400 px-4 py-3 text-sm font-bold text-black hover:bg-emerald-300">Share Build</button>
            </Panel>

            <Panel title="Fitment Summary">
              <div className="space-y-3 text-sm text-white/70">
                <p>Risk: <span className={`rounded-full border px-2 py-1 ${riskPill(current.risk)}`}>{current.risk}</span></p>
                <p>Visual Aggression: <span className={scoreColor(current.aggression)}>{current.aggression}/10</span></p>
                <p>Daily Drivability: <span className={scoreColor(current.daily)}>{current.daily}/10</span></p>
                <p>Bolt Pattern: {trimData.baseline.boltPattern}</p>
                <p>Center Bore: {trimData.baseline.centerBore}</p>
              </div>
            </Panel>
          </aside>

          <section>
            <div className="mb-6 grid gap-4 md:grid-cols-3">
              <Metric label="Front Poke" value={current.pokeFront} />
              <Metric label="Rear Poke" value={current.pokeRear} />
              <Metric label="Diameter" value={current.diameter} />
            </div>

            <div className="mb-6 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <p className="text-sm uppercase tracking-wide text-white/40">Verdict</p>
              <p className="mt-3 text-lg leading-8 text-white/80">{current.verdict}</p>
            </div>

            <div className="grid gap-6">
              {builds.map((build) => <GalleryCard key={build.label} build={build} />)}
            </div>

            <section className="mt-8 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
              <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                <div>
                  <p className="text-xl font-bold">Have a setup like this?</p>
                  <p className="mt-2 text-sm text-white/55">Share your build with the community and get featured.</p>
                </div>
                <button onClick={() => setSubmitOpen(true)} className="rounded-2xl border border-emerald-400/40 px-5 py-3 text-center font-semibold text-emerald-300 hover:bg-emerald-400/10">Submit Your Build</button>
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
          model,
          trim: safeTrim,
          fitmentStyle: style,
          frontWheel: current.front,
          rearWheel: current.rear,
          frontTire: current.frontTire,
          rearTire: current.rearTire,
        }}
      />
    </main>
  );
}

function Panel({ title, children }: { title: string; children: React.ReactNode }) {
  return <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-5"><p className="mb-4 text-sm font-semibold uppercase tracking-wide text-white/80">{title}</p>{children}</div>;
}

function FitLine({ label, wheel, tire }: { label: string; wheel: string; tire: string }) {
  return <div className="border-b border-white/10 pb-3 last:border-b-0"><p className="text-xs uppercase tracking-wide text-white/35">{label}</p><p className="mt-1 text-lg font-bold">{wheel}</p><p className="text-sm text-white/60">{tire}</p></div>;
}

function Metric({ label, value }: { label: string; value: string }) {
  return <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-5"><p className="text-xs uppercase tracking-wide text-white/35">{label}</p><p className="mt-2 text-2xl font-bold">{value}</p></div>;
}
