"use client";

import { useMemo, useState } from "react";

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

  const hubX = 360;
  const scale = 0.72;
  const baselineWidth = comparison.baselineWheel.width * 25.4;
  const selectedWidth = comparison.selectedWheel.width * 25.4;
  const baselineOuter =
    hubX -
    (baselineWidth / 2 - comparison.baselineWheel.offset) * scale;
  const baselineInner =
    hubX +
    (baselineWidth / 2 + comparison.baselineWheel.offset) * scale;
  const selectedOuter =
    hubX -
    (selectedWidth / 2 - comparison.selectedWheel.offset) * scale;
  const selectedInner =
    hubX +
    (selectedWidth / 2 + comparison.selectedWheel.offset) * scale;

  return (
    <section className="overflow-hidden rounded-[1.5rem] border border-white/10 bg-[#090a0d]">
      <div className="flex flex-col gap-4 border-b border-white/10 px-5 py-5 sm:flex-row sm:items-start sm:justify-between md:px-6">
        <div>
          <h2 className="text-xl font-black tracking-tight">
            Fitment Cross-Section
          </h2>
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
            <i className="h-0.5 w-8 bg-red-500" />
            Selected Fitment
          </span>
          <span className="flex items-center gap-2">
            <i className="h-0.5 w-8 bg-white/30" />
            Factory Baseline
          </span>
        </div>
      </div>

      <div className="grid lg:grid-cols-[1fr_190px]">
        <div className="relative min-h-[300px] overflow-hidden border-b border-white/10 lg:border-b-0 lg:border-r">
          <svg
            viewBox="0 0 700 440"
            className="absolute inset-0 h-full w-full"
            role="img"
            aria-label={`${axle} wheel fitment cross-section`}
          >
            <defs>
              <linearGradient id="selectedFill" x1="0" x2="1">
                <stop offset="0" stopColor="#ef4444" stopOpacity="0.03" />
                <stop offset="1" stopColor="#ef4444" stopOpacity="0.13" />
              </linearGradient>
              <linearGradient id="factoryFill" x1="0" x2="1">
                <stop offset="0" stopColor="#ffffff" stopOpacity="0.01" />
                <stop offset="1" stopColor="#ffffff" stopOpacity="0.045" />
              </linearGradient>
              <filter id="redGlow">
                <feGaussianBlur stdDeviation="4" result="blur" />
                <feMerge>
                  <feMergeNode in="blur" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>

            <g opacity="0.24" stroke="#9ca3af" fill="none">
              <path
                d="M155 79 C132 94 127 122 139 145 L151 171 L145 219 L128 261 L142 340"
                strokeWidth="3"
              />
              <path d="M129 340 H357" strokeWidth="3" />
              <path d="M170 102 H216 L245 158 L267 202" strokeWidth="2" />
              <path d="M170 102 C185 73 214 66 238 83" strokeWidth="2" />
              <path d="M178 119 H232 M173 130 H238 M170 141 H244 M169 152 H249" />
              <circle cx="330" cy="220" r="44" strokeWidth="3" />
              <circle cx="330" cy="220" r="17" strokeWidth="2" />
              <path d="M267 202 L315 206 M267 236 L315 232" strokeWidth="4" />
              <path d="M315 220 H580" strokeWidth="2" opacity="0.35" />
            </g>

            <line
              x1={hubX}
              y1="52"
              x2={hubX}
              y2="386"
              stroke="rgba(255,255,255,0.62)"
              strokeDasharray="7 7"
              strokeWidth="2"
            />
            <text
              x={hubX - 12}
              y="38"
              fill="rgba(255,255,255,0.35)"
              fontSize="11"
              textAnchor="end"
            >
              HUB FACE
            </text>

            <path
              d={`M${baselineOuter} 92
                  Q${baselineOuter - 18} 92 ${baselineOuter - 22} 122
                  L${baselineOuter - 22} 318
                  Q${baselineOuter - 18} 348 ${baselineOuter} 348
                  L${baselineOuter + 18} 329
                  L${baselineOuter + 32} 329
                  L${baselineOuter + 48} 344
                  L${baselineInner - 24} 344
                  Q${baselineInner} 344 ${baselineInner} 318
                  L${baselineInner} 122
                  Q${baselineInner} 96 ${baselineInner - 24} 96
                  L${baselineOuter + 48} 96
                  L${baselineOuter + 32} 111
                  L${baselineOuter + 18} 111 Z`}
              fill="url(#factoryFill)"
              stroke="rgba(255,255,255,0.25)"
              strokeWidth="3"
            />

            <path
              d={`M${selectedOuter} 82
                  Q${selectedOuter - 20} 82 ${selectedOuter - 24} 114
                  L${selectedOuter - 24} 326
                  Q${selectedOuter - 20} 358 ${selectedOuter} 358
                  L${selectedOuter + 20} 337
                  L${selectedOuter + 36} 337
                  L${selectedOuter + 54} 353
                  L${selectedInner - 26} 353
                  Q${selectedInner} 353 ${selectedInner} 326
                  L${selectedInner} 114
                  Q${selectedInner} 86 ${selectedInner - 26} 86
                  L${selectedOuter + 54} 86
                  L${selectedOuter + 36} 103
                  L${selectedOuter + 20} 103 Z`}
              fill="url(#selectedFill)"
              stroke="#ef4444"
              strokeOpacity="0.8"
              strokeWidth="3"
              filter="url(#redGlow)"
              style={{
                transition: "all 450ms cubic-bezier(0.22, 1, 0.36, 1)",
              }}
            />

            <line
              x1={baselineOuter}
              x2={selectedOuter}
              y1="382"
              y2="382"
              stroke="#ef4444"
              strokeWidth="2"
            />
            <circle cx={baselineOuter} cy="382" r="3" fill="rgba(255,255,255,0.45)" />
            <circle cx={selectedOuter} cy="382" r="3" fill="#ef4444" />
          </svg>
        </div>

        <dl className="grid grid-cols-2 divide-x divide-y divide-white/10 lg:grid-cols-1 lg:divide-x-0">
          <Metric
            label="Outer Poke"
            value={formatMm(comparison.outerPoke)}
            accent
          />
          <Metric
            label="Inner Clearance"
            value={formatMm(comparison.innerClearance)}
            accent={comparison.innerClearance < 0}
          />
          <Metric
            label="Track Width"
            value={formatMm(comparison.trackChange)}
          />
        </dl>
      </div>
    </section>
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
