"use client";

type Props = {
  oemFront: string;
  selectedFront: string;
  oemRear?: string;
  selectedRear?: string;
  selectedLabel?: string;
};

type WheelSpec = {
  diameter: number;
  width: number;
  offset: number;
};

function parseWheel(spec: string): WheelSpec | null {
  const match = spec.match(/(\d+\.?\d*)x(\d+\.?\d*)\s*(?:ET|\+)?\s*(-?\d+)/i);
  if (!match) return null;

  return {
    diameter: parseFloat(match[1]),
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

  const oemWidthMm = oem.width * 25.4;
  const selectedWidthMm = selected.width * 25.4;

  const innerChange =
    selectedWidthMm / 2 + selected.offset - (oemWidthMm / 2 + oem.offset);

  const outerChange =
    selectedWidthMm / 2 - selected.offset - (oemWidthMm / 2 - oem.offset);

  const scale = 1.45;
  const hubX = 500;
  const topY = 180;
  const bottomY = 320;
  const centerY = 250;

  const oemLeft = hubX - (oemWidthMm / 2 + oem.offset) * scale;
  const oemRight = hubX + (oemWidthMm / 2 - oem.offset) * scale;

  const selectedLeft = hubX - (selectedWidthMm / 2 + selected.offset) * scale;
  const selectedRight = hubX + (selectedWidthMm / 2 - selected.offset) * scale;

  const tirePad = 18;

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-5 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="mt-2 text-2xl font-bold">OEM vs Selected</h2>
        </div>

        {selectedLabel ? (
          <p className="text-sm text-white/50">{selectedLabel}</p>
        ) : null}
      </div>

      <div className="overflow-hidden rounded-3xl border border-white/10 bg-black/50 p-4">
        <svg
          viewBox="0 0 1000 500"
          className="h-[360px] w-full"
          role="img"
          aria-label="Wheel fitment comparison"
        >
          <defs>
            <pattern
              id="oemHatchSimple"
              patternUnits="userSpaceOnUse"
              width="10"
              height="10"
              patternTransform="rotate(45)"
            >
              <line x1="0" y1="0" x2="0" y2="10" stroke="rgba(251,146,60,0.28)" strokeWidth="3" />
            </pattern>

            <pattern
              id="selectedHatchSimple"
              patternUnits="userSpaceOnUse"
              width="10"
              height="10"
              patternTransform="rotate(-45)"
            >
              <line x1="0" y1="0" x2="0" y2="10" stroke="rgba(96,165,250,0.34)" strokeWidth="3" />
            </pattern>

            <filter id="glowSimple">
              <feGaussianBlur stdDeviation="2.5" result="blur" />
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
              <path d="M 0 0 L 10 5 L 0 10 z" fill="rgba(96,165,250,0.9)" />
            </marker>

            <marker
              id="arrowOrange"
              markerWidth="10"
              markerHeight="10"
              refX="8"
              refY="5"
              orient="auto"
            >
              <path d="M 0 0 L 10 5 L 0 10 z" fill="rgba(251,146,60,0.9)" />
            </marker>
          </defs>

          <rect x="95" y="54" width="810" height="392" rx="34" fill="rgba(255,255,255,0.018)" stroke="rgba(255,255,255,0.08)" />

          <text x="155" y="92" fill="rgba(255,255,255,0.48)" fontSize="16" letterSpacing="3">
            INSIDE / SUSPENSION
          </text>

          <text x="845" y="92" textAnchor="end" fill="rgba(255,255,255,0.48)" fontSize="16" letterSpacing="3">
            OUTSIDE / FENDER
          </text>

          <line x1={hubX} y1="92" x2={hubX} y2="414" stroke="rgba(255,255,255,0.28)" strokeWidth="2" strokeDasharray="8 8" />
          <rect x={hubX - 6} y="150" width="12" height="200" rx="6" fill="rgba(255,255,255,0.25)" />

          <rect x={hubX - 72} y="100" width="144" height="38" rx="19" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x={hubX} y="124" textAnchor="middle" fill="rgba(255,255,255,0.45)" fontSize="14" letterSpacing="4">
            HUB FACE
          </text>

          <rect
            x={oemLeft - tirePad}
            y={topY - 20}
            width={oemRight - oemLeft + tirePad * 2}
            height={bottomY - topY + 40}
            rx="46"
            fill="url(#oemHatchSimple)"
            stroke="rgba(251,146,60,0.88)"
            strokeWidth="4"
            filter="url(#glowSimple)"
          />

          <rect
            x={oemLeft}
            y={topY}
            width={oemRight - oemLeft}
            height={bottomY - topY}
            rx="18"
            fill="rgba(251,146,60,0.08)"
            stroke="rgba(251,146,60,0.78)"
            strokeWidth="3"
          />

          <rect
            x={selectedLeft - tirePad}
            y={topY - 34}
            width={selectedRight - selectedLeft + tirePad * 2}
            height={bottomY - topY + 68}
            rx="54"
            fill="url(#selectedHatchSimple)"
            stroke="rgba(96,165,250,0.96)"
            strokeWidth="4"
            filter="url(#glowSimple)"
          />

          <rect
            x={selectedLeft}
            y={topY - 8}
            width={selectedRight - selectedLeft}
            height={bottomY - topY + 16}
            rx="20"
            fill="rgba(96,165,250,0.08)"
            stroke="rgba(96,165,250,0.9)"
            strokeWidth="3"
          />

          <circle cx={hubX} cy={centerY} r="54" fill="rgba(0,0,0,0.66)" stroke="rgba(255,255,255,0.42)" strokeWidth="3" />
          <circle cx={hubX} cy={centerY} r="32" fill="rgba(0,0,0,0.82)" stroke="rgba(255,255,255,0.72)" strokeWidth="3" />

          <line
            x1={oemLeft}
            y1="382"
            x2={selectedLeft}
            y2="382"
            stroke="rgba(251,146,60,0.9)"
            strokeWidth="3"
            markerEnd="url(#arrowOrange)"
          />

          <line
            x1={oemRight}
            y1="382"
            x2={selectedRight}
            y2="382"
            stroke="rgba(96,165,250,0.95)"
            strokeWidth="3"
            markerEnd="url(#arrowBlue)"
          />

          <g>
            <rect x="130" y="318" width="210" height="78" rx="18" fill="rgba(251,146,60,0.12)" stroke="rgba(251,146,60,0.38)" />
            <text x="154" y="348" fill="rgba(253,186,116,0.95)" fontSize="13" letterSpacing="3">
              INNER CHANGE
            </text>
            <text x="154" y="380" fill="rgb(254,215,170)" fontSize="30" fontWeight="800">
              {formatMm(innerChange)}
            </text>
          </g>

          <g>
            <rect x="660" y="318" width="210" height="78" rx="18" fill="rgba(59,130,246,0.14)" stroke="rgba(96,165,250,0.42)" />
            <text x="684" y="348" fill="rgba(147,197,253,0.95)" fontSize="13" letterSpacing="3">
              OUTER POKE
            </text>
            <text x="684" y="380" fill="rgb(191,219,254)" fontSize="30" fontWeight="800">
              {formatMm(outerChange)}
            </text>
          </g>

          <rect x="330" y="424" width="340" height="38" rx="19" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x="500" y="448" textAnchor="middle" fill="rgba(255,255,255,0.5)" fontSize="14" letterSpacing="4">
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
