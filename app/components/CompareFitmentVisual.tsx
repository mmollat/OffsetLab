"use client";

type Props = {
  oemFront: string;
  selectedFront: string;
  oemRear?: string;
  selectedRear?: string;
  selectedLabel?: string;
};

function parseWheel(spec: string) {
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
      <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-6 text-white/50">
        Unable to compare wheel specs.
      </div>
    );
  }

  const oemWidthMm = oem.width * 25.4;
  const selectedWidthMm = selected.width * 25.4;

  const innerChange =
    selectedWidthMm / 2 + selected.offset - (oemWidthMm / 2 + oem.offset);

  const outerChange =
    selectedWidthMm / 2 - selected.offset - (oemWidthMm / 2 - oem.offset);

  const scale = 1.4;
  const oemVisualWidth = oemWidthMm * scale;
  const selectedVisualWidth = selectedWidthMm * scale;

  const oemLeft = 50 - oemVisualWidth / 2;
  const selectedLeft = 50 - selectedVisualWidth / 2 + outerChange * scale;

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="mb-5 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-[0.25em] text-white/40">
            Fitment Cross-Section
          </p>
          <h2 className="mt-2 text-2xl font-bold">
            OEM vs Selected
          </h2>
        </div>
        {selectedLabel ? (
          <p className="text-sm text-white/50">{selectedLabel}</p>
        ) : null}
      </div>

      <div className="relative overflow-hidden rounded-3xl border border-white/10 bg-black/40 p-6">
        <div className="relative mx-auto h-[340px] max-w-4xl">
          <div className="absolute left-1/2 top-0 h-full border-l border-dashed border-white/20" />

          <div className="absolute left-1/2 top-8 -translate-x-1/2 rounded-full border border-white/10 bg-black px-4 py-2 text-xs uppercase tracking-[0.22em] text-white/45">
            Hub / Mounting Face
          </div>

          <div className="absolute left-6 top-8 rounded-2xl border border-orange-400/30 bg-orange-500/10 px-5 py-4">
            <p className="text-xs uppercase tracking-[0.2em] text-orange-300">
              Inner Clearance
            </p>
            <p className="mt-2 text-3xl font-bold text-orange-200">
              {formatMm(innerChange)}
            </p>
          </div>

          <div className="absolute right-6 top-8 rounded-2xl border border-blue-400/30 bg-blue-500/10 px-5 py-4">
            <p className="text-xs uppercase tracking-[0.2em] text-blue-300">
              Outer / Poke
            </p>
            <p className="mt-2 text-3xl font-bold text-blue-200">
              {formatMm(outerChange)}
            </p>
          </div>

          <div className="absolute left-1/2 top-[58%] h-[150px] w-[280px] -translate-x-1/2 -translate-y-1/2 rounded-[36px] border border-white/10 bg-white/[0.02]" />

          <div
            className="absolute top-[58%] h-[126px] -translate-y-1/2 rounded-[30px] border-[3px] border-orange-400/80 bg-orange-400/5"
            style={{
              width: `${oemVisualWidth}px`,
              left: `calc(${oemLeft}% - ${oemVisualWidth / 2}px)`,
            }}
          />

          <div
            className="absolute top-[58%] h-[150px] -translate-y-1/2 rounded-[34px] border-[3px] border-blue-400/90 bg-blue-400/5"
            style={{
              width: `${selectedVisualWidth}px`,
              left: `calc(${selectedLeft}% - ${selectedVisualWidth / 2}px)`,
            }}
          />

          <div className="absolute left-1/2 top-[58%] h-[170px] w-[16px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-white/20" />

          <div className="absolute left-1/2 top-[58%] h-[92px] w-[92px] -translate-x-1/2 -translate-y-1/2 rounded-full border-2 border-white/40 bg-black/40" />
          <div className="absolute left-1/2 top-[58%] h-[54px] w-[54px] -translate-x-1/2 -translate-y-1/2 rounded-full border-2 border-white/70 bg-black" />

          <div className="absolute bottom-4 left-1/2 -translate-x-1/2 rounded-full border border-white/10 bg-black/70 px-5 py-2 text-xs uppercase tracking-[0.28em] text-white/45">
            OEM = Orange · Selected = Blue
          </div>
        </div>
      </div>
    </section>
  );
}
