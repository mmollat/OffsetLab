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

  const scale = 1.15;
  const hubX = 500;
  const topY = 88;
  const bottomY = 412;

  const oemLeft = hubX - (oemWidthMm / 2 + oem.offset) * scale;
  const oemRight = hubX + (oemWidthMm / 2 - oem.offset) * scale;

  const selectedLeft = hubX - (selectedWidthMm / 2 + selected.offset) * scale;
  const selectedRight = hubX + (selectedWidthMm / 2 - selected.offset) * scale;

  const wheelTop = 148;
  const wheelBottom = 352;
  const tireTop = 92;
  const tireBottom = 408;

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
          viewBox="0 0 1000 520"
          className="h-[390px] w-full"
          role="img"
          aria-label="Wheel fitment cross-section comparison"
        >
          <defs>
            <filter id="softGlow">
              <feGaussianBlur stdDeviation="2.5" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>

            <marker id="arrowBlue" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="rgb(96,165,250)" />
            </marker>

            <marker id="arrowOrange" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">
              <path d="M 0 0 L 10 5 L 0 10 z" fill="rgb(251,146,60)" />
            </marker>
          </defs>

          <rect x="90" y="42" width="820" height="436" rx="34" fill="rgba(255,255,255,0.018)" stroke="rgba(255,255,255,0.08)" />

          <text x="170" y="82" fill="rgba(255,255,255,0.48)" fontSize="15" letterSpacing="3">
            INSIDE / SUSPENSION
          </text>

          <text x="830" y="82" textAnchor="end" fill="rgba(255,255,255,0.48)" fontSize="15" letterSpacing="3">
            OUTSIDE / FENDER
          </text>

          <line x1={hubX} y1="72" x2={hubX} y2="448" stroke="rgba(255,255,255,0.28)" strokeWidth="2" strokeDasharray="8 8" />

          <rect x={hubX - 70} y="92" width="140" height="34" rx="17" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x={hubX} y="114" textAnchor="middle" fill="rgba(255,255,255,0.48)" fontSize="13" letterSpacing="4">
            HUB FACE
          </text>

          {/* simplified suspension background */}
          <g opacity="0.18">
            <path d="M 220 112 C 165 185 165 335 220 408" fill="none" stroke="white" strokeWidth="18" strokeLinecap="round" />
            <path d="M 214 178 L 355 238" fill="none" stroke="white" strokeWidth="11" strokeLinecap="round" />
            <path d="M 214 342 L 355 282" fill="none" stroke="white" strokeWidth="11" strokeLinecap="round" />
            <circle cx="208" cy="178" r="13" fill="white" />
            <circle cx="208" cy="342" r="13" fill="white" />
          </g>

          {/* OEM tire */}
          <path
            d={`
              M ${oemLeft - 24} ${tireTop}
              Q ${oemLeft - 42} ${tireTop + 18} ${oemLeft - 42} ${tireTop + 48}
              L ${oemLeft - 42} ${tireBottom - 48}
              Q ${oemLeft - 42} ${tireBottom - 18} ${oemLeft - 24} ${tireBottom}
              L ${oemRight + 24} ${tireBottom}
              Q ${oemRight + 42} ${tireBottom - 18} ${oemRight + 42} ${tireBottom - 48}
              L ${oemRight + 42} ${tireTop + 48}
              Q ${oemRight + 42} ${tireTop + 18} ${oemRight + 24} ${tireTop}
              Z
            `}
            fill="rgba(251,146,60,0.03)"
            stroke="rgba(251,146,60,0.88)"
            strokeWidth="3"
            strokeDasharray="8 6"
          />

          {/* Selected tire */}
          <path
            d={`
              M ${selectedLeft - 28} ${tireTop - 8}
              Q ${selectedLeft - 52} ${tireTop + 18} ${selectedLeft - 52} ${tireTop + 58}
              L ${selectedLeft - 52} ${tireBottom - 58}
              Q ${selectedLeft - 52} ${tireBottom - 18} ${selectedLeft - 28} ${tireBottom + 8}
              L ${selectedRight + 28} ${tireBottom + 8}
              Q ${selectedRight + 52} ${tireBottom - 18} ${selectedRight + 52} ${tireBottom - 58}
              L ${selectedRight + 52} ${tireTop + 58}
              Q ${selectedRight + 52} ${tireTop + 18} ${selectedRight + 28} ${tireTop - 8}
              Z
            `}
            fill="rgba(96,165,250,0.045)"
            stroke="rgba(96,165,250,0.95)"
            strokeWidth="4"
            filter="url(#softGlow)"
          />

          {/* OEM wheel barrel */}
          <path
            d={`
              M ${oemLeft} ${wheelTop}
              L ${oemLeft + 26} ${wheelTop}
              L ${oemLeft + 42} ${wheelTop + 38}
              L ${oemLeft + 42} ${wheelBottom - 38}
              L ${oemLeft + 26} ${wheelBottom}
              L ${oemLeft} ${wheelBottom}
              Z

              M ${oemRight} ${wheelTop}
              L ${oemRight - 26} ${wheelTop}
              L ${oemRight - 42} ${wheelTop + 38}
              L ${oemRight - 42} ${wheelBottom - 38}
              L ${oemRight - 26} ${wheelBottom}
              L ${oemRight} ${wheelBottom}
              Z
            `}
            fill="rgba(251,146,60,0.04)"
            stroke="rgba(251,146,60,0.9)"
            strokeWidth="3"
            strokeDasharray="8 6"
          />

          {/* Selected wheel barrel */}
          <path
            d={`
              M ${selectedLeft} ${wheelTop - 10}
              L ${selectedLeft + 28} ${wheelTop - 10}
              L ${selectedLeft + 48} ${wheelTop + 42}
              L ${selectedLeft + 48} ${wheelBottom - 42}
              L ${selectedLeft + 28} ${wheelBottom + 10}
              L ${selectedLeft} ${wheelBottom + 10}
              Z

              M ${selectedRight} ${wheelTop - 10}
              L ${selectedRight - 28} ${wheelTop - 10}
              L ${selectedRight - 48} ${wheelTop + 42}
              L ${selectedRight - 48} ${wheelBottom - 42}
              L ${selectedRight - 28} ${wheelBottom + 10}
              L ${selectedRight} ${wheelBottom + 10}
              Z
            `}
            fill="rgba(96,165,250,0.05)"
            stroke="rgba(96,165,250,0.98)"
            strokeWidth="4"
            filter="url(#softGlow)"
          />

          {/* hub / mounting pad */}
          <rect x={hubX - 7} y="170" width="14" height="180" rx="7" fill="rgba(255,255,255,0.24)" />
          <rect x={hubX - 52} y="224" width="104" height="72" rx="10" fill="rgba(255,255,255,0.18)" stroke="rgba(255,255,255,0.32)" />
          <rect x={hubX - 28} y="190" width="56" height="140" rx="8" fill="rgba(0,0,0,0.35)" stroke="rgba(255,255,255,0.2)" />

          {/* inner/outer edge reference */}
          <line x1={oemLeft - 42} y1="440" x2={oemLeft - 42} y2="458" stroke="rgba(251,146,60,0.85)" strokeWidth="3" />
          <line x1={selectedLeft - 52} y1="440" x2={selectedLeft - 52} y2="458" stroke="rgba(96,165,250,0.95)" strokeWidth="3" />
          <line x1={oemRight + 42} y1="440" x2={oemRight + 42} y2="458" stroke="rgba(251,146,60,0.85)" strokeWidth="3" />
          <line x1={selectedRight + 52} y1="440" x2={selectedRight + 52} y2="458" stroke="rgba(96,165,250,0.95)" strokeWidth="3" />

          <line x1={oemLeft - 42} y1="450" x2={selectedLeft - 52} y2="450" stroke="rgb(251,146,60)" strokeWidth="3" markerEnd="url(#arrowOrange)" />
          <line x1={oemRight + 42} y1="450" x2={selectedRight + 52} y2="450" stroke="rgb(96,165,250)" strokeWidth="3" markerEnd="url(#arrowBlue)" />

          <g>
            <rect x="126" y="118" width="210" height="82" rx="18" fill="rgba(251,146,60,0.12)" stroke="rgba(251,146,60,0.38)" />
            <text x="150" y="149" fill="rgba(253,186,116,0.95)" fontSize="13" letterSpacing="3">
              INNER CHANGE
            </text>
            <text x="150" y="183" fill="rgb(254,215,170)" fontSize="32" fontWeight="800">
              {formatMm(innerChange)}
            </text>
          </g>

          <g>
            <rect x="664" y="118" width="210" height="82" rx="18" fill="rgba(59,130,246,0.14)" stroke="rgba(96,165,250,0.42)" />
            <text x="688" y="149" fill="rgba(147,197,253,0.95)" fontSize="13" letterSpacing="3">
              OUTER POKE
            </text>
            <text x="688" y="183" fill="rgb(191,219,254)" fontSize="32" fontWeight="800">
              {formatMm(outerChange)}
            </text>
          </g>

          <rect x="330" y="466" width="340" height="34" rx="17" fill="rgba(0,0,0,0.75)" stroke="rgba(255,255,255,0.12)" />
          <text x="500" y="488" textAnchor="middle" fill="rgba(255,255,255,0.5)" fontSize="13" letterSpacing="4">
            OEM = ORANGE · SELECTED = BLUE
          </text>
        </svg>
      </div>
    </section>
  );
}
