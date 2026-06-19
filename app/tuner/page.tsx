"use client";

import { useEffect, useMemo, useState } from "react";
import { compareWheelFitment, parseWheelSpec, WheelSpec } from "../lib/compareMath";

type PresetKey = "daily" | "aggressive" | "track";

type TunerState = {
  width: number;
  offset: number;
  tireWidth: number;
  camber: number;
  rideHeight: number;
};

const PRESETS: Record<PresetKey, TunerState> = {
  daily: { width: 9.5, offset: 45, tireWidth: 255, camber: -1.2, rideHeight: -10 },
  aggressive: { width: 10.5, offset: 38, tireWidth: 285, camber: -2.1, rideHeight: -25 },
  track: { width: 10.5, offset: 42, tireWidth: 285, camber: -2.7, rideHeight: -20 },
};

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max);
}

function readWheel(value: string | null, fallback: WheelSpec) {
  return (value && parseWheelSpec(value)) || fallback;
}

function readTireWidth(value: string | null, fallback: number) {
  const match = value?.match(/^(\d{3})/);
  return match ? Number(match[1]) : fallback;
}

function formatSigned(value: number, suffix = "") {
  const rounded = Math.round(value * 10) / 10;
  return `${rounded > 0 ? "+" : ""}${rounded}${suffix}`;
}

function statusFor(innerClearance: number, poke: number) {
  if (innerClearance < 3 || poke > 22) {
    return { label: "Needs Work", color: "text-red-300", border: "border-red-500/30 bg-red-500/10" };
  }
  if (innerClearance < 7 || poke > 14) {
    return { label: "Aggressive", color: "text-amber-300", border: "border-amber-400/30 bg-amber-400/10" };
  }
  return { label: "Dialed", color: "text-emerald-300", border: "border-emerald-400/30 bg-emerald-400/10" };
}

function Slider({
  label,
  value,
  min,
  max,
  step,
  display,
  onChange,
}: {
  label: string;
  value: number;
  min: number;
  max: number;
  step: number;
  display: string;
  onChange: (value: number) => void;
}) {
  const progress = ((value - min) / (max - min)) * 100;

  return (
    <label className="block border-b border-white/10 py-5 last:border-b-0">
      <span className="mb-4 flex items-center justify-between gap-4">
        <span className="text-[11px] font-black uppercase tracking-[0.17em] text-white/45">
          {label}
        </span>
        <span className="font-mono text-sm font-black text-white">{display}</span>
      </span>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(event) => onChange(Number(event.target.value))}
        className="h-1.5 w-full cursor-pointer appearance-none rounded-full bg-white/10 accent-red-500"
        style={{
          background: `linear-gradient(to right, #ef4444 0%, #ef4444 ${progress}%, rgba(255,255,255,.1) ${progress}%, rgba(255,255,255,.1) 100%)`,
        }}
      />
      <span className="mt-2 flex justify-between text-[9px] font-bold uppercase tracking-widest text-white/20">
        <span>{min}</span>
        <span>{max}</span>
      </span>
    </label>
  );
}

function InsightRow({
  label,
  value,
  verdict,
  tone = "neutral",
}: {
  label: string;
  value: string;
  verdict: string;
  tone?: "safe" | "tight" | "warn" | "neutral";
}) {
  const toneClass = {
    safe: "text-emerald-300",
    tight: "text-amber-300",
    warn: "text-red-300",
    neutral: "text-white/55",
  }[tone];

  return (
    <div className="flex items-end justify-between gap-4 border-b border-white/10 py-4 last:border-0">
      <div>
        <p className="text-[10px] font-black uppercase tracking-[0.15em] text-white/30">{label}</p>
        <p className="mt-1 text-xl font-black text-white">{value}</p>
      </div>
      <span className={`text-[10px] font-black uppercase tracking-[0.14em] ${toneClass}`}>
        {verdict}
      </span>
    </div>
  );
}

