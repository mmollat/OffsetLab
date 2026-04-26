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

  const scale = 0.78;
  const hubFaceX = 515;

  const oemOuter = hubFaceX - (oemWidth / 2 - oem.offset) * scale;
  const oemInner = hubFaceX + (oemWidth / 2 + oem.offset) * scale;

  const selectedOuter =
    hubFaceX - (selectedWidth / 2 - selected.offset) * scale;
  const selectedInner =
    hubFaceX + (selectedWidth / 2 + selected.offset) * scale;

  const oemWidthPx = oemInner - oemOuter;
  const selectedWidthPx = selectedInner - selectedOuter;

  const baseTireThickness = 34;
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

      <div className="overflow-hidden rounded-3xl border border-white/10 bg-white p-3">
        <div className="relative mx-auto aspect-[16/9] w-full max-w-5xl overflow-hidden rounded-2xl bg-white">
          <img
            src="/compare/cross_section_suspension.png"
            alt=""
            className="absolute inset-0 h-full w-full object-contain"
          />

          <svg
            viewBox="0 0 1000 562"
            className="absolute inset-0 h-full w-full"
          >
            <defs>
              <filter id="blueGlow" x="-20%" y="-20%" width="140%" height="140%">
                <feGaussianBlur stdDeviation="3" result="blur" />
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
                id="arrowRed"
                markerWidth="10"
                markerHeight="10"
                refX="8"
                refY="5"
                orient="auto"
              >
                <path d="M 0 0 L 10 5 L 0 10 z" fill="#ef4444" />
              </marker>
            </defs>

            {/* labels */}
            <text
              x="120"
              y="72"
              fill="rgba(0,0,0,0.42)"
              fontSize="13"
              letterSpacing="3"
            >
              OUTER / FENDER
            </text>

            <text
              x="850"
              y="72"
              textAnchor="end"
              fill="rgba(0,0,0,0.42)"
              fontSize="13"
              letterSpacing="3"
            >
              INNER / SUSPENSION
            </text>

            {/* hub face reference */}
            <line
              x1={hubFaceX}
              y1="96"
              x2={hubFaceX}
              y2="462"
              stroke="rgba(0,0,0,0.28)"
              strokeDasharray="7 7"
            />

            <text
              x={hubFaceX}
              y="92"
              textAnchor="middle"
              fill="rgba(0,0,0,0.46)"
              fontSize="12"
              letterSpacing="3"
            >
              HUB FACE
            </text>

            {/* OEM reference */}
            <rect
              x={oemOuter - oemTireThickness / 2}
              y="142"
              width={oemWidthPx + oemTireThickness}
              height="275"
              rx="34"
              fill="rgba(239,68,68,0.05)"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="7 6"
            />

            <rect
              x={oemOuter}
              y="166"
              width={oemWidthPx}
              height="227"
              rx="18"
              fill="none"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="7 6"
            />

            {/* selected overlay */}
            <rect
              x={selectedOuter - selectedTireThickness / 2}
              y="122"
              width={selectedWidthPx + selectedTireThickness}
              height="315"
              rx="42"
              fill="rgba(59,130,246,0.09)"
              stroke="#3b82f6"
              strokeWidth="4"
              filter="url(#blueGlow)"
              style={transitionStyle}
            />

            <rect
              x={selectedOuter}
              y="154"
              width={selectedWidthPx}
              height="251"
              rx="22"
              fill="rgba(59,130,246,0.03)"
              stroke="#3b82f6"
              strokeWidth="3"
              style={transitionStyle}
            />

            {/* tire/wheel depth detail */}
            <path
              d={`M ${selectedOuter + 28} 168 L ${selectedOuter + 58} 215 L ${selectedOuter + 58} 345 L ${selectedOuter + 28} 392`}
              fill="none"
              stroke="#3b82f6"
              strokeWidth="2"
              opacity="0.7"
              style={transitionStyle}
            />

            <path
              d={`M ${selectedInner - 28} 168 L ${selectedInner - 58} 215 L ${selectedInner - 58} 345 L ${selectedInner - 28} 392`}
              fill="none"
              stroke="#3b82f6"
              strokeWidth="2"
              opacity="0.7"
              style={transitionStyle}
            />

            {/* tick markers */}
            <line
              x1={oemOuter}
              y1="430"
              x2={oemOuter}
              y2="465"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="5 5"
            />
            <line
              x1={selectedOuter}
              y1="430"
              x2={selectedOuter}
              y2="465"
              stroke="#3b82f6"
              strokeWidth="3"
              style={transitionStyle}
            />

            <line
              x1={oemInner}
              y1="430"
              x2={oemInner}
              y2="465"
              stroke="#ef4444"
              strokeWidth="2"
              strokeDasharray="5 5"
            />
            <line
              x1={selectedInner}
              y1="430"
              x2={selectedInner}
              y2="465"
              stroke="#3b82f6"
              strokeWidth="3"
              style={transitionStyle}
            />

            {/* movement arrows */}
            <line
              x1={oemOuter}
              y1="456"
              x2={selectedOuter}
              y2="456"
              stroke="#3b82f6"
              strokeWidth="3"
              markerEnd="url(#arrowBlue)"
              style={transitionStyle}
            />

            <line
              x1={oemInner}
              y1="482"
              x2={selectedInner}
              y2="482"
              stroke="#ef4444"
              strokeWidth="3"
              markerEnd="url(#arrowRed)"
              style={transitionStyle}
            />

            {/* cards */}
            <g>
              <rect
                x="70"
                y="118"
                width="218"
                height="92"
                rx="18"
                fill="rgba(255,255,255,0.82)"
                stroke="rgba(239,68,68,0.4)"
              />
              <text
                x="96"
                y="153"
                fill="#ef4444"
                fontSize="13"
                letterSpacing="2"
              >
                INNER CHANGE
              </text>
              <text x="96" y="190" fill="#111827" fontSize="32" fontWeight="bold">
                {formatMm(innerChange)}
              </text>
            </g>

            <g>
              <rect
                x="70"
                y="228"
                width="218"
                height="92"
                rx="18"
                fill="rgba(255,255,255,0.82)"
                stroke="rgba(59,130,246,0.4)"
              />
              <text
                x="96"
                y="263"
                fill="#3b82f6"
                fontSize="13"
                letterSpacing="2"
              >
                OUTER POKE
              </text>
              <text x="96" y="300" fill="#111827" fontSize="32" fontWeight="bold">
                {formatMm(outerChange)}
              </text>
            </g>

            <text
              x="500"
              y="532"
              textAnchor="middle"
              fill="rgba(0,0,0,0.42)"
              fontSize="12"
              letterSpacing="3"
            >
              OEM = RED DASH · SELECTED = BLUE
            </text>
          </svg>
        </div>
      </div>
    </section>
  );
}
