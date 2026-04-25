"use client";

import type { CSSProperties } from "react";

type Props = {
  oemFront: string;
  selectedFront: string;
  oemRear?: string;
  selectedRear?: string;
  selectedLabel?: string;
};

type WheelSpec = {
  width: number;
  offset: number;
};

type TireSpec = {
  width: number;
};

function parseWheel(spec: string): WheelSpec | null {
  const match = spec.match(/(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+)?\s*(-?\d+)/i);
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
  oemFront,
  selectedFront,
  selectedLabel,
}: Props) {
  const oem = parseWheel(oemFront);
  const selected = parseWheel(selectedFront);

  // 👇 NEW: simulate tire widths (fallback if not provided)
  const oemTire = parseTire(oemFront) || { width: 235 };
  const selectedTire = parseTire(selectedFront) || { width: 265 };

  if (!oem || !selected) {
    return (
      <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6 text-white/50">
        Unable to compare wheel specs.
      </section>
    );
  }

  const oemWidth = oem.width * 25.4;
  const selectedWidth = selected.width * 25.4;

  const innerChange =
    selectedWidth / 2 + selected.offset - (oemWidth / 2 + oem.offset);

  const outerChange =
    selectedWidth / 2 - selected.offset - (oemWidth / 2 - oem.offset);

  const scale = 0.9;
  const centerX = 500;

  const oemLeft = centerX - (oemWidth / 2 + oem.offset) * scale;
  const oemRight = centerX + (oemWidth / 2 - oem.offset) * scale;

  const selectedLeft = centerX - (selectedWidth / 2 + selected.offset) * scale;
  const selectedRight = centerX + (selectedWidth / 2 - selected.offset) * scale;

  const selectedWidthPx = selectedRight - selectedLeft;
  const oemWidthPx = oemRight - oemLeft;

  // 🔥 NEW: tire thickness scaling
  const baseTireThickness = 36;
  const oemTireThickness =
    baseTireThickness + (oemTire.width - 235) * 0.08;
  const selectedTireThickness =
    baseTireThickness + (selectedTire.width - 235) * 0.08;

  const transitionStyle: CSSProperties = {
    transition: "all 600ms cubic-bezier(0.22, 1, 0.36, 1)",
  };

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-4 flex items-end justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="text-xl font-bold">OEM vs Selected</h2>
        </div>

        {selectedLabel ? (
          <span className="text-sm text-white/50">{selectedLabel}</span>
        ) : null}
      </div>

      <div className="rounded-3xl border border-white/10 bg-black/60 p-6">
        <svg viewBox="0 0 1000 520" className="h-[360px] w-full">
          <defs>
            <filter id="blueGlow">
              <feGaussianBlur stdDeviation="4" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
          </defs>

          {/* CENTER HUB */}
          <rect x={centerX - 28} y="180" width="56" height="160" rx="6" fill="#666" />
          <rect x={centerX - 60} y="220" width="120" height="80" rx="8" fill="#888" />

          {/* CENTER LINE */}
          <line
            x1={centerX}
            y1="60"
            x2={centerX}
            y2="460"
            stroke="rgba(255,255,255,0.22)"
            strokeDasharray="6 6"
          />

          {/* OEM tire */}
          <rect
            x={oemLeft - oemTireThickness / 2}
            y="100"
            width={oemWidthPx + oemTireThickness}
            height="320"
            rx="40"
            fill="rgba(249,115,22,0.05)"
            stroke="#f97316"
            strokeDasharray="6 6"
          />

          {/* Selected tire (scaled) */}
          <rect
            x={selectedLeft - selectedTireThickness / 2}
            y="80"
            width={selectedWidthPx + selectedTireThickness}
            height="360"
            rx="50"
            fill="rgba(59,130,246,0.12)"
            stroke="#3b82f6"
            strokeWidth="3"
            filter="url(#blueGlow)"
            style={transitionStyle}
          />

          {/* Wheel barrel */}
          <rect
            x={selectedLeft}
            y="110"
            width={selectedWidthPx}
            height="300"
            rx="20"
            fill="rgba(59,130,246,0.04)"
            stroke="#3b82f6"
            style={transitionStyle}
          />

          {/* Movement lines */}
          <line
            x1={oemLeft}
            y1="450"
            x2={selectedLeft}
            y2="450"
            stroke="#f97316"
            strokeWidth="3"
            style={transitionStyle}
          />

          <line
            x1={oemRight}
            y1="450"
            x2={selectedRight}
            y2="450"
            stroke="#3b82f6"
            strokeWidth="3"
            style={transitionStyle}
          />

          {/* TEXT */}
          <text x="120" y="220" fill="#f97316" fontSize="13">
            INNER
          </text>
          <text x="120" y="250" fill="#fff" fontSize="28" fontWeight="bold">
            {formatMm(innerChange)}
          </text>

          <text x="760" y="220" fill="#3b82f6" fontSize="13">
            OUTER
          </text>
          <text x="760" y="250" fill="#fff" fontSize="28" fontWeight="bold">
            {formatMm(outerChange)}
          </text>

          <text
            x="500"
            y="490"
            textAnchor="middle"
            fill="rgba(255,255,255,0.45)"
            fontSize="12"
          >
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