function LiveCrossSection({
  selected,
  baseline,
  outerChange,
  innerClearance,
  camber,
}: {
  selected: TunerState;
  baseline: WheelSpec;
  outerChange: number;
  innerClearance: number;
  camber: number;
}) {
  const tireScale = clamp(selected.tireWidth / 285, 0.8, 1.18);
  const tireWidth = 142 * tireScale;
  // Match the suspension asset's hub face so the wheel barrel visibly mounts
  // to the hub instead of floating beside it.
  const tireX = 256;
  const tireOuter = tireX + tireWidth;
  const baselineWidth = 142 * clamp((baseline.width * 25.4 + 12) / 285, 0.78, 1.16);
  const baselineX = tireOuter - outerChange - baselineWidth;
  const fenderX = tireOuter - clamp(outerChange * 0.35, -8, 11);
  const indicator = clamp(50 + outerChange * 1.35, 5, 95);

  return (
    <div className="overflow-hidden rounded-[1.5rem] border border-white/10 bg-[radial-gradient(circle_at_62%_43%,rgba(59,130,246,.09),transparent_36%),linear-gradient(145deg,rgba(255,255,255,.035),transparent)]">
      <svg
        viewBox="0 0 620 500"
        className="block h-auto min-h-[440px] w-full"
        role="img"
        aria-label={`Live wheel cross-section. Outer position ${formatSigned(outerChange, " millimeters")}, inner clearance ${Math.round(innerClearance)} millimeters.`}
      >
        <defs>
          <marker id="tunerArrow" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse">
            <path d="M0 0 L10 5 L0 10z" fill="#fff" />
          </marker>
        </defs>

        <text x="38" y="42" fill="#9097a3" fontSize="11" fontWeight="800" letterSpacing="1.5">INBOARD</text>
        <path d="M38 55 H96 M38 55 l10 -6 M38 55 l10 6" stroke="#78808c" strokeWidth="1.5" />
        <text x="582" y="42" fill="#9097a3" fontSize="11" fontWeight="800" letterSpacing="1.5" textAnchor="end">OUTBOARD</text>
        <path d="M524 55 H582 M582 55 l-10 -6 M582 55 l-10 6" stroke="#78808c" strokeWidth="1.5" />

        <image href="/fitment-suspension-mockup.png" x="34" y="82" width="360" height="330" preserveAspectRatio="xMidYMid meet" />

        <rect
          x={baselineX}
          y="94"
          width={baselineWidth}
          height="316"
          rx="54"
          fill="none"
          stroke="#a4a7ae"
          strokeWidth="2"
          strokeDasharray="8 8"
          opacity="0.52"
        />

        <g transform={`rotate(${camber * 0.65} ${tireX + tireWidth / 2} 250)`}>
          <image
            href="/fitment-tire-mockup.png"
            x={tireX}
            y="82"
            width={tireWidth}
            height="330"
            preserveAspectRatio="none"
          />
        </g>

        <rect
          x={Math.min(tireOuter, fenderX)}
          y="86"
          width={Math.max(Math.abs(fenderX - tireOuter), 2)}
          height="326"
          fill="#ef4444"
          opacity="0.14"
        />
        <line x1={fenderX} y1="78" x2={fenderX} y2="418" stroke="#fb4b55" strokeWidth="3" />
        <text x={fenderX} y="70" fill="#fb6b73" fontSize="12" fontWeight="900" textAnchor="middle">FENDER LINE</text>

        <line
          x1={Math.min(tireOuter, fenderX)}
          y1="178"
          x2={Math.max(tireOuter, fenderX)}
          y2="178"
          stroke="#fff"
          strokeWidth="2"
          markerStart="url(#tunerArrow)"
          markerEnd="url(#tunerArrow)"
        />
        <text x={Math.min(tireOuter + 18, 510)} y="204" fill="#aeb4bd" fontSize="10" fontWeight="800">OUTER POSITION</text>
        <text x={Math.min(tireOuter + 18, 510)} y="230" fill="#fff" fontSize="22" fontWeight="900">
          {formatSigned(outerChange, " mm")}
        </text>

        <line x1="46" y1="451" x2="574" y2="451" stroke="#747b86" strokeWidth="1.5" />
        <line x1="178" y1="444" x2="178" y2="458" stroke="#747b86" />
        <line x1="310" y1="444" x2="310" y2="458" stroke="#747b86" />
        <line x1="442" y1="444" x2="442" y2="458" stroke="#747b86" />
        <circle cx={46 + (528 * indicator) / 100} cy="451" r="9" fill="#fb4b55" />
        <text x="46" y="480" fill="#a2a8b2" fontSize="11" fontWeight="800">TUCKED</text>
        <text x="310" y="480" fill="#a2a8b2" fontSize="11" fontWeight="800" textAnchor="middle">FLUSH</text>
        <text x="574" y="480" fill="#fb6069" fontSize="11" fontWeight="800" textAnchor="end">POKE</text>
      </svg>

      <div className="grid border-t border-white/10 text-[10px] font-black uppercase tracking-[0.14em] sm:grid-cols-3">
        <div className="border-b border-white/10 px-5 py-4 text-white/35 sm:border-b-0 sm:border-r">
          Factory <span className="ml-2 text-white/65">{baseline.width}J +{baseline.offset}</span>
        </div>
        <div className="border-b border-white/10 px-5 py-4 text-red-300 sm:border-b-0 sm:border-r">
          Selected <span className="ml-2 text-white">{selected.width}J +{selected.offset}</span>
        </div>
        <div className="px-5 py-4 text-white/35">
          Inner Clearance <span className="ml-2 text-white">{Math.round(innerClearance)} mm</span>
        </div>
      </div>
    </div>
  );
}

