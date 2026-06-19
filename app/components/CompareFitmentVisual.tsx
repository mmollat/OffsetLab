"use client";

import { useEffect, useMemo, useState } from "react";

type Props = {
  baselineFront?: string;
  baselineRear?: string;
  selectedFront: string;
  selectedRear?: string;
  baselineTire?: string;
  selectedTire?: string;
  selectedRearTire?: string;
  oemFront?: string;
};

type WheelSpec = {
  width: number;
  diameter: number;
  offset: number;
};

type TireSpec = {
  width: number;
  aspect: number;
  diameter: number;
};

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max);
}

function parseWheel(spec?: string): WheelSpec | null {
  if (!spec) return null;

  const match = spec.match(
    /(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+|et)?\s*(-?\d+)/i
  );
  if (!match) return null;

  return {
    diameter: Number(match[1]),
    width: Number(match[2]),
    offset: Number(match[3]),
  };
}

function parseTire(spec?: string): TireSpec | null {
  if (!spec) return null;

  const match = spec.match(/(\d{3})\/(\d{2})R(\d{2})/i);
  if (!match) return null;

  return {
    width: Number(match[1]),
    aspect: Number(match[2]),
    diameter: Number(match[3]),
  };
}

function formatMm(value: number) {
  const rounded = Math.round(value);
  return `${rounded > 0 ? "+" : ""}${rounded}mm`;
}

function tireDiameter(spec: TireSpec | null) {
  if (!spec) return null;
  return spec.diameter * 25.4 + 2 * spec.width * (spec.aspect / 100);
}

