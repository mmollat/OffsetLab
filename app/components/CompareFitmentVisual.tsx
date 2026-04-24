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
  const maxShift = 34;
  const shiftPx = Math.max(-maxShift, Math.min(maxShift, result.outerChangeMm * 1.05));

  return (
    <section className="rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-wide text-white/40">Visual Compare</p>
          <h2 className="mt-2 text-2xl font-bold">OEM vs {selectedLabel}</h2>
          <p className="mt-2 text-sm text-white/55">
            Front-axle wheel and tire cross-section overlay.
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
        <div className="relative mx-auto h-[390px] max-w-[780px] overflow-hidden rounded-3xl border border-white/10 bg-[radial-gradient(circle_at_center,rgba(255,255,255,0.05),rgba(255,255,255,0.01)_45%,rgba(0,0,0,0.22)_100%)]">
          <div className="absolute inset-y-0 left-1/2 w-px -translate-x-1/2 border-l border-dashed border-white/20" />

          <div className="absolute left-1/2 top-[80px] z-10 h-[210px] w-[86px] -translate-x-1/2 rounded-[28px] border border-white/12 bg-white/8">
            <div className="absolute inset-x-3 top-3 h-[24px] rounded-full border border-white/10 bg-white/8" />
            <div className="absolute inset-x-3 bottom-3 h-[24px] rounded-full border border-white/10 bg-white/8" />
            <div className="absolute left-1/2 top-1/2 h-[60px] w-[60px] -translate-x-1/2 -translate-y-1/2 rounded-full border border-white/12 bg-black/25" />
          </div>

          <CrossSectionAssembly color="orange" widthPx={170} heightPx={248} shiftPx={0} />
          <CrossSectionAssembly color="blue" widthPx={198} heightPx={272} shiftPx={shiftPx} />

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

function CrossSectionAssembly({
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
  const outline = isOrange ? "border-orange-500/90" : "border-blue-500/90";
  const tireFill = isOrange ? "bg-orange-500/8" : "bg-blue-500/8";
  const rimFill = isOrange ? "bg-orange-500/10" : "bg-blue-500/10";
  const accent = isOrange ? "bg-orange-400/30" : "bg-blue-400/30";
  const shadow = isOrange ? "shadow-[0_0_25px_rgba(249,115,22,0.08)]" : "shadow-[0_0_25px_rgba(59,130,246,0.08)]";

  return (
    <div
      className="absolute left-1/2 top-[58px] z-20"
      style={{
        width: `${widthPx}px`,
        height: `${heightPx}px`,
        transform: `translateX(calc(-50% + ${shiftPx}px))`,
      }}
    >
      <div className={`absolute inset-0 rounded-[42px] border-[3px] ${outline} ${tireFill} ${shadow}`} />

      <div className={`absolute inset-x-[18px] top-[20px] bottom-[20px] rounded-[32px] border-[2px] ${outline} bg-black/25`} />

      <div className={`absolute inset-y-[44px] left-[34px] w-[20px] rounded-full ${accent}`} />
      <div className={`absolute inset-y-[44px] right-[34px] w-[20px] rounded-full ${accent}`} />

      <div className={`absolute left-[56px] right-[56px] top-[44px] h-[16px] rounded-full ${accent}`} />
      <div className={`absolute left-[56px] right-[56px] bottom-[44px] h-[16px] rounded-full ${accent}`} />

      <div className={`absolute left-[52px] right-[52px] top-[74px] bottom-[74px] rounded-[22px] border ${outline} ${rimFill}`} />
      <div className={`absolute left-[68px] right-[68px] top-[92px] bottom-[92px] rounded-[18px] border border-white/10 bg-black/30`} />
      <div className="absolute left-1/2 top-1/2 h-[52px] w-[52px] -translate-x-1/2 -translate-y-1/2 rounded-full border border-white/12 bg-black/45" />
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
