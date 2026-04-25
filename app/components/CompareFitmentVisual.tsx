"use client";

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

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-4 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="text-xl font-bold">OEM vs Selected</h2>
        </div>
        {selectedLabel ? <span className="text-sm text-white/50">{selectedLabel}</span> : null}
      </div>

      <div className="rounded-3xl border border-white/10 bg-black/60 p-6">
        <svg viewBox="0 0 1000 520" className="h-[360px] w-full">
          <defs>
            <marker id="arrowBlue" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#3b82f6" />
            </marker>
            <marker id="arrowOrange" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#f97316" />
            </marker>
          </defs>

          <text x="120" y="70" fill="rgba(255,255,255,0.45)" fontSize="14" letterSpacing="3">
            INSIDE / SUSPENSION
          </text>
          <text x="880" y="70" textAnchor="end" fill="rgba(255,255,255,0.45)" fontSize="14" letterSpacing="3">
            OUTSIDE / FENDER
          </text>

          <line
            x1={centerX}
            y1="72"
            x2={centerX}
            y2="455"
            stroke="rgba(255,255,255,0.3)"
            strokeDasharray="6 6"
          />

          <rect x={centerX - 30} y="180" width="60" height="160" rx="6" fill="#666" />
          <rect x={centerX - 60} y="220" width="120" height="80" rx="8" fill="#888" />

          <rect
            x={oemLeft}
            y="105"
            width={oemRight - oemLeft}
            height="310"
            rx="18"
            fill="none"
            stroke="#f97316"
            strokeWidth="3"
            strokeDasharray="8 6"
          />

          <path
            d={`M ${selectedLeft} 92 L ${selectedRight} 92 L ${selectedRight} 428 L ${selectedLeft} 428 Z`}
            fill="rgba(59,130,246,0.06)"
            stroke="#3b82f6"
            strokeWidth="4"
          />

          <path
            d={`M ${selectedLeft + 26} 140 L ${selectedLeft + 58} 190 L ${selectedLeft + 58} 330 L ${selectedLeft + 26} 380`}
            fill="none"
            stroke="#3b82f6"
            strokeWidth="3"
          />

          <path
            d={`M ${selectedRight - 26} 140 L ${selectedRight - 58} 190 L ${selectedRight - 58} 330 L ${selectedRight - 26} 380`}
            fill="none"
            stroke="#3b82f6"
            strokeWidth="3"
          />

          <line x1={oemLeft} y1="445" x2={selectedLeft} y2="445" stroke="#f97316" strokeWidth="3" markerEnd="url(#arrowOrange)" />
          <line x1={oemRight} y1="445" x2={selectedRight} y2="445" stroke="#3b82f6" strokeWidth="3" markerEnd="url(#arrowBlue)" />

          <text x="120" y="205" fill="#f97316" fontSize="14" letterSpacing="2">
            INNER CHANGE
          </text>
          <text x="120" y="238" fill="#fff" fontSize="30" fontWeight="bold">
            {formatMm(innerChange)}
          </text>

          <text x="720" y="205" fill="#3b82f6" fontSize="14" letterSpacing="2">
            OUTER POKE
          </text>
          <text x="720" y="238" fill="#fff" fontSize="30" fontWeight="bold">
            {formatMm(outerChange)}
          </text>

          <text x="500" y="492" textAnchor="middle" fill="rgba(255,255,255,0.55)" fontSize="14" letterSpacing="4">
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