export default function TunerPage() {
  const [setup, setSetup] = useState<TunerState>(PRESETS.aggressive);
  const [preset, setPreset] = useState<PresetKey>("aggressive");
  const [modifiedSuspension, setModifiedSuspension] = useState(true);
  const [vehicle, setVehicle] = useState("Porsche 992 GT3");
  const [baseline, setBaseline] = useState<WheelSpec>({ width: 9.5, offset: 50 });
  const [tireRatio, setTireRatio] = useState(30);
  const [diameter, setDiameter] = useState(20);
  const [context, setContext] = useState<Record<string, string>>({});

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const front = readWheel(params.get("front"), PRESETS.aggressive);
    const factory = readWheel(params.get("factoryFront"), {
      width: Math.max(front.width - 1, 8),
      offset: front.offset + 10,
    });
    const tire = params.get("frontTire");
    const tireMatch = tire?.match(/^(\d{3})\/(\d{2})R(\d{2})$/i);
    const make = params.get("make");
    const model = params.get("model");
    const trim = params.get("trim");

    setSetup((current) => ({
      ...current,
      width: front.width,
      offset: front.offset,
      tireWidth: readTireWidth(tire, current.tireWidth),
    }));
    setBaseline(factory);
    if (tireMatch) {
      setTireRatio(Number(tireMatch[2]));
      setDiameter(Number(tireMatch[3]));
    }
    if (make || model || trim) {
      setVehicle([make, model, trim].filter(Boolean).join(" "));
    }
    setContext(Object.fromEntries(params.entries()));
  }, []);

  const comparison = useMemo(
    () => compareWheelFitment(baseline, { width: setup.width, offset: setup.offset }),
    [baseline, setup.width, setup.offset]
  );
  const innerClearance = Math.round(18 + comparison.innerClearanceChangeMm - Math.abs(setup.camber) * 0.8);
  const fenderClearance = Math.round(12 - Math.max(comparison.outerChangeMm, 0) * 0.38 + Math.abs(setup.camber) * 0.7);
  const status = statusFor(innerClearance, comparison.outerChangeMm);
  const confidence = clamp(
    96 - Math.max(0, 6 - innerClearance) * 3 - Math.max(0, comparison.outerChangeMm - 15),
    62,
    96
  );

  function update(key: keyof TunerState, value: number) {
    setPreset("aggressive");
    setSetup((current) => ({ ...current, [key]: value }));
  }

  function applyPreset(key: PresetKey) {
    setPreset(key);
    setSetup(PRESETS[key]);
  }

  const compareHref = useMemo(() => {
    const params = new URLSearchParams(context);
    const wheel = `${diameter}x${setup.width} +ET${setup.offset}`;
    const tire = `${setup.tireWidth}/${tireRatio}R${diameter}`;
    params.set("front", wheel);
    params.set("rear", params.get("rear") || wheel);
    params.set("frontTire", tire);
    params.set("rearTire", params.get("rearTire") || tire);
    params.set("title", "Custom Tuned Setup");
    params.set("verdict", `${status.label} live-tuned fitment with ${formatSigned(comparison.outerChangeMm, " mm")} outer movement.`);
    return `/compare?${params.toString()}`;
  }, [context, diameter, setup, tireRatio, status.label, comparison.outerChangeMm]);

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050506] text-white">
      <section className="border-b border-white/10 bg-[radial-gradient(circle_at_50%_-20%,rgba(239,68,68,.12),transparent_38%)]">
        <div className="mx-auto max-w-[1500px] px-5 py-10 lg:px-8 lg:py-14">
          <div className="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <p className="text-xs font-black uppercase tracking-[0.3em] text-red-500">Offset Lab Experimental</p>
              <h1 className="mt-3 text-4xl font-black tracking-[-0.045em] sm:text-6xl">
                Live Fitment <span className="text-red-500">Tuner.</span>
              </h1>
              <p className="mt-4 max-w-2xl text-base leading-7 text-white/50">
                Dial in your stance and see every millimeter move in real time.
              </p>
            </div>
            <div className="rounded-xl border border-white/10 bg-white/[0.035] px-5 py-3">
              <p className="text-[10px] font-black uppercase tracking-[0.17em] text-white/30">Current Platform</p>
              <p className="mt-1 font-black">{vehicle}</p>
            </div>
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-[1500px] px-5 py-8 lg:px-8 lg:py-10">
        <div className="grid gap-6 xl:grid-cols-[290px_minmax(0,1fr)_300px]">
          <aside className="rounded-[1.6rem] border border-white/10 bg-white/[0.025] p-5">
            <p className="text-xs font-black uppercase tracking-[0.23em] text-white/50">Setup Controls</p>
            <div className="mt-5 grid grid-cols-3 rounded-lg border border-white/10 bg-black/40 p-1">
              {(["daily", "aggressive", "track"] as PresetKey[]).map((key) => (
                <button
                  key={key}
                  type="button"
                  onClick={() => applyPreset(key)}
                  className={`rounded-md px-2 py-2 text-[9px] font-black uppercase tracking-[0.1em] transition ${
                    preset === key ? "bg-red-600 text-white" : "text-white/35 hover:text-white"
                  }`}
                >
                  {key}
                </button>
              ))}
            </div>

            <div className="mt-3">
              <Slider label="Wheel Width" value={setup.width} min={7} max={14} step={0.5} display={`${setup.width} in`} onChange={(value) => update("width", value)} />
              <Slider label="Offset" value={setup.offset} min={0} max={65} step={1} display={`+${setup.offset} mm`} onChange={(value) => update("offset", value)} />
              <Slider label="Tire Width" value={setup.tireWidth} min={205} max={355} step={5} display={`${setup.tireWidth} mm`} onChange={(value) => update("tireWidth", value)} />
              <Slider label="Camber" value={setup.camber} min={-5} max={0} step={0.1} display={`${setup.camber.toFixed(1)}°`} onChange={(value) => update("camber", value)} />
              <Slider label="Ride Height" value={setup.rideHeight} min={-60} max={0} step={5} display={`${setup.rideHeight} mm`} onChange={(value) => update("rideHeight", value)} />
            </div>

            <button
              type="button"
              role="switch"
              aria-checked={modifiedSuspension}
              onClick={() => setModifiedSuspension((value) => !value)}
              className="mt-4 flex w-full items-center justify-between rounded-xl border border-white/10 bg-black/30 px-4 py-3 text-left"
            >
              <span>
                <span className="block text-[10px] font-black uppercase tracking-[0.14em] text-white/45">Modified Suspension</span>
                <span className="mt-1 block text-[10px] text-white/25">{modifiedSuspension ? "Clearance model adjusted" : "Factory geometry"}</span>
              </span>
              <span className={`relative h-6 w-11 rounded-full transition ${modifiedSuspension ? "bg-red-600" : "bg-white/10"}`}>
                <span className={`absolute top-1 h-4 w-4 rounded-full bg-white transition ${modifiedSuspension ? "left-6" : "left-1"}`} />
              </span>
            </button>
          </aside>

          <section className="min-w-0 rounded-[1.6rem] border border-white/10 bg-white/[0.025] p-4 sm:p-5">
            <div className="mb-5 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p className="text-xs font-black uppercase tracking-[0.23em] text-white/50">Live Cross-Section</p>
                <p className="mt-1 text-sm text-white/30">Dashed outline shows the factory baseline.</p>
              </div>
              <span className={`w-fit rounded-full border px-4 py-2 text-[10px] font-black uppercase tracking-[0.16em] ${status.border} ${status.color}`}>
                {status.label}
              </span>
            </div>
            <LiveCrossSection
              selected={setup}
              baseline={baseline}
              outerChange={comparison.outerChangeMm}
              innerClearance={innerClearance}
              camber={setup.camber}
            />
          </section>

          <aside className="rounded-[1.6rem] border border-white/10 bg-white/[0.025] p-5">
            <p className="text-xs font-black uppercase tracking-[0.23em] text-white/50">Fitment Status</p>
            <div className="mt-5 rounded-2xl border border-white/10 bg-black/35 p-5 text-center">
              <p className={`text-3xl font-black uppercase tracking-[-0.03em] ${status.color}`}>{status.label}</p>
              <p className="mt-2 text-xs font-bold text-white/30">{Math.round(confidence)}% calculated confidence</p>
            </div>

            <div className="mt-4">
              <InsightRow label="Fender Clearance" value={`${fenderClearance} mm`} verdict={fenderClearance >= 5 ? "Safe" : "Tight"} tone={fenderClearance >= 5 ? "safe" : "tight"} />
              <InsightRow label="Inner Clearance" value={`${innerClearance} mm`} verdict={innerClearance >= 7 ? "Safe" : innerClearance >= 3 ? "Tight" : "Risk"} tone={innerClearance >= 7 ? "safe" : innerClearance >= 3 ? "tight" : "warn"} />
              <InsightRow label="Outer Movement" value={formatSigned(comparison.outerChangeMm, " mm")} verdict={comparison.outerChangeMm > 14 ? "Aggressive" : "Balanced"} tone={comparison.outerChangeMm > 14 ? "tight" : "neutral"} />
              <InsightRow label="Track Width" value={formatSigned(comparison.trackChangeMm, " mm")} verdict="Per Axle" />
            </div>

            <div className="mt-5 border-t border-white/10 pt-5">
              <p className="text-[10px] font-black uppercase tracking-[0.17em] text-white/30">What You&apos;ll Need</p>
              <div className="mt-3 flex flex-wrap gap-2">
                <span className="rounded-md border border-white/10 bg-white/[0.04] px-2.5 py-2 text-[10px] font-bold text-white/60">{Math.abs(setup.camber).toFixed(1)}° camber</span>
                {setup.rideHeight <= -20 ? <span className="rounded-md border border-white/10 bg-white/[0.04] px-2.5 py-2 text-[10px] font-bold text-white/60">Alignment</span> : null}
                {innerClearance < 7 ? <span className="rounded-md border border-amber-400/20 bg-amber-400/[0.06] px-2.5 py-2 text-[10px] font-bold text-amber-200">Clearance check</span> : null}
                {comparison.outerChangeMm > 20 ? <span className="rounded-md border border-red-500/20 bg-red-500/[0.06] px-2.5 py-2 text-[10px] font-bold text-red-200">Fender work</span> : null}
              </div>
            </div>

            <a
              href={compareHref}
              className="mt-6 flex w-full items-center justify-center rounded-lg bg-red-600 px-4 py-4 text-[11px] font-black uppercase tracking-[0.15em] transition hover:bg-red-500"
            >
              Compare With Factory
            </a>
            <p className="mt-3 text-center text-[10px] leading-4 text-white/25">
              Calculated guidance only. Verify physical clearances before installation.
            </p>
          </aside>
        </div>
      </section>
    </main>
  );
}
