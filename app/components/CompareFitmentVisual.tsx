"use client";

import type { CSSProperties } from "react";

type Props = {
  baselineFront?: string;
  baselineRear?: string;
  selectedFront: string;
  selectedRear?: string;
  pokeFront?: string;
  pokeRear?: string;
  baselineTire?: string;
  selectedTire?: string;
  oemFront?: string;
  oemRear?: string;
  selectedLabel?: string;
};

type WheelSpec = {
  width: number;
  offset: number;
};

type TireSpec = {
  width: number;
};

function parseWheel(spec?: string): WheelSpec | null {
  if (!spec) return null;

  const match = spec.match(/(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+|et)?\s*(-?\d+)/i);
  if (!match) return null;

  return {
    width: parseFloat(match[2]),
    offset: parseFloat(match[3]),
  };
}

function parseTire(spec?: string): TireSpec | null {
  if (!spec) return null;

  const match = spec.match(/(\d{3})\/\d{2}R\d{2}/i);
  if (!match) return null;

  return {
    width: parseFloat(match[1]),
  };
}

function formatMm(value: number) {
  return `${value > 0 ? "+" : ""}${Math.round(value)}mm`;
}

export default function CompareFitmentVisual({
  baselineFront,
  selectedFront,
  baselineTire,
  selectedTire,
  oemFront,
}: Props) {
  const baseFront = baselineFront ?? oemFront ?? "";

  const parsedOem = parseWheel(baseFront);
  const parsedSelected = parseWheel(selectedFront);

  const oem = parsedOem ?? { width: 9, offset: 34 };
  const selected = parsedSelected ?? oem;

  const oemTire = parseTire(baselineTire) || { width: 235 };
  const selectedTireParsed = parseTire(selectedTire) || { width: 265 };

  const oemWidth = oem.width * 25.4;
  const selectedWidth = selected.width * 25.4;

  const innerChange =
    selectedWidth / 2 + selected.offset - (oemWidth / 2 + oem.offset);

  const outerChange =
    selectedWidth / 2 - selected.offset - (oemWidth / 2 - oem.offset);

  const scale = 0.6;
  const hubFaceX = 455;

  const oemOuter =
    hubFaceX - (oemWidth / 2 - oem.offset) * scale;

  const oemInner =
    hubFaceX + (oemWidth / 2 + oem.offset) * scale;

  const selectedOuter =
    hubFaceX - (selectedWidth / 2 - selected.offset) * scale;

  const selectedInner =
    hubFaceX + (selectedWidth / 2 + selected.offset) * scale;

  const oemWidthPx = oemInner - oemOuter;
  const selectedWidthPx = selectedInner - selectedOuter;

  // 🔥 improved tire scaling (more noticeable difference)
  const tireBase = 26;
  const oemTireThickness = tireBase + (oemTire.width - 235) * 0.08;
  const selectedTireThickness = tireBase + (selectedTireParsed.width - 235) * 0.08;

  const transitionStyle: CSSProperties = {
    transition: "all 500ms cubic-bezier(0.22, 1, 0.36, 1)",
  };

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-4">
        <p className="text-sm uppercase tracking-[0.25em] text-white/40">
          Fitment Cross-Section
        </p>
        <h2 className="text-xl font-bold">OEM vs Selected</h2>
      </div>

      <div className="overflow-hidden rounded-3xl border border-white/10 bg-white p-3">
        <div
          className="relative mx-auto aspect-[16/9] w-full max-w-5xl overflow-hidden rounded-2xl bg-white bg-contain bg-center bg-no-repeat"
          style={{
            backgroundImage: "url('/compare/cross_section_suspension.png')",
          }}
        >
          <svg
            viewBox="0 0 1000 562"
            className="absolute inset-0 h-full w-full"
          >
            {/* HUB LINE */}
            <line
              x1={hubFaceX}
              y1="90"
              x2={hubFaceX}
              y2="480"
              stroke="rgba(0,0,0,0.35)"
              strokeDasharray="6 6"
            />

            {/* OEM TIRE */}
            <rect
              x={oemOuter - oemTireThickness / 2}
              y={140}
              width={oemWidthPx + oemTireThickness}
              height="350"
              rx="50"
              fill="rgba(239,68,68,0.05)"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="6 6"
            />

            {/* OEM WHEEL */}
            <rect
              x={oemOuter}
              y={175}
              width={oemWidthPx}
              height="280"
              rx="22"
              fill="none"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="6 6"
            />

            {/* SELECTED TIRE */}
            <rect
              x={selectedOuter - selectedTireThickness / 2}
              y={130}
              width={selectedWidthPx + selectedTireThickness}
              height="380"
              rx="60"
              fill="rgba(59,130,246,0.1)"
              stroke="#3b82f6"
              strokeWidth="4"
              style={transitionStyle}
            />

            {/* SELECTED WHEEL */}
            <rect
              x={selectedOuter}
              y={170}
              width={selectedWidthPx}
              height="300"
              rx="25"
              fill="rgba(59,130,246,0.03)"
              stroke="#3b82f6"
              strokeWidth="3"
              style={transitionStyle}
            />

            {/* OUTER LINE */}
            <line
              x1={oemOuter}
              y1="520"
              x2={selectedOuter}
              y2="520"
              stroke="#3b82f6"
              strokeWidth="3"
            />

            {/* INNER LINE */}
            <line
              x1={oemInner}
              y1="540"
              x2={selectedInner}
              y2="540"
              stroke="#ef4444"
              strokeWidth="3"
            />

            {/* LABELS */}
            <text x="80" y="160" fill="#ef4444" fontSize="14">
              INNER CHANGE
            </text>

            <text x="80" y="195" fill="#111" fontSize="32" fontWeight="bold">
              {formatMm(innerChange)}
            </text>

            <text x="80" y="260" fill="#3b82f6" fontSize="14">
              OUTER POKE
            </text>

            <text x="80" y="295" fill="#111" fontSize="32" fontWeight="bold">
              {formatMm(outerChange)}
            </text>
          </svg>
        </div>
      </div>
    </section>
  );
}