export default function CompareFitmentVisual({
  baselineFront,
  baselineRear,
  selectedFront,
  selectedRear,
  baselineTire,
  selectedTire,
  selectedRearTire,
  oemFront,
}: Props) {
  const [axle, setAxle] = useState<"front" | "rear">("front");
  const [reveal, setReveal] = useState(0);
  const [playing, setPlaying] = useState(false);

  useEffect(() => {
    if (!playing) return;

    let direction = reveal >= 98 ? -1 : 1;
    const timer = window.setInterval(() => {
      setReveal((current) => {
        if (current >= 100) direction = -1;
        if (current <= 0) direction = 1;
        return clamp(current + direction * 1.4, 0, 100);
      });
    }, 24);

    return () => window.clearInterval(timer);
  }, [playing]);

  const comparison = useMemo(() => {
    const baselineWheel =
      parseWheel(
        axle === "rear" ? baselineRear || baselineFront : baselineFront || oemFront
      ) ?? { diameter: 18, width: 8, offset: 40 };
    const selectedWheel =
      parseWheel(axle === "rear" ? selectedRear || selectedFront : selectedFront) ??
      baselineWheel;
    const factoryTire = parseTire(baselineTire);
    const newTire = parseTire(
      axle === "rear" ? selectedRearTire || selectedTire : selectedTire
    );

    const baselineWidth = baselineWheel.width * 25.4;
    const selectedWidth = selectedWheel.width * 25.4;
    const innerIntrusion =
      selectedWidth / 2 +
      selectedWheel.offset -
      (baselineWidth / 2 + baselineWheel.offset);
    const outerPoke =
      selectedWidth / 2 -
      selectedWheel.offset -
      (baselineWidth / 2 - baselineWheel.offset);

    return {
      baselineWheel,
      selectedWheel,
      factoryTire,
      newTire,
      outerPoke,
      innerClearance: -innerIntrusion,
      trackChange: outerPoke * 2,
      diameterChange:
        tireDiameter(newTire) !== null && tireDiameter(factoryTire) !== null
          ? (tireDiameter(newTire) as number) -
            (tireDiameter(factoryTire) as number)
          : null,
    };
  }, [
    axle,
    baselineFront,
    baselineRear,
    baselineTire,
    oemFront,
    selectedFront,
    selectedRear,
    selectedRearTire,
    selectedTire,
  ]);

  const baselineTireWidth =
    comparison.factoryTire?.width ?? comparison.baselineWheel.width * 25.4;
  const selectedTireWidth =
    comparison.newTire?.width ?? comparison.selectedWheel.width * 25.4;
  const suspensionX = 45;
  const suspensionWidth = 430;
  const hubMountX = suspensionX + suspensionWidth * (210 / 340);
  const baseTireX = hubMountX - 18;
  const tireHeight = 330;
  const baselineRenderWidth = 122 * clamp(baselineTireWidth / 285, 0.76, 1.26);
  const selectedRenderWidth = 122 * clamp(selectedTireWidth / 285, 0.76, 1.26);
  const selectedShift = clamp(comparison.innerClearance * 0.7, -16, 16);
  const baselineOuter = baseTireX + baselineRenderWidth;
  const selectedX = baseTireX + selectedShift;
  const selectedOuter = selectedX + selectedRenderWidth;
  const measureStart = Math.min(baselineOuter, selectedOuter);
  const measureEnd = Math.max(baselineOuter, selectedOuter);
  const animatedOuter = comparison.outerPoke * (reveal / 100);
  const animatedInner = comparison.innerClearance * (reveal / 100);
  const animatedTrack = comparison.trackChange * (reveal / 100);
  const arrowId = `compare-arrow-${axle}`;
  const factoryWheelLabel = `${comparison.baselineWheel.diameter}x${comparison.baselineWheel.width} +${comparison.baselineWheel.offset}`;
  const selectedWheelLabel = `${comparison.selectedWheel.diameter}x${comparison.selectedWheel.width} +${comparison.selectedWheel.offset}`;
  const factoryTireLabel = comparison.factoryTire?.width ?? Math.round(baselineTireWidth);
  const selectedTireLabel = comparison.newTire?.width ?? Math.round(selectedTireWidth);
  const progress = reveal / 100;
  const animatedX = baseTireX + (selectedX - baseTireX) * progress;
  const animatedWidth =
    baselineRenderWidth + (selectedRenderWidth - baselineRenderWidth) * progress;
  const animatedWheelOuter = animatedX + animatedWidth;
  const summary =
    comparison.innerClearance < 0
      ? `Selected sits ${Math.abs(Math.round(comparison.outerPoke))} mm farther outward and ${Math.abs(Math.round(comparison.innerClearance))} mm closer inside.`
      : `Selected sits ${Math.abs(Math.round(comparison.outerPoke))} mm farther outward with ${Math.abs(Math.round(comparison.innerClearance))} mm more inner clearance.`;

  return (
    <section className="overflow-hidden rounded-[1.5rem] border border-white/10 bg-[#090a0d]">
      <div className="flex flex-col gap-4 border-b border-white/10 px-5 py-5 sm:flex-row sm:items-start sm:justify-between md:px-6">
        <div>
          <p className="text-[10px] font-black uppercase tracking-[0.24em] text-red-400/70">
            Interactive Comparison
          </p>
          <h2 className="mt-1 text-xl font-black tracking-tight">
            Factory vs Selected
          </h2>
          <p className="mt-1 text-xs text-white/35">Drag to move the wheel from factory geometry to the selected setup.</p>
          <div className="mt-3 flex gap-2">
            {(["front", "rear"] as const).map((item) => (
              <button
                key={item}
                type="button"
                onClick={() => setAxle(item)}
                className={`rounded-lg border px-4 py-2 text-[10px] font-black uppercase tracking-[0.18em] transition ${
                  axle === item
                    ? "border-red-500/60 bg-red-500/10 text-red-400"
                    : "border-white/10 text-white/35 hover:text-white"
                }`}
              >
                {item}
              </button>
            ))}
          </div>
        </div>

        <div className="flex flex-wrap gap-x-5 gap-y-2 text-xs text-white/45">
          <span className="flex items-center gap-2">
            <i className="h-0.5 w-8 border-t border-dashed border-white/40" />
            Factory
          </span>
          <span className="flex items-center gap-2">
            <i className="h-0.5 w-8 bg-red-500" />
            Selected
          </span>
        </div>
      </div>

      <div className="grid xl:grid-cols-[1fr_210px]">
        <div className="border-b border-white/10 xl:border-b-0 xl:border-r">
          <div className="relative min-h-[430px] overflow-hidden">
          <svg
            viewBox="0 0 620 440"
            className="absolute inset-0 h-full w-full"
            role="img"
            aria-label={`${axle} wheel moving from factory to selected fitment, ${Math.round(reveal)} percent selected`}
          >
            <defs>
              <marker
                id={arrowId}
                viewBox="0 0 10 10"
                refX="5"
                refY="5"
                markerWidth="5"
                markerHeight="5"
                orient="auto-start-reverse"
              >
                <path d="M 0 0 L 10 5 L 0 10 z" fill="#ef4444" />
              </marker>
              <filter id={`factory-muted-${axle}`}>
                <feColorMatrix type="saturate" values="0" />
              </filter>
            </defs>

            <text x="42" y="44" fill="#9097a3" fontSize="11" fontWeight="700" letterSpacing="1.3">
              INBOARD
            </text>
            <path d="M42 56 H98" stroke="#777f8c" strokeWidth="1.5" />
            <path d="M42 56 l9 -5 M42 56 l9 5" stroke="#777f8c" strokeWidth="1.5" />
            <text
              x="578"
              y="44"
              fill="#9097a3"
              fontSize="11"
              fontWeight="700"
              letterSpacing="1.3"
              textAnchor="end"
            >
              OUTBOARD
            </text>
            <path d="M522 56 H578" stroke="#777f8c" strokeWidth="1.5" />
            <path d="M578 56 l-9 -5 M578 56 l-9 5" stroke="#777f8c" strokeWidth="1.5" />

            <image
              href="/fitment-suspension-mockup.png"
              x={suspensionX}
              y="55"
              width={suspensionWidth}
              height={tireHeight}
              preserveAspectRatio="xMidYMid meet"
            />

            <rect
              x={baseTireX}
              y="55"
              width={baselineRenderWidth}
              height={tireHeight}
              rx="34"
              fill="rgba(255,255,255,.018)"
              stroke="rgba(255,255,255,.35)"
              strokeWidth="2"
              strokeDasharray="8 7"
            />
            <rect x="34" y="70" width="112" height="27" rx="13.5" fill="rgba(255,255,255,.055)" stroke="rgba(255,255,255,.16)" />
            <text
              x="90"
              y="88"
              fill="rgba(255,255,255,0.58)"
              fontSize="10"
              fontWeight="800"
              letterSpacing="1"
              textAnchor="middle"
            >
              FACTORY
            </text>

            <line
              x1={baselineOuter}
              y1="78"
              x2={baselineOuter}
              y2="365"
              stroke="rgba(255,255,255,0.35)"
              strokeDasharray="6 6"
              strokeWidth="1.5"
            />

            <image
              href="/fitment-tire-mockup.png"
              x={animatedX}
              y="55"
              width={animatedWidth}
              height={tireHeight}
              preserveAspectRatio="none"
            />
            <line x1={animatedWheelOuter} y1="78" x2={animatedWheelOuter} y2="365" stroke="#ef4444" strokeWidth="2" />
            <line
              x1={baselineOuter}
              y1="112"
              x2={animatedWheelOuter}
              y2="112"
              stroke="#ef4444"
              strokeWidth="2"
              markerStart={`url(#${arrowId})`}
              markerEnd={`url(#${arrowId})`}
            />
            <text
              x={(baselineOuter + animatedWheelOuter) / 2}
              y="97"
              fill="#fb6b73"
              fontSize="12"
              fontWeight="800"
              textAnchor="middle"
            >
              {formatMm(animatedOuter)}
            </text>
            <rect x="474" y="70" width="112" height="27" rx="13.5" fill="#190d0f" stroke="#ef4444" strokeOpacity="0.8" />
            <text x="530" y="88" fill="#fb636c" fontSize="10" fontWeight="800" letterSpacing="1" textAnchor="middle">
              {reveal < 4 ? "FACTORY" : reveal > 96 ? "SELECTED" : "MOVING"}
            </text>

            <text x="38" y="414" fill="rgba(255,255,255,.42)" fontSize="10" fontWeight="800" letterSpacing="1">FACTORY</text>
            <text x="582" y="414" fill="#fb636c" fontSize="10" fontWeight="800" letterSpacing="1" textAnchor="end">SELECTED</text>
          </svg>

          </div>

          <div className="border-t border-white/10 bg-white/[0.018] px-5 pt-4">
            <div className="flex items-center justify-center gap-3 rounded-lg border border-red-500/20 bg-red-500/[0.055] px-4 py-3 text-center">
              <span className="text-red-400">←</span>
              <p className="text-[10px] font-black uppercase tracking-[0.13em] text-white/65">
                Drag the slider to watch factory fitment become selected
              </p>
              <span className="text-red-400">→</span>
            </div>
          </div>

          <div className="flex items-center gap-4 px-5 py-4">
            <button
              type="button"
              onClick={() => setPlaying((current) => !current)}
              className="grid h-10 w-10 shrink-0 place-items-center rounded-full border border-red-500/40 bg-red-500/10 text-sm text-red-300 transition hover:bg-red-500/20"
              aria-label={playing ? "Pause comparison animation" : "Play comparison animation"}
            >
              {playing ? "Ⅱ" : "▶"}
            </button>
            <div className="w-full">
              <input
                type="range"
                min="0"
                max="100"
                step="1"
                value={reveal}
                aria-label="Factory to selected fitment animation"
                onPointerDown={() => setPlaying(false)}
                onChange={(event) => setReveal(Number(event.target.value))}
                className="h-2 w-full cursor-ew-resize appearance-none rounded-full bg-white/10 accent-red-500"
                style={{
                  background: `linear-gradient(to right, #ef4444 0%, #ef4444 ${reveal}%, rgba(255,255,255,.1) ${reveal}%, rgba(255,255,255,.1) 100%)`,
                }}
              />
              <div className="mt-2 flex justify-between text-[9px] font-black uppercase tracking-[0.16em]">
                <span className="text-white/35">Factory</span>
                <span className="text-red-400">Selected</span>
              </div>
            </div>
          </div>

          <div className="grid border-t border-white/10 sm:grid-cols-3">
            <ComparisonCell label="Factory" value={`${factoryWheelLabel} / ${factoryTireLabel}`} />
            <ComparisonCell label="Selected" value={`${selectedWheelLabel} / ${selectedTireLabel}`} selected />
            <ComparisonCell label="Change" value={`${formatMm(comparison.outerPoke)} outward`} selected />
          </div>

          <p className="border-t border-white/10 bg-red-500/[0.035] px-5 py-4 text-sm font-semibold leading-6 text-white/70">
            {summary}
          </p>
        </div>

        <dl className="grid grid-cols-3 divide-x divide-white/10 xl:grid-cols-1 xl:divide-x-0 xl:divide-y">
          <Metric
            label="Outer"
            value={formatMm(animatedOuter)}
            accent
          />
          <Metric
            label="Inner"
            value={formatMm(animatedInner)}
            accent={comparison.innerClearance < 0}
          />
          <Metric
            label="Track"
            value={formatMm(animatedTrack)}
          />
        </dl>
      </div>
    </section>
  );
}

function ComparisonCell({
  label,
  value,
  selected = false,
}: {
  label: string;
  value: string;
  selected?: boolean;
}) {
  return (
    <div className="border-b border-white/10 px-5 py-4 last:border-b-0 sm:border-b-0 sm:border-r sm:last:border-r-0">
      <p className={`text-[9px] font-black uppercase tracking-[0.16em] ${selected ? "text-red-400" : "text-white/30"}`}>
        {label}
      </p>
      <p className="mt-1 text-xs font-black text-white/75">{value}</p>
    </div>
  );
}

function Metric({
  label,
  value,
  accent = false,
}: {
  label: string;
  value: string;
  accent?: boolean;
}) {
  return (
    <div className="p-5 md:p-6">
      <dt className="text-xs font-semibold text-white/40">{label}</dt>
      <dd
        className={`mt-2 text-3xl font-black tracking-tight ${
          accent ? "text-red-400" : "text-white/80"
        }`}
      >
        {value}
      </dd>
      <p className="mt-1 text-xs text-white/30">vs Factory</p>
    </div>
  );
}
