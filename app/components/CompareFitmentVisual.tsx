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
  const maxShift = 36;
  const shiftPx = Math.max(-maxShift, Math.min(maxShift, result.outerChangeMm));

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-wide text-white/40">Visual Compare</p>
          <h2 className="mt-2 text-2xl font-bold">OEM vs {selectedLabel}</h2>
          <p className="mt-2 text-sm text-white/55">
            Clean wheel cross-section overlay for the front axle.
          </p>
        </div>

        <div className="rounded-full border border-white/10 bg-black/40 px-4 py-2 text-sm text-white/70">
          Front axle only
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

      <div className="mt-8 rounded-3xl border border-white/10 bg-black/30 p-4 md:p-6">
        <div className="relative mx-auto h-[360px] max-w-[760px] overflow-hidden rounded-3xl border border-white/10 bg-[linear-gradient(180deg,rgba(255,255,255,0.03),rgba(255,255,255,0.015))]">
          <div className="absolute inset-y-0 left-1/2 w-px -translate-x-1/2 border-l border-dashed border-white/20" />

          <div className="absolute left-1/2 top-[74px] h-[210px] w-[82px] -translate-x-1/2 rounded-[24px] border border-white/15 bg-white/10" />
          <div className="absolute left-1/2 top-[154px] h-[50px] w-[50px] -translate-x-1/2 rounded-full border border-white/15 bg-black/30" />

          <WheelShell color="orange" widthPx={124} heightPx={190} shiftPx={0} />
          <WheelShell color="blue" widthPx={150} heightPx={224} shiftPx={shiftPx} />

          <div className="absolute left-4 top-4 rounded-2xl border border-orange-400/20 bg-orange-400/10 px-4 py-3 text-orange-300">
            <p className="text-xs uppercase tracking-wide">Inner Clearance</p>
            <p className="mt-1 text-2xl font-bold">{formatSigned(result.innerClearanceChangeMm)}</p>
          </div>

          <div className="absolute right-4 top-4 rounded-2xl border border-blue-400/20 bg-blue-400/10 px-4 py-3 text-blue-300">
            <p className="text-xs uppercase tracking-wide">Outer / Poke</p>
            <p className="mt-1 text-2xl font-bold">{formatSigned(result.outerChangeMm)}</p>
          </div>

          <div className="absolute left-1/2 bottom-5 -translate-x-1/2 rounded-full border border-white/10 bg-black/60 px-4 py-2 text-xs uppercase tracking-[0.2em] text-white/50">
            OEM = Orange · Selected = Blue
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
          Rear comparison available too: OEM {oemRear} → {selectedRear}. This visual focuses on the front axle first.
        </p>
      ) : null}

      <div className="mt-5 rounded-2xl border border-blue-400/20 bg-blue-400/5 p-4 text-sm text-blue-200">
        Note: This compares wheel width and offset only. Real clearance also depends on tires,
        camber, ride height, suspension, and brake clearance.
      </div>
    </section>
  );
}

function WheelShell({
  color,
  widthPx,
  heightPx,
  shiftPx,
}: {
  color: "orange" | "blue";
  widthPx: number;
  heightPx: number;
  shiftPx: number;
}) {
  const isOrange = color === "orange";
  const border = isOrange ? "border-orange-500/90" : "border-blue-500/90";
  const fill = isOrange ? "bg-orange-500/10" : "bg-blue-500/10";
  const edge = isOrange ? "bg-orange-400/30" : "bg-blue-400/30";

  return (
    <div
      className={`absolute left-1/2 top-[84px] rounded-[30px] border-[3px] ${border} ${fill}`}
      style={{
        width: `${widthPx}px`,
        height: `${heightPx}px`,
        transform: `translateX(calc(-50% + ${shiftPx}px))`,
      }}
    >
      <div className={`absolute inset-y-[10px] left-[10px] w-[14px] rounded-full ${edge}`} />
      <div className={`absolute inset-y-[10px] right-[10px] w-[14px] rounded-full ${edge}`} />
      <div className="absolute inset-x-[30px] top-[44px] bottom-[44px] rounded-[20px] border border-white/10 bg-black/20" />
      <div className="absolute left-1/2 top-1/2 h-[44px] w-[44px] -translate-x-1/2 -translate-y-1/2 rounded-full border border-white/10 bg-black/35" />
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
