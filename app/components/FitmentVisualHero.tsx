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
  if (match) return Number(match[0]);

  const normalized = value.toLowerCase();

  if (normalized.includes("flush+")) return 4;
  if (normalized.includes("flush")) return 12;
  if (normalized.includes("safe")) return -6;
  if (normalized.includes("tight")) return -10;
  if (normalized.includes("moderate")) return 8;
  if (normalized.includes("aggressive")) return 22;

  return 0;
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
        <div className="h-full rounded-full bg-red-500" style={{ width: `${width}%` }} />
      </div>
    </div>
  );
}

function TireSvg() {
  return (
    <svg viewBox="0 0 120 200" className="h-full w-full" fill="none">
      <rect x="12" y="6" width="96" height="188" rx="40" fill="#07101f" stroke="#3b82f6" strokeWidth="8" />
      <rect x="30" y="26" width="60" height="148" rx="28" fill="#101827" stroke="#60a5fa" strokeWidth="4" />

      {Array.from({ length: 10 }).map((_, i) => (
        <path
          key={i}
          d={`M24 ${24 + i * 16} L48 ${38 + i * 16}`}
          stroke="#2563eb"
          strokeOpacity="0.5"
          strokeWidth="2"
        />
      ))}

      {Array.from({ length: 10 }).map((_, i) => (
        <path
          key={i}
          d={`M96 ${24 + i * 16} L72 ${38 + i * 16}`}
          stroke="#2563eb"
          strokeOpacity="0.5"
          strokeWidth="2"
        />
      ))}

      <line x1="60" y1="34" x2="60" y2="166" stroke="white" strokeOpacity="0.35" />
    </svg>
  );
}

function SuspensionSvg() {
  return (
    <svg viewBox="0 0 160 220" className="h-full w-full" fill="none">
      <path d="M96 18 C122 32 122 56 96 70 C70 84 70 108 96 122 C122 136 122 160 96 174" stroke="white" strokeOpacity="0.35" strokeWidth="5" />
      <line x1="96" y1="20" x2="96" y2="188" stroke="white" strokeOpacity="0.35" strokeWidth="4" />
      <path d="M96 126 L38 154" stroke="white" strokeOpacity="0.16" strokeWidth="4" />
      <path d="M96 150 L142 176" stroke="white" strokeOpacity="0.16" strokeWidth="4" />
      <circle cx="96" cy="126" r="9" stroke="white" strokeOpacity="0.2" strokeWidth="3" />
      <circle cx="96" cy="150" r="9" stroke="white" strokeOpacity="0.2" strokeWidth="3" />
    </svg>
  );
}

function WheelDiagram({ label, poke, inner }: { label: string; poke: string; inner?: string }) {
  const pokeValue = parseMm(poke);
  const VISUAL_BASELINE_OFFSET = -23;
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
        <div className="absolute left-[42%] top-8 h-48 w-px bg-red-500/70" />
        <div className="absolute left-[42%] top-8 text-xs uppercase tracking-wide text-red-400">
          Fender
        </div>

        <div className="absolute right-[2%] top-8 h-52 w-40 opacity-100">
          <SuspensionSvg />
        </div>

        <div
          className="absolute top-14 h-44 w-28 drop-shadow-[0_0_28px_rgba(59,130,246,0.45)] transition-all duration-500"
          style={{ left: `calc(42% + ${wheelShift}px)` }}
        >
          <TireSvg />
        </div>

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

        {inner ? (
          <p className="absolute bottom-5 right-5 text-xs text-blue-300">
            Inner {inner}
          </p>
        ) : null}
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
            <p className="text-xs uppercase tracking-wide text-white/35">Front Setup</p>
            <p className="mt-2 text-2xl font-bold text-white">{frontWheel}</p>
            <p className="text-white/50">{frontTire}</p>
          </div>

          <div className="border-t border-white/10 pt-5">
            <p className="text-xs uppercase tracking-wide text-white/35">Rear Setup</p>
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
