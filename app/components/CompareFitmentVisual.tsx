"use client";

type Props = {
  oemFront: string;
  selectedFront: string;
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
    return <div className="text-white/50">Invalid specs</div>;
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

  const selLeft = centerX - (selectedWidth / 2 + selected.offset) * scale;
  const selRight = centerX + (selectedWidth / 2 - selected.offset) * scale;

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-4 flex justify-between">
        <h2 className="text-xl font-bold">OEM vs Selected</h2>
        {selectedLabel && <span className="text-white/50">{selectedLabel}</span>}
      </div>

      <div className="rounded-3xl border border-white/10 bg-black/60 p-6">
        <svg viewBox="0 0 1000 520" className="w-full h-[360px]">

          {/* hub center */}
          <line
            x1={centerX}
            y1="40"
            x2={centerX}
            y2="480"
            stroke="rgba(255,255,255,0.3)"
            strokeDasharray="6 6"
          />

          {/* hub block */}
          <rect x={centerX - 30} y="180" width="60" height="160" fill="#666" />
          <rect x={centerX - 60} y="220" width="120" height="80" fill="#888" />

          {/* OEM (orange) */}
          <rect
            x={oemLeft}
            y="100"
            width={oemRight - oemLeft}
            height="320"
            fill="none"
            stroke="#f97316"
            strokeWidth="3"
            strokeDasharray="8 6"
          />

          {/* Selected (blue) */}
          <rect
            x={selLeft}
            y="90"
            width={selRight - selLeft}
            height="340"
            fill="none"
            stroke="#3b82f6"
            strokeWidth="4"
          />

          {/* INNER */}
          <text x="120" y="200" fill="#f97316" fontSize="14">
            INNER
          </text>
          <text x="120" y="230" fill="#fff" fontSize="26" fontWeight="bold">
            {formatMm(innerChange)}
          </text>

          {/* OUTER */}
          <text x="720" y="200" fill="#3b82f6" fontSize="14">
            OUTER
          </text>
          <text x="720" y="230" fill="#fff" fontSize="26" fontWeight="bold">
            {formatMm(outerChange)}
          </text>

        </svg>
      </div>
    </section>
  );
}
