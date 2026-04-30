"use client";

type Props = {
  title: string;
  subtitle?: string;
  frontWheel: string;
  rearWheel: string;
  frontTire: string;
  rearTire: string;
  pokeFront: string;
  pokeRear: string;
  innerFront?: string;
  innerRear?: string;
  aggression: number;
  daily: number;
  risk: string;
};

function parseMm(value?: string) {
  if (!value) return 0;
  const match = value.match(/-?\d+/);
  return match ? Number(match[0]) : 0;
}

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max);
}

function Meter({ label, value }: { label: string; value: number }) {
  const width = clamp(value, 0, 10) * 10;

  return (
    <div>
      <div className="mb-2 flex items-center justify-between text-xs uppercase tracking-wide text-white/40">
        <span>{label}</span>
        <span className="text-white/70">{value}/10</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-white/10">
        <div
          className="h-full rounded-full bg-red-500"
          style={{ width: `${width}%` }}
        />
      </div>
    </div>
  );
}

function WheelDiagram({
  label,
  poke,
  inner,
}: {
  label: string;
  poke: string;
  inner?: string;
}) {
  const pokeValue = parseMm(poke);
  const innerValue = parseMm(inner);
  const VISUAL_BASELINE_OFFSET = -20;
const wheelShift = clamp((pokeValue + VISUAL_BASELINE_OFFSET) * -1.1, -36, 36);

  return (
    <div className="rounded-3xl border border-white/10 bg-black/30 p-5">
      <div className="mb-4 flex items-center justify-between">
        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/45">
          {label}
        </p>
        <p className="text-sm text-red-400">{poke}</p>
      </div>

      <div className="relative h-64 overflow-hidden rounded-2xl border border-white/10 bg-gradient-to-br from-white/[0.06] to-transparent">
        {/* Fender line */}
        <div className="absolute left-[42%] top-8 h-48 w-px bg-red-500/70" />
        <div className="absolute left-[42%] top-8 text-xs uppercase tracking-wide text-red-400">
          Fender
        </div>

        {/* Suspension line */}
        <div className="absolute right-[18%] top-8 h-48 w-px border-r border-dashed border-blue-400/50" />
        <div className="absolute right-[11%] top-8 text-xs uppercase tracking-wide text-blue-300">
          Inner
        </div>

        {/* Suspension sketch */}
        <div className="absolute right-[12%] top-24 h-28 w-16 rounded-full border border-white/15 opacity-50" />
        <div className="absolute right-[13%] top-32 h-20 w-20 rotate-[-18deg] border-t border-white/15" />

        {/* Wheel/tire */}
        <div
          className="absolute top-16 h-40 w-24 rounded-[2rem] border-4 border-blue-500 bg-blue-500/10 shadow-[0_0_30px_rgba(59,130,246,0.35)] transition-all duration-500"
          style={{ left: `calc(42% + ${wheelShift}px)` }}
        >
          <div className="absolute inset-3 rounded-[1.4rem] border-2 border-blue-400/80" />
          <div className="absolute left-1/2 top-4 h-32 w-px -translate-x-1/2 bg-white/15" />
        </div>

        {/* Poke measurement */}
        <div
          className="absolute top-48 h-px bg-red-500"
          style={{
            left: "42%",
            width: `${Math.max(24, Math.abs(wheelShift))}px`,
          }}
        />
        <p className="absolute left-[44%] top-52 text-xs text-red-400">
          Poke {poke}
        </p>

        {/* Inner measurement */}
        <p className="absolute bottom-5 right-5 text-xs text-blue-300">
          Inner {inner || `${innerValue}mm`}
        </p>
      </div>
    </div>
  );
}

export default function FitmentVisualHero({
  title,
  subtitle,
  frontWheel,
  rearWheel,
  frontTire,
  rearTire,
  pokeFront,
  pokeRear,
  innerFront,
  innerRear,
  aggression,
  daily,
  risk,
}: Props) {
  return (
    <section className="rounded-[2rem] border border-white/10 bg-white/[0.035] p-6 shadow-2xl shadow-black/20">
      <div className="mb-6 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-red-400/70">
            Visual Fitment Analysis
          </p>
          <h2 className="mt-2 text-3xl font-bold text-white">{title}</h2>
          {subtitle ? <p className="mt-2 text-white/45">{subtitle}</p> : null}
        </div>

        <div className="rounded-2xl border border-red-500/30 bg-red-500/10 px-4 py-2 text-sm font-semibold text-red-300">
          {risk}
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-[1fr_320px]">
        <div className="grid gap-5 md:grid-cols-2">
          <WheelDiagram label="Front View" poke={pokeFront} inner={innerFront} />
          <WheelDiagram label="Rear View" poke={pokeRear} inner={innerRear} />
        </div>

        <div className="space-y-5 rounded-3xl border border-white/10 bg-black/30 p-5">
          <div>
            <p className="text-xs uppercase tracking-wide text-white/35">
              Front Setup
            </p>
            <p className="mt-2 text-2xl font-bold text-white">{frontWheel}</p>
            <p className="text-white/50">{frontTire}</p>
          </div>

          <div className="border-t border-white/10 pt-5">
            <p className="text-xs uppercase tracking-wide text-white/35">
              Rear Setup
            </p>
            <p className="mt-2 text-2xl font-bold text-white">{rearWheel}</p>
            <p className="text-white/50">{rearTire}</p>
          </div>

          <div className="space-y-5 border-t border-white/10 pt-5">
            <Meter label="Aggression" value={aggression} />
            <Meter label="Daily" value={daily} />
          </div>
        </div>
      </div>
    </section>
  );
}
