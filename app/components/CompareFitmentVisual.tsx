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

function parseWheel(spec: string): WheelSpec | null {
  const match = spec.match(/(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+)?\s*(-?\d+)/i);
  if (!match) return null;

  return {
    width: parseFloat(match[2]),
    offset: parseFloat(match[3]),
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
            <filter id="blueGlow" x="-20%" y="-20%" width="140%" height="140%">
              <feGaussianBlur stdDeviation="4" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>

            <marker
              id="arrowBlue"
              markerWidth="10"
              markerHeight="10"
              refX="8"
              refY="5"
              orient="auto"
            >
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#3b82f6" />
            </marker>

            <marker
              id="arrowOrange"
              markerWidth="10"
              markerHeight="10"
              refX="8"
              refY="5"
              orient="auto"
            >
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#f97316" />
            </marker>
          </defs>

          <text x="120" y="70" fill="rgba(255,255,255,0.42)" fontSize="13" letterSpacing="3">
            INSIDE
          </text>

          <text x="880" y="70" textAnchor="end" fill="rgba(255,255,255,0.42)" fontSize="13" letterSpacing="3">
            OUTSIDE
          </text>

          <line
            x1={centerX}
            y1="60"
            x2={centerX}
            y2="460"
            stroke="rgba(255,255,255,0.22)"
            strokeDasharray="6 6"
          />

          <rect x={centerX - 28} y="180" width="56" height="160" rx="6" fill="#666" />
          <rect x={centerX - 60} y="220" width="120" height="80" rx="8" fill="#888" />

          <rect
            x={oemLeft - 16}
            y="90"
            width={oemWidthPx + 32}
            height="340"
            rx="40"
            fill="rgba(249,115,22,0.035)"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="6 6"
          />

          <rect
            x={oemLeft}
            y="120"
            width={oemWidthPx}
            height="280"
            rx="18"
            fill="none"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="6 6"
          />

          <rect
            x={selectedLeft - 22}
            y="80"
            width={selectedWidthPx + 44}
            height="360"
            rx="50"
            fill="rgba(59,130,246,0.10)"
            stroke="#3b82f6"
            strokeWidth="4"
            filter="url(#blueGlow)"
            style={transitionStyle}
          />

          <rect
            x={selectedLeft}
            y="110"
            width={selectedWidthPx}
            height="300"
            rx="22"
            fill="rgba(59,130,246,0.045)"
            stroke="#3b82f6"
            strokeWidth="3"
            style={transitionStyle}
          />

          <line
            x1={selectedLeft + 30}
            y1="140"
            x2={selectedLeft + 60}
            y2="190"
            stroke="#3b82f6"
            strokeWidth="2"
            style={transitionStyle}
          />
          <line
            x1={selectedLeft + 60}
            y1="190"
            x2={selectedLeft + 60}
            y2="330"
            stroke="#3b82f6"
            strokeWidth="2"
            opacity="0.7"
            style={transitionStyle}
          />
          <line
            x1={selectedLeft + 60}
            y1="330"
            x2={selectedLeft + 30}
            y2="380"
            stroke="#3b82f6"
            strokeWidth="2"
            style={transitionStyle}
          />

          <line
            x1={selectedRight - 30}
            y1="140"
            x2={selectedRight - 60}
            y2="190"
            stroke="#3b82f6"
            strokeWidth="2"
            style={transitionStyle}
          />
          <line
            x1={selectedRight - 60}
            y1="190"
            x2={selectedRight - 60}
            y2="330"
            stroke="#3b82f6"
            strokeWidth="2"
            opacity="0.7"
            style={transitionStyle}
          />
          <line
            x1={selectedRight - 60}
            y1="330"
            x2={selectedRight - 30}
            y2="380"
            stroke="#3b82f6"
            strokeWidth="2"
            style={transitionStyle}
          />

          <line
            x1={oemLeft}
            y1="450"
            x2={selectedLeft}
            y2="450"
            stroke="#f97316"
            strokeWidth="3"
            markerEnd="url(#arrowOrange)"
            style={transitionStyle}
          />

          <line
            x1={oemRight}
            y1="450"
            x2={selectedRight}
            y2="450"
            stroke="#3b82f6"
            strokeWidth="3"
            markerEnd="url(#arrowBlue)"
            style={transitionStyle}
          />

          <g style={transitionStyle}>
            <rect
              x="104"
              y="178"
              width="190"
              height="82"
              rx="18"
              fill="rgba(249,115,22,0.10)"
              stroke="rgba(249,115,22,0.35)"
            />
            <text x="126" y="210" fill="#f97316" fontSize="13" letterSpacing="2">
              INNER
            </text>
            <text x="126" y="242" fill="#fff" fontSize="30" fontWeight="bold">
              {formatMm(innerChange)}
            </text>
          </g>

          <g style={transitionStyle}>
            <rect
              x="706"
              y="178"
              width="190"
              height="82"
              rx="18"
              fill="rgba(59,130,246,0.12)"
              stroke="rgba(59,130,246,0.38)"
            />
            <text x="728" y="210" fill="#3b82f6" fontSize="13" letterSpacing="2">
              OUTER
            </text>
            <text x="728" y="242" fill="#fff" fontSize="30" fontWeight="bold">
              {formatMm(outerChange)}
            </text>
          </g>

          <text
            x="500"
            y="492"
            textAnchor="middle"
            fill="rgba(255,255,255,0.45)"
            fontSize="12"
            letterSpacing="3"
          >
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
