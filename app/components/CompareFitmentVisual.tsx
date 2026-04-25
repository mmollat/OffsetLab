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

  const scale = 1.1;
  const hubX = 500;

  const oemLeft = hubX - (oemWidthMm / 2 + oem.offset) * scale;
  const oemRight = hubX + (oemWidthMm / 2 - oem.offset) * scale;

  const selectedLeft = hubX - (selectedWidthMm / 2 + selected.offset) * scale;
  const selectedRight = hubX + (selectedWidthMm / 2 - selected.offset) * scale;

  const topTire = 95;
  const bottomTire = 425;
  const topWheel = 160;
  const bottomWheel = 360;

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-5 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="mt-2 text-2xl font-bold">OEM vs Selected</h2>
        </div>

        {selectedLabel ? <p className="text-sm text-white/50">{selectedLabel}</p> : null}
      </div>

      <div className="overflow-hidden rounded-3xl border border-white/10 bg-black/50 p-4">
        <svg viewBox="0 0 1000 540" className="h-[420px] w-full" role="img">
          <defs>
            <filter id="blueGlow">
              <feGaussianBlur stdDeviation="2.5" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
          </defs>

          <rect x="90" y="35" width="820" height="470" rx="34" fill="rgba(255,255,255,0.018)" stroke="rgba(255,255,255,0.08)" />

          <text x="170" y="75" fill="rgba(255,255,255,0.45)" fontSize="15" letterSpacing="4">
            INSIDE / SUSPENSION
          </text>
          <text x="830" y="75" textAnchor="end" fill="rgba(255,255,255,0.45)" fontSize="15" letterSpacing="4">
            OUTSIDE / FENDER
          </text>

          {/* suspension background */}
          <g opacity="0.18">
            <path d="M 230 100 C 170 190 170 350 230 440" fill="none" stroke="white" strokeWidth="18" strokeLinecap="round" />
            <path d="M 225 190 L 350 250" fill="none" stroke="white" strokeWidth="12" strokeLinecap="round" />
            <path d="M 225 350 L 350 290" fill="none" stroke="white" strokeWidth="12" strokeLinecap="round" />
            <circle cx="220" cy="190" r="13" fill="white" />
            <circle cx="220" cy="350" r="13" fill="white" />
          </g>

          {/* hub face */}
          <line x1={hubX} y1="82" x2={hubX} y2="470" stroke="rgba(255,255,255,0.35)" strokeWidth="2" strokeDasharray="8 8" />
          <rect x={hubX - 65} y="88" width="130" height="34" rx="17" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x={hubX} y="110" textAnchor="middle" fill="rgba(255,255,255,0.48)" fontSize="13" letterSpacing="4">
            HUB FACE
          </text>

          {/* selected tire */}
          <path
            d={`
              M ${selectedLeft - 45} ${topTire + 35}
              Q ${selectedLeft - 65} ${topTire} ${selectedLeft - 28} ${topTire}
              L ${selectedRight + 28} ${topTire}
              Q ${selectedRight + 65} ${topTire} ${selectedRight + 45} ${topTire + 35}
              L ${selectedRight + 45} ${bottomTire - 35}
              Q ${selectedRight + 65} ${bottomTire} ${selectedRight + 28} ${bottomTire}
              L ${selectedLeft - 28} ${bottomTire}
              Q ${selectedLeft - 65} ${bottomTire} ${selectedLeft - 45} ${bottomTire - 35}
              Z
            `}
            fill="rgba(38,38,38,0.95)"
            stroke="rgba(59,163,255,1)"
            strokeWidth="4"
            filter="url(#blueGlow)"
          />

          {/* selected wheel barrel */}
          <path
            d={`
              M ${selectedLeft} ${topWheel}
              L ${selectedLeft + 34} ${topWheel}
              L ${selectedLeft + 58} ${topWheel + 48}
              L ${selectedLeft + 58} ${bottomWheel - 48}
              L ${selectedLeft + 34} ${bottomWheel}
              L ${selectedLeft} ${bottomWheel}
              Z

              M ${selectedRight} ${topWheel}
              L ${selectedRight - 34} ${topWheel}
              L ${selectedRight - 58} ${topWheel + 48}
              L ${selectedRight - 58} ${bottomWheel - 48}
              L ${selectedRight - 34} ${bottomWheel}
              L ${selectedRight} ${bottomWheel}
              Z
            `}
            fill="rgba(255,255,255,0.02)"
            stroke="rgba(59,163,255,1)"
            strokeWidth="4"
            filter="url(#blueGlow)"
          />

          {/* selected inner barrel lines */}
          <path
            d={`
              M ${selectedLeft + 18} ${topWheel + 10}
              L ${selectedLeft + 42} ${topWheel + 58}
              L ${selectedLeft + 42} ${bottomWheel - 58}
              L ${selectedLeft + 18} ${bottomWheel - 10}

              M ${selectedRight - 18} ${topWheel + 10}
              L ${selectedRight - 42} ${topWheel + 58}
              L ${selectedRight - 42} ${bottomWheel - 58}
              L ${selectedRight - 18} ${bottomWheel - 10}
            `}
            fill="none"
            stroke="rgba(59,163,255,0.7)"
            strokeWidth="2"
          />

          {/* OEM orange outline */}
          <path
            d={`
              M ${oemLeft - 32} ${topTire + 42}
              Q ${oemLeft - 48} ${topTire + 12} ${oemLeft - 18} ${topTire + 12}
              L ${oemRight + 18} ${topTire + 12}
              Q ${oemRight + 48} ${topTire + 12} ${oemRight + 32} ${topTire + 42}
              L ${oemRight + 32} ${bottomTire - 42}
              Q ${oemRight + 48} ${bottomTire - 12} ${oemRight + 18} ${bottomTire - 12}
              L ${oemLeft - 18} ${bottomTire - 12}
              Q ${oemLeft - 48} ${bottomTire - 12} ${oemLeft - 32} ${bottomTire - 42}
              Z
            `}
            fill="none"
            stroke="rgba(249,115,22,0.95)"
            strokeWidth="3"
          />

          <path
            d={`
              M ${oemLeft + 12} ${topWheel + 16}
              L ${oemLeft + 42} ${topWheel + 16}
              L ${oemLeft + 64} ${topWheel + 58}
              L ${oemLeft + 64} ${bottomWheel - 58}
              L ${oemLeft + 42} ${bottomWheel - 16}
              L ${oemLeft + 12} ${bottomWheel - 16}
              Z

              M ${oemRight - 12} ${topWheel + 16}
              L ${oemRight - 42} ${topWheel + 16}
              L ${oemRight - 64} ${topWheel + 58}
              L ${oemRight - 64} ${bottomWheel - 58}
              L ${oemRight - 42} ${bottomWheel - 16}
              L ${oemRight - 12} ${bottomWheel - 16}
              Z
            `}
            fill="none"
            stroke="rgba(249,115,22,0.95)"
            strokeWidth="3"
          />

          {/* small tread blocks */}
          {[0, 1, 2, 3].map((i) => (
            <g key={`top-${i}`}>
              <rect x={selectedLeft + 70 + i * 48} y={topTire} width="18" height="14" fill="rgba(5,5,5,0.95)" stroke="rgba(59,163,255,0.75)" strokeWidth="2" />
              <rect x={selectedRight - 88 - i * 48} y={topTire} width="18" height="14" fill="rgba(5,5,5,0.95)" stroke="rgba(59,163,255,0.75)" strokeWidth="2" />
              <rect x={selectedLeft + 70 + i * 48} y={bottomTire - 14} width="18" height="14" fill="rgba(5,5,5,0.95)" stroke="rgba(59,163,255,0.75)" strokeWidth="2" />
              <rect x={selectedRight - 88 - i * 48} y={bottomTire - 14} width="18" height="14" fill="rgba(5,5,5,0.95)" stroke="rgba(59,163,255,0.75)" strokeWidth="2" />
            </g>
          ))}

          {/* hub / brake hat */}
          <rect x={hubX - 7} y="170" width="14" height="200" rx="7" fill="rgba(120,120,120,0.8)" />
          <rect x={hubX - 55} y="230" width="110" height="80" rx="8" fill="rgba(135,135,135,0.85)" stroke="rgba(255,255,255,0.25)" />
          <rect x={hubX - 30} y="200" width="60" height="140" rx="6" fill="rgba(80,80,80,0.95)" stroke="rgba(255,255,255,0.18)" />

          {/* value labels */}
          <g>
            <rect x="115" y="130" width="225" height="82" rx="18" fill="rgba(251,146,60,0.12)" stroke="rgba(251,146,60,0.38)" />
            <text x="140" y="162" fill="rgba(253,186,116,0.95)" fontSize="13" letterSpacing="3">
              INNER CHANGE
            </text>
            <text x="140" y="196" fill="rgb(254,215,170)" fontSize="32" fontWeight="800">
              {formatMm(innerChange)}
            </text>
          </g>

          <g>
            <rect x="660" y="130" width="225" height="82" rx="18" fill="rgba(59,130,246,0.14)" stroke="rgba(96,165,250,0.42)" />
            <text x="685" y="162" fill="rgba(147,197,253,0.95)" fontSize="13" letterSpacing="3">
              OUTER POKE
            </text>
            <text x="685" y="196" fill="rgb(191,219,254)" fontSize="32" fontWeight="800">
              {formatMm(outerChange)}
            </text>
          </g>

          <rect x="325" y="465" width="350" height="34" rx="17" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x="500" y="487" textAnchor="middle" fill="rgba(255,255,255,0.5)" fontSize="13" letterSpacing="4">
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
