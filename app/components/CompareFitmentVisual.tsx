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
      <div className="mb-4 flex justify-between items-end">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="text-xl font-bold">OEM vs Selected</h2>
        </div>
        {selectedLabel && (
          <span className="text-sm text-white/50">{selectedLabel}</span>
        )}
      </div>

      <div className="rounded-3xl border border-white/10 bg-black/60 p-6">
        <svg viewBox="0 0 1000 520" className="h-[360px] w-full">

          {/* CENTER HUB */}
          <rect x={centerX - 28} y="180" width="56" height="160" rx="6" fill="#666" />
          <rect x={centerX - 60} y="220" width="120" height="80" rx="8" fill="#888" />

          {/* CENTER LINE */}
          <line
            x1={centerX}
            y1="60"
            x2={centerX}
            y2="460"
            stroke="rgba(255,255,255,0.2)"
            strokeDasharray="6 6"
          />

          {/* OEM (orange ghost) */}
          <rect
            x={oemLeft - 16}
            y="90"
            width={oemRight - oemLeft + 32}
            height="340"
            rx="40"
            fill="rgba(249,115,22,0.04)"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="6 6"
          />

          <rect
            x={oemLeft}
            y="120"
            width={oemRight - oemLeft}
            height="280"
            rx="18"
            fill="none"
            stroke="#f97316"
            strokeWidth="2"
            strokeDasharray="6 6"
          />

          {/* SELECTED (main visual) */}
          <rect
            x={selectedLeft - 22}
            y="80"
            width={selectedRight - selectedLeft + 44}
            height="360"
            rx="50"
            fill="rgba(59,130,246,0.10)"
            stroke="#3b82f6"
            strokeWidth="4"
          />

          <rect
            x={selectedLeft}
            y="110"
            width={selectedRight - selectedLeft}
            height="300"
            rx="22"
            fill="rgba(59,130,246,0.05)"
            stroke="#3b82f6"
            strokeWidth="3"
          />

          {/* DEPTH / BARREL LINES */}
          <line
            x1={selectedLeft + 30}
            y1="140"
            x2={selectedLeft + 60}
            y2="190"
            stroke="#3b82f6"
            strokeWidth="2"
          />
          <line
            x1={selectedRight - 30}
            y1="140"
            x2={selectedRight - 60}
            y2="190"
            stroke="#3b82f6"
            strokeWidth="2"
          />

          {/* INNER CHANGE */}
          <line
            x1={oemLeft}
            y1="450"
            x2={selectedLeft}
            y2="450"
            stroke="#f97316"
            strokeWidth="3"
          />

          {/* OUTER POKE */}
          <line
            x1={oemRight}
            y1="450"
            x2={selectedRight}
            y2="450"
            stroke="#3b82f6"
            strokeWidth="3"
          />

          {/* TEXT */}
          <text x="120" y="210" fill="#f97316" fontSize="13">
            INNER
          </text>
          <text x="120" y="240" fill="#fff" fontSize="26" fontWeight="bold">
            {formatMm(innerChange)}
          </text>

          <text x="760" y="210" fill="#3b82f6" fontSize="13">
            OUTER
          </text>
          <text x="760" y="240" fill="#fff" fontSize="26" fontWeight="bold">
            {formatMm(outerChange)}
          </text>

          <text
            x="500"
            y="490"
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
