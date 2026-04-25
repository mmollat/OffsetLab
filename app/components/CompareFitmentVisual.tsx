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

function wheelPath(leftX: number, rightX: number, topY: number, bottomY: number) {
  const lip = 10;
  const barrelStep = 22;
  const centerY = (topY + bottomY) / 2;

  return `
    M ${leftX} ${topY + 22}
    L ${leftX + lip} ${topY + 22}
    L ${leftX + lip} ${topY}
    L ${leftX + barrelStep} ${topY}
    L ${leftX + barrelStep} ${topY + 36}
    L ${leftX + barrelStep + 26} ${topY + 52}
    L ${leftX + barrelStep + 38} ${centerY - 18}
    L ${leftX + barrelStep + 38} ${centerY + 18}
    L ${leftX + barrelStep + 26} ${bottomY - 52}
    L ${leftX + barrelStep} ${bottomY - 36}
    L ${leftX + barrelStep} ${bottomY}
    L ${leftX + lip} ${bottomY}
    L ${leftX + lip} ${bottomY - 22}
    L ${leftX} ${bottomY - 22}

    M ${rightX} ${topY + 22}
    L ${rightX - lip} ${topY + 22}
    L ${rightX - lip} ${topY}
    L ${rightX - barrelStep} ${topY}
    L ${rightX - barrelStep} ${topY + 36}
    L ${rightX - barrelStep - 26} ${topY + 52}
    L ${rightX - barrelStep - 38} ${centerY - 18}
    L ${rightX - barrelStep - 38} ${centerY + 18}
    L ${rightX - barrelStep - 26} ${bottomY - 52}
    L ${rightX - barrelStep} ${bottomY - 36}
    L ${rightX - barrelStep} ${bottomY}
    L ${rightX - lip} ${bottomY}
    L ${rightX - lip} ${bottomY - 22}
    L ${rightX} ${bottomY - 22}
  `;
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

  const scale = 1.05;
  const centerX = 500;
  const centerY = 245;

  const oemWidthPx = oemWidthMm * scale;
  const selectedWidthPx = selectedWidthMm * scale;

  const selectedShiftPx = outerChange * scale;

  const oemLeft = centerX - oemWidthPx / 2;
  const oemRight = centerX + oemWidthPx / 2;

  const selectedLeft = centerX - selectedWidthPx / 2 + selectedShiftPx;
  const selectedRight = centerX + selectedWidthPx / 2 + selectedShiftPx;

  const oemTop = 130;
  const oemBottom = 360;
  const selectedTop = 112;
  const selectedBottom = 378;

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
          aria-label="Wheel fitment cross-section comparison"
        >
          <defs>
            <pattern
              id="oemHatch"
              patternUnits="userSpaceOnUse"
              width="10"
              height="10"
              patternTransform="rotate(45)"
            >
              <line x1="0" y1="0" x2="0" y2="10" stroke="rgba(251,146,60,0.32)" strokeWidth="3" />
            </pattern>

            <pattern
              id="selectedHatch"
              patternUnits="userSpaceOnUse"
              width="10"
              height="10"
              patternTransform="rotate(-45)"
            >
              <line x1="0" y1="0" x2="0" y2="10" stroke="rgba(96,165,250,0.36)" strokeWidth="3" />
            </pattern>

            <filter id="softGlow">
              <feGaussianBlur stdDeviation="3" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>

            <linearGradient id="hubGradient" x1="0" x2="1">
              <stop offset="0%" stopColor="rgba(255,255,255,0.1)" />
              <stop offset="50%" stopColor="rgba(255,255,255,0.28)" />
              <stop offset="100%" stopColor="rgba(255,255,255,0.1)" />
            </linearGradient>
          </defs>

          {/* background panel */}
          <rect x="110" y="50" width="780" height="400" rx="34" fill="rgba(255,255,255,0.018)" stroke="rgba(255,255,255,0.08)" />

          {/* simplified suspension / strut context */}
          <g opacity="0.45">
            <path
              d="M185 105 C120 160 120 310 188 382"
              fill="none"
              stroke="rgba(255,255,255,0.18)"
              strokeWidth="16"
              strokeLinecap="round"
            />
            <path
              d="M178 160 L275 210"
              fill="none"
              stroke="rgba(255,255,255,0.16)"
              strokeWidth="12"
              strokeLinecap="round"
            />
            <path
              d="M178 330 L275 284"
              fill="none"
              stroke="rgba(255,255,255,0.16)"
              strokeWidth="12"
              strokeLinecap="round"
            />
            <circle cx="170" cy="160" r="12" fill="rgba(255,255,255,0.18)" />
            <circle cx="170" cy="330" r="12" fill="rgba(255,255,255,0.18)" />
          </g>

          {/* mounting face / hub centerline */}
          <line
            x1={centerX}
            y1="52"
            x2={centerX}
            y2="450"
            stroke="rgba(255,255,255,0.28)"
            strokeWidth="2"
            strokeDasharray="8 8"
          />

          <rect x={centerX - 7} y="118" width="14" height="264" rx="7" fill="url(#hubGradient)" />

          {/* OEM cross-section */}
          <path
            d={wheelPath(oemLeft, oemRight, oemTop, oemBottom)}
            fill="url(#oemHatch)"
            stroke="rgba(251,146,60,0.9)"
            strokeWidth="4"
            strokeLinejoin="round"
            filter="url(#softGlow)"
          />

          {/* Selected cross-section */}
          <path
            d={wheelPath(selectedLeft, selectedRight, selectedTop, selectedBottom)}
            fill="url(#selectedHatch)"
            stroke="rgba(96,165,250,0.95)"
            strokeWidth="4"
            strokeLinejoin="round"
            filter="url(#softGlow)"
          />

          {/* hub bore */}
          <circle cx={centerX} cy={centerY} r="58" fill="rgba(0,0,0,0.55)" stroke="rgba(255,255,255,0.38)" strokeWidth="3" />
          <circle cx={centerX} cy={centerY} r="34" fill="rgba(0,0,0,0.65)" stroke="rgba(255,255,255,0.72)" strokeWidth="3" />

          {/* mounting face label */}
          <rect x="390" y="72" width="220" height="42" rx="21" fill="rgba(0,0,0,0.72)" stroke="rgba(255,255,255,0.1)" />
          <text x="500" y="99" textAnchor="middle" fill="rgba(255,255,255,0.45)" fontSize="15" letterSpacing="4">
            HUB / MOUNT FACE
          </text>

          {/* inner clearance badge */}
          <g>
            <rect x="125" y="72" width="190" height="90" rx="18" fill="rgba(251,146,60,0.12)" stroke="rgba(251,146,60,0.38)" />
            <text x="148" y="107" fill="rgba(253,186,116,0.95)" fontSize="14" letterSpacing="3">
              INNER CLEARANCE
            </text>
            <text x="148" y="142" fill="rgb(254,215,170)" fontSize="34" fontWeight="800">
              {formatMm(innerChange)}
            </text>
          </g>

          {/* poke badge */}
          <g>
            <rect x="685" y="72" width="190" height="90" rx="18" fill="rgba(59,130,246,0.14)" stroke="rgba(96,165,250,0.42)" />
            <text x="708" y="107" fill="rgba(147,197,253,0.95)" fontSize="14" letterSpacing="3">
              OUTER / POKE
            </text>
            <text x="708" y="142" fill="rgb(191,219,254)" fontSize="34" fontWeight="800">
              {formatMm(outerChange)}
            </text>
          </g>

          {/* arrows showing shift */}
          <g opacity="0.8">
            <line x1={oemRight} y1="405" x2={selectedRight} y2="405" stroke="rgba(96,165,250,0.8)" strokeWidth="3" />
            <polygon
              points={`${selectedRight},405 ${selectedRight - 10},399 ${selectedRight - 10},411`}
              fill="rgba(96,165,250,0.85)"
            />

            <line x1={oemLeft} y1="405" x2={selectedLeft} y2="405" stroke="rgba(251,146,60,0.65)" strokeWidth="3" />
            <polygon
              points={`${selectedLeft},405 ${selectedLeft + 10},399 ${selectedLeft + 10},411`}
              fill="rgba(251,146,60,0.75)"
            />
          </g>

          {/* legend */}
          <rect x="340" y="420" width="320" height="38" rx="19" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x="500" y="444" textAnchor="middle" fill="rgba(255,255,255,0.48)" fontSize="14" letterSpacing="5">
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
