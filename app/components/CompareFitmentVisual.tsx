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
  const maxVisual = 40;
  const outerPx = Math.max(-maxVisual, Math.min(maxVisual, result.outerChangeMm * 1.1));

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

      <div className="mt-6 grid gap-3 md:hidden">
        <Metric label="Inner Clearance" value={formatSigned(result.innerClearanceChangeMm)} helper="Negative = closer to suspension" tone="orange" />
        <Metric label="Outer / Poke" value={formatSigned(result.outerChangeMm)} helper="More positive = sticks out more" tone="blue" />
      </div>

      <div className="mt-8 rounded-3xl border border-white/10 bg-black/30 p-4 md:p-6">
        <div className="relative mx-auto h-[360px] max-w-[680px] overflow-hidden rounded-3xl border border-white/10 bg-white/[0.02] md:h-[400px]">
          <div className="absolute left-1/2 top-8 h-[300px] w-10 -translate-x-1/2 rounded-full bg-white/15 md:top-10 md:h-[320px]" />
          <div className="absolute left-1/2 top-0 h-full border-l border-dashed border-white/20" />

          <div className="absolute inset-x-6 top-5 hidden items-start justify-between md:flex">
            <FloatingPill label="Inner Clearance" value={formatSigned(result.innerClearanceChangeMm)} tone="orange" />
            <FloatingPill label="Outer / Poke" value={formatSigned(result.outerChangeMm)} tone="blue" />
          </div>

          <div className="absolute inset-x-0 top-[112px] md:top-[122px]">
            <div className="relative mx-auto h-[190px] w-[250px] md:h-[210px] md:w-[320px]">
              <WheelSilhouette color="orange" size="oem" shiftPx={0} />
              <WheelSilhouette color="blue" size="selected" shiftPx={outerPx / 2} />
            </div>
          </div>

          <div className="absolute bottom-5 left-1/2 w-[220px] -translate-x-1/2 rounded-2xl border border-white/10 bg-black/70 px-5 py-3 text-center md:w-auto">
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

function WheelSilhouette({
  color,
  size,
  shiftPx,
}: {
  color: "orange" | "blue";
  size: "oem" | "selected";
  shiftPx: number;
}) {
  const isOrange = color === "orange";
  const border = isOrange ? "border-orange-500/90" : "border-blue-500/90";
  const bg = isOrange ? "bg-orange-500/10" : "bg-blue-500/10";
  const spoke = isOrange ? "bg-orange-400/35" : "bg-blue-400/35";
  const ring = size === "oem" ? "h-[170px] w-[110px] md:h-[190px] md:w-[120px]" : "h-[220px] w-[150px] md:h-[250px] md:w-[170px]";
  const top = size === "oem" ? "top-[18px]" : "top-0";

  return (
    <div
      className={`absolute left-1/2 ${top} ${ring} rounded-[2.8rem] border-4 ${border} ${bg} shadow-[0_0_40px_rgba(0,0,0,0.2)]`}
      style={{ transform: `translateX(calc(-50% + ${shiftPx}px))` }}
    >
      <div className="absolute inset-[10px] rounded-[2.2rem] border border-white/10" />
      <div className={`absolute left-1/2 top-0 h-full w-[2px] -translate-x-1/2 ${spoke}`} />
      <div className={`absolute left-1/2 top-0 h-full w-[2px] -translate-x-1/2 rotate-[28deg] ${spoke}`} />
      <div className={`absolute left-1/2 top-0 h-full w-[2px] -translate-x-1/2 -rotate-[28deg] ${spoke}`} />
      <div className={`absolute left-1/2 top-0 h-full w-[2px] -translate-x-1/2 rotate-[55deg] ${spoke}`} />
      <div className={`absolute left-1/2 top-0 h-full w-[2px] -translate-x-1/2 -rotate-[55deg] ${spoke}`} />
      <div className="absolute left-1/2 top-1/2 h-8 w-8 -translate-x-1/2 -translate-y-1/2 rounded-full border border-white/20 bg-black/40" />
    </div>
  );
}

function FloatingPill({
  label,
  value,
  tone,
}: {
  label: string;
  value: string;
  tone: "orange" | "blue";
}) {
  const toneClasses = tone === "orange"
    ? "border-orange-400/20 bg-orange-400/10 text-orange-300"
    : "border-blue-400/20 bg-blue-400/10 text-blue-300";

  return (
    <div className={`rounded-2xl border px-4 py-3 ${toneClasses}`}>
      <p className="text-xs uppercase tracking-wide">{label}</p>
      <p className="mt-1 text-2xl font-bold">{value}</p>
    </div>
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
