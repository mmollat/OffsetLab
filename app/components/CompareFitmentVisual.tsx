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

  const oemWidthPx = oemRight - oemLeft;
  const selectedWidthPx = selectedRight - selectedLeft;

  const baseTireThickness = 36;
  const oemTireThickness = baseTireThickness + (oemTire.width - 235) * 0.08;
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
            <filter id="blueGlow" x="-20%" y="-20%" width="140%" height="140%">
              <feGaussianBlur stdDeviation="4" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>

            <marker id="arrowBlue" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#3b82f6" />
            </marker>

            <marker id="arrowOrange" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#f97316" />
            </marker>
          </defs>

          <text x="116" y="70" fill="rgba(255,255,255,0.45)" fontSize="13" letterSpacing="3">
            INNER / SUSPENSION
          </text>
          <text x="884" y="70" textAnchor="end" fill="rgba(255,255,255,0.45)" fontSize="13" letterSpacing="3">
            OUTER / FENDER
          </text>

          <line x1={centerX} y1="58" x2={centerX} y2="462" stroke="rgba(255,255,255,0.22)" strokeDasharray="6 6" />
          <text x={centerX} y="52" textAnchor="middle" fill="rgba(255,255,255,0.42)" fontSize="12" letterSpacing="3">
            HUB FACE
          </text>

          <rect x={centerX - 28} y="178" width="56" height="164" rx="6" fill="#666" />
          <rect x={centerX - 62} y="218" width="124" height="84" rx="8" fill="#888" />

          {/* OEM tire + wheel reference */}
          <rect
            x={oemLeft - oemTireThickness / 2}
            y="100"
            width={oemWidthPx + oemTireThickness}
            height="320"
            rx="42"
            fill="rgba(249,115,22,0.04)"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="7 6"
          />
          <rect
            x={oemLeft}
            y="126"
            width={oemWidthPx}
            height="268"
            rx="18"
            fill="none"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="7 6"
          />

          {/* Selected tire + wheel */}
          <rect
            x={selectedLeft - selectedTireThickness / 2}
            y="80"
            width={selectedWidthPx + selectedTireThickness}
            height="360"
            rx="52"
            fill="rgba(59,130,246,0.11)"
            stroke="#3b82f6"
            strokeWidth="4"
            filter="url(#blueGlow)"
            style={transitionStyle}
          />
          <rect
            x={selectedLeft}
            y="112"
            width={selectedWidthPx}
            height="296"
            rx="22"
            fill="rgba(59,130,246,0.045)"
            stroke="#3b82f6"
            strokeWidth="3"
            style={transitionStyle}
          />

          {/* Edge tick markers */}
          <line x1={oemLeft} y1="430" x2={oemLeft} y2="462" stroke="#f97316" strokeWidth="2" strokeDasharray="5 5" />
          <line x1={selectedLeft} y1="430" x2={selectedLeft} y2="462" stroke="#3b82f6" strokeWidth="3" style={transitionStyle} />

          <line x1={oemRight} y1="430" x2={oemRight} y2="462" stroke="#f97316" strokeWidth="2" strokeDasharray="5 5" />
          <line x1={selectedRight} y1="430" x2={selectedRight} y2="462" stroke="#3b82f6" strokeWidth="3" style={transitionStyle} />

          {/* Barrel depth lines */}
          <path
            d={`M ${selectedLeft + 30} 142 L ${selectedLeft + 60} 192 L ${selectedLeft + 60} 328 L ${selectedLeft + 30} 378`}
            fill="none"
            stroke="#3b82f6"
            strokeWidth="2"
            opacity="0.85"
            style={transitionStyle}
          />
          <path
            d={`M ${selectedRight - 30} 142 L ${selectedRight - 60} 192 L ${selectedRight - 60} 328 L ${selectedRight - 30} 378`}
            fill="none"
            stroke="#3b82f6"
            strokeWidth="2"
            opacity="0.85"
            style={transitionStyle}
          />

          {/* Measurement arrows */}
          <line
            x1={oemLeft}
            y1="456"
            x2={selectedLeft}
            y2="456"
            stroke="#f97316"
            strokeWidth="3"
            markerEnd="url(#arrowOrange)"
            style={transitionStyle}
          />
          <line
            x1={oemRight}
            y1="456"
            x2={selectedRight}
            y2="456"
            stroke="#3b82f6"
            strokeWidth="3"
            markerEnd="url(#arrowBlue)"
            style={transitionStyle}
          />

          {/* Value cards */}
          <g>
            <rect x="96" y="170" width="210" height="92" rx="18" fill="rgba(249,115,22,0.10)" stroke="rgba(249,115,22,0.38)" />
            <text x="122" y="205" fill="#f97316" fontSize="13" letterSpacing="2">
              INNER CHANGE
            </text>
            <text x="122" y="242" fill="#fff" fontSize="32" fontWeight="bold">
              {formatMm(innerChange)}
            </text>
          </g>

          <g>
            <rect x="694" y="170" width="210" height="92" rx="18" fill="rgba(59,130,246,0.12)" stroke="rgba(59,130,246,0.4)" />
            <text x="720" y="205" fill="#3b82f6" fontSize="13" letterSpacing="2">
              OUTER POKE
            </text>
            <text x="720" y="242" fill="#fff" fontSize="32" fontWeight="bold">
              {formatMm(outerChange)}
            </text>
          </g>

          <text x="500" y="495" textAnchor="middle" fill="rgba(255,255,255,0.45)" fontSize="12" letterSpacing="3">
            OEM = ORANGE DASH · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
