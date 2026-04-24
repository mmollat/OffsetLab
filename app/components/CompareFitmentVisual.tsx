"use client";

import { compareWheelFitment, parseWheelSpec } from "../lib/compareMath";

type CompareFitmentVisualProps = {
  oemFront: string;
  selectedFront: string;
  oemRear?: string;
  selectedRear?: string;
  selectedLabel?: string;
};

export default function CompareFitmentVisual({
  oemFront,
  selectedFront,
  oemRear,
  selectedRear,
  selectedLabel = "Selected Setup",
}: CompareFitmentVisualProps) {
  const oem = parseWheelSpec(oemFront);
  const selected = parseWheelSpec(selectedFront);

  if (!oem || !selected) {
    return (
      <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
        <p className="text-sm uppercase tracking-wide text-white/40">Visual Compare</p>
        <p className="mt-3 text-sm text-white/55">
          Wheel specs could not be parsed for visual comparison.
        </p>
      </section>
    );
  }

  const result = compareWheelFitment(oem, selected);

  const maxVisual = 44;
  const outerPx = Math.max(-maxVisual, Math.min(maxVisual, result.outerChangeMm * 1.25));

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-wide text-white/40">Visual Compare</p>
          <h2 className="mt-2 text-2xl font-bold">OEM vs {selectedLabel}</h2>
          <p className="mt-2 text-sm text-white/55">
            Orange shows OEM. Blue shows your selected setup.
          </p>
        </div>

        <div className="rounded-full border border-blue-400/30 bg-blue-400/10 px-4 py-2 text-sm text-blue-300">
          Front axle
        </div>
      </div>

      <div className="mt-6 grid gap-4 md:grid-cols-3">
        <SpecHeader color="orange" title="OEM" wheel={oemFront} />
        <div className="hidden items-center justify-center md:flex">
          <div className="rounded-full border border-white/10 bg-black/40 px-4 py-3 text-sm font-bold">
            VS
          </div>
        </div>
        <SpecHeader color="blue" title={selectedLabel} wheel={selectedFront} />
      </div>

      <div className="mt-8 rounded-3xl border border-white/10 bg-black/30 p-6">
        <div className="relative mx-auto h-[360px] max-w-[620px] overflow-hidden rounded-3xl border border-white/10 bg-white/[0.02]">
          <div className="absolute left-1/2 top-10 h-[280px] w-8 -translate-x-1/2 rounded bg-white/20" />
          <div className="absolute left-1/2 top-0 h-full border-l border-dashed border-white/25" />

          <div
            className="absolute left-1/2 top-20 h-[210px] w-[120px] -translate-x-1/2 rounded-[2rem] border-4 border-orange-500/90 bg-orange-500/10"
            style={{ transform: "translateX(-50%)" }}
          >
            <div className="absolute left-1/2 top-0 h-full w-1 -translate-x-1/2 bg-orange-500/35" />
          </div>

          <div
            className="absolute left-1/2 top-12 h-[270px] w-[160px] rounded-[2.4rem] border-4 border-blue-500/90 bg-blue-500/10"
            style={{ transform: `translateX(calc(-50% + ${outerPx / 2}px))` }}
          >
            <div className="absolute left-1/2 top-0 h-full w-1 -translate-x-1/2 bg-blue-500/35" />
          </div>

          <div className="absolute right-6 top-20 rounded-2xl border border-blue-400/20 bg-blue-400/10 px-4 py-3">
            <p className="text-xs uppercase tracking-wide text-blue-300">Outer / Poke</p>
            <p className="mt-1 text-2xl font-bold text-blue-300">
              {formatSigned(result.outerChangeMm)}
            </p>
          </div>

          <div className="absolute left-6 top-20 rounded-2xl border border-orange-400/20 bg-orange-400/10 px-4 py-3">
            <p className="text-xs uppercase tracking-wide text-orange-300">Inner Clearance</p>
            <p className="mt-1 text-2xl font-bold text-orange-300">
              {formatSigned(result.innerClearanceChangeMm)}
            </p>
          </div>

          <div className="absolute bottom-6 left-1/2 -translate-x-1/2 rounded-2xl border border-white/10 bg-black/60 px-5 py-3 text-center">
            <p className="text-xs uppercase tracking-wide text-white/35">Section Width Change</p>
            <p className="mt-1 text-2xl font-bold">{formatSigned(result.widthChangeMm)}</p>
          </div>
        </div>
      </div>

      <div className="mt-6 grid gap-3 md:grid-cols-4">
        <Metric label="Outer / Poke" value={formatSigned(result.outerChangeMm)} helper="More positive = sticks out more" tone="blue" />
        <Metric label="Inner Clearance" value={formatSigned(result.innerClearanceChangeMm)} helper="Negative = closer to suspension" tone="orange" />
        <Metric label="Width Change" value={formatSigned(result.widthChangeMm)} helper="Total wheel width change" />
        <Metric label="Track Change" value={formatSigned(result.trackChangeMm)} helper="Across the axle" />
      </div>

      {oemRear && selectedRear ? (
        <p className="mt-5 text-sm text-white/45">
          Rear comparison available too: OEM {oemRear} → {selectedRear}. V1 visual currently displays front axle first.
        </p>
      ) : null}

      <div className="mt-5 rounded-2xl border border-blue-400/20 bg-blue-400/5 p-4 text-sm text-blue-200">
        Note: This visual compares wheel width and offset only. Real clearance may vary by tire brand,
        camber, ride height, brake clearance, and suspension setup.
      </div>
    </section>
  );
}

function SpecHeader({
  color,
  title,
  wheel,
}: {
  color: "orange" | "blue";
  title: string;
  wheel: string;
}) {
  const colorClass = color === "orange" ? "bg-orange-500" : "bg-blue-500";

  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-5">
      <div className="flex items-center gap-3">
        <span className={`h-3 w-3 rounded-full ${colorClass}`} />
        <p className="font-bold">{title}</p>
      </div>
      <p className="mt-3 text-2xl font-semibold">{wheel}</p>
    </div>
  );
}

function Metric({
  label,
  value,
  helper,
  tone,
}: {
  label: string;
  value: string;
  helper: string;
  tone?: "orange" | "blue";
}) {
  const toneClass =
    tone === "orange"
      ? "text-orange-300"
      : tone === "blue"
      ? "text-blue-300"
      : "text-white";

  return (
    <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
      <p className="text-xs uppercase tracking-wide text-white/35">{label}</p>
      <p className={`mt-2 text-2xl font-bold ${toneClass}`}>{value}</p>
      <p className="mt-2 text-xs leading-5 text-white/45">{helper}</p>
    </div>
  );
}

function formatSigned(value: number) {
  if (value > 0) return `+${value}mm`;
  if (value < 0) return `${value}mm`;
  return "0mm";
}
