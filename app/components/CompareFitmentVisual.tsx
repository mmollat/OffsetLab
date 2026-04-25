"use client";

type Props = {
  oemFront: string;
  selectedFront: string;
};

function parseWheel(spec: string) {
  // "21x9.5 +40"
  const match = spec.match(/(\d+\.?\d*)x(\d+\.?\d*)\s*\+?(-?\d+)/i);
  if (!match) return null;

  return {
    diameter: parseFloat(match[1]),
    width: parseFloat(match[2]),
    offset: parseFloat(match[3]),
  };
}

export default function CompareFitmentVisual({
  oemFront,
  selectedFront,
}: Props) {
  const oem = parseWheel(oemFront);
  const selected = parseWheel(selectedFront);

  if (!oem || !selected) {
    return (
      <div className="rounded-3xl border border-white/10 p-6 text-white/50">
        Invalid wheel data
      </div>
    );
  }

  // convert width to mm (1 inch = 25.4mm)
  const oemWidth = oem.width * 25.4;
  const newWidth = selected.width * 25.4;

  const halfOem = oemWidth / 2;
  const halfNew = newWidth / 2;

  const innerChange = (halfNew - halfOem) + (selected.offset - oem.offset);
  const outerChange = (halfNew - halfOem) - (selected.offset - oem.offset);

  const scale = 2; // visual scale multiplier

  const oemOuter = halfOem * scale;
  const newOuter = halfNew * scale;

  return (
    <div className="rounded-3xl border border-white/10 bg-[#050609] p-6">
      <div className="relative h-[260px] w-full">
        {/* center line */}
        <div className="absolute left-1/2 top-0 h-full w-px bg-white/10" />

        {/* OEM */}
        <div
          className="absolute top-1/2 -translate-y-1/2 border-2 border-orange-400/80 rounded-md"
          style={{
            width: oemOuter * 2,
            height: 80,
            left: `calc(50% - ${oemOuter}px)`,
          }}
        />

        {/* Selected */}
        <div
          className="absolute top-1/2 -translate-y-1/2 border-2 border-blue-400/80 rounded-md"
          style={{
            width: newOuter * 2,
            height: 80,
            left: `calc(50% - ${newOuter}px + ${outerChange * scale}px)`,
          }}
        />

        {/* INNER CLEARANCE */}
        <div className="absolute left-6 top-6 rounded-xl bg-orange-500/10 border border-orange-400/20 px-4 py-2">
          <p className="text-xs text-orange-300">INNER CLEARANCE</p>
          <p className="text-xl font-bold text-orange-200">
            {innerChange > 0 ? "+" : ""}
            {innerChange.toFixed(0)}mm
          </p>
        </div>

        {/* OUTER */}
        <div className="absolute right-6 top-6 rounded-xl bg-blue-500/10 border border-blue-400/20 px-4 py-2">
          <p className="text-xs text-blue-300">OUTER / POKE</p>
          <p className="text-xl font-bold text-blue-200">
            {outerChange > 0 ? "+" : ""}
            {outerChange.toFixed(0)}mm
          </p>
        </div>

        {/* labels */}
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 text-xs text-white/40">
          OEM = Orange • Selected = Blue
        </div>
      </div>
    </div>
  );
}
