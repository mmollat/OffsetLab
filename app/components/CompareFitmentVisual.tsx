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
  const arrowId = `compare-arrow-${axle}`;

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
        <div className="relative min-h-[390px] overflow-hidden border-b border-white/10 lg:border-b-0 lg:border-r">
          <svg
            viewBox="0 0 620 430"
            className="absolute inset-0 h-full w-full"
            role="img"
            aria-label={`${axle} wheel fitment cross-section`}
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
              rx="24"
              fill="rgba(255,255,255,0.025)"
              stroke="rgba(255,255,255,0.38)"
              strokeWidth="2"
              strokeDasharray="7 6"
            />
            <text
              x={baseTireX + baselineRenderWidth / 2}
              y="398"
              fill="rgba(255,255,255,0.38)"
              fontSize="10"
              fontWeight="700"
              letterSpacing="1"
              textAnchor="middle"
            >
              FACTORY
            </text>

            <image
              href="/fitment-tire-mockup.png"
              x={selectedX}
              y="55"
              width={selectedRenderWidth}
              height={tireHeight}
              preserveAspectRatio="none"
              style={{
                transition: "all 450ms cubic-bezier(0.22, 1, 0.36, 1)",
              }}
            />

            <line
              x1={baselineOuter}
              y1="78"
              x2={baselineOuter}
              y2="365"
              stroke="rgba(255,255,255,0.35)"
              strokeDasharray="6 6"
              strokeWidth="1.5"
            />
            <line
              x1={selectedOuter}
              y1="78"
              x2={selectedOuter}
              y2="365"
              stroke="#ef4444"
              strokeWidth="2"
            />

            <line
              x1={measureStart}
              y1="105"
              x2={measureEnd}
              y2="105"
              stroke="#ef4444"
              strokeWidth="2"
              markerStart={`url(#${arrowId})`}
              markerEnd={`url(#${arrowId})`}
            />
            <text
              x={(measureStart + measureEnd) / 2}
              y="91"
              fill="#fb6b73"
              fontSize="12"
              fontWeight="800"
              textAnchor="middle"
            >
              {formatMm(comparison.outerPoke)}
            </text>

            <rect x="72" y="382" width="150" height="28" rx="14" fill="rgba(255,255,255,0.03)" stroke="rgba(255,255,255,0.18)" />
            <text x="147" y="400" fill="rgba(255,255,255,0.45)" fontSize="10" fontWeight="800" letterSpacing="0.8" textAnchor="middle">
              FACTORY BASELINE
            </text>
            <rect x="238" y="382" width="160" height="28" rx="14" fill="#190d0f" stroke="#ef4444" strokeOpacity="0.8" />
            <text x="318" y="400" fill="#fb636c" fontSize="10" fontWeight="800" letterSpacing="0.8" textAnchor="middle">
              SELECTED FITMENT
            </text>
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
