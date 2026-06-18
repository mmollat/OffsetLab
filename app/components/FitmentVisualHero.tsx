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

type Axle = "front" | "rear";

function clamp(value: number, min: number, max: number) {
  return Math.min(Math.max(value, min), max);
}

function parseWheelWidth(value: string) {
  const match = value.match(/x(\d+(?:\.\d+)?)/i);
  return match ? Number(match[1]) * 25.4 : 230;
}

function parseTireWidth(value: string, wheel: string) {
  const match = value.match(/(\d{3})\s*\/\s*\d{2}/);
  return match ? Number(match[1]) : parseWheelWidth(wheel) + 15;
}

function parsePosition(value: string) {
  const match = value.match(/([+-]?\d+(?:\.\d+)?)\s*mm/i);
  if (match) return Number(match[1]);

  const normalized = value.toLowerCase();
  if (normalized.includes("flush+")) return 5;
  if (normalized.includes("flush")) return 0;
  if (normalized.includes("safe") || normalized.includes("tucked")) return -8;
  if (normalized.includes("moderate")) return 10;
  if (normalized.includes("strong")) return 18;
  if (normalized.includes("aggressive")) return 24;

  return 0;
}

function positionLabel(position: number) {
  if (position <= -4) return "Tucked";
  if (position < 7) return "Flush";
  if (position < 18) return "Mild Poke";
  return "Aggressive Poke";
}

function formatPosition(position: number) {
  const rounded = Math.round(position);
  return `${rounded > 0 ? "+" : ""}${rounded} mm`;
}

function Meter({ label, value }: { label: string; value: number }) {
  const width = clamp(value, 0, 10) * 10;

  return (
    <div>
      <div className="mb-2 flex items-center justify-between text-xs font-bold uppercase tracking-[0.12em] text-white/35">
        <span>{label}</span>
        <span className="text-white/70">{value}/10</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-white/10">
        <div
          className="h-full rounded-full bg-red-500 transition-all duration-500"
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
  wheel,
  tire,
  axle,
}: {
  label: string;
  poke: string;
  inner?: string;
  wheel: string;
  tire: string;
  axle: Axle;
}) {
  const position = parsePosition(poke);
  const tireWidth = parseTireWidth(tire, wheel);
  const status = positionLabel(position);
  const tireScale = clamp(tireWidth / 285, 0.78, 1.28);
  const assemblyWidth = 330;
  const assemblyHeight = 325;
  const assemblyX = 18;
  const assemblyY = 62;
  const tireX = assemblyX + assemblyWidth * (210 / 340);
  const tireBaseWidth = assemblyWidth * (130 / 340);
  const tireRenderWidth = tireBaseWidth * tireScale;
  const tireOuter = tireX + tireRenderWidth;
  const fenderX = clamp(tireOuter + 16 + position * 0.55, tireOuter + 10, 412);
  const measureStart = tireOuter;
  const measureEnd = fenderX;
  const scalePosition = clamp(((position + 15) / 45) * 100, 4, 96);
  const arrowId = `measureArrow-${axle}`;

  return (
    <article className="rounded-[1.6rem] border border-white/10 bg-black/30 p-5">
      <div className="mb-4 flex items-center justify-between gap-4">
        <p className="text-sm font-black uppercase tracking-[0.22em] text-white/45">
          {label}
        </p>
        <span className="rounded-full border border-red-500/25 bg-red-500/[0.08] px-3 py-1 text-[10px] font-black uppercase tracking-[0.12em] text-red-300">
          {status}
        </span>
      </div>

      <div className="overflow-hidden rounded-2xl border border-white/10 bg-[radial-gradient(circle_at_50%_45%,rgba(59,130,246,0.08),transparent_42%),linear-gradient(145deg,rgba(255,255,255,0.045),transparent)]">
        <svg
          viewBox="0 0 520 430"
          className="block h-auto w-full"
          role="img"
          aria-label={`${label}: ${status}, outer position ${formatPosition(position)}`}
        >
          <defs>
            <marker
              id={arrowId}
              viewBox="0 0 10 10"
              refX="5"
              refY="5"
              markerWidth="5"
              markerHeight="5"
              orient="auto-start-reverse"
            >
              <path d="M 0 0 L 10 5 L 0 10 z" fill="#ffffff" />
            </marker>
          </defs>

          <text x="42" y="43" fill="#9097a3" fontSize="11" fontWeight="700" letterSpacing="1.3">
            INBOARD
          </text>
          <path d="M42 55 H98" stroke="#777f8c" strokeWidth="1.5" />
          <path d="M42 55 l9 -5 M42 55 l9 5" stroke="#777f8c" strokeWidth="1.5" />

          <text
            x="478"
            y="43"
            fill="#9097a3"
            fontSize="11"
            fontWeight="700"
            letterSpacing="1.3"
            textAnchor="end"
          >
            OUTBOARD
          </text>
          <path d="M422 55 H478" stroke="#777f8c" strokeWidth="1.5" />
          <path d="M478 55 l-9 -5 M478 55 l-9 5" stroke="#777f8c" strokeWidth="1.5" />

          <rect
            x={measureStart}
            y="72"
            width={Math.max(measureEnd - measureStart, 2)}
            height="270"
            fill="#ef4444"
            opacity={position > 0 ? 0.14 : 0.055}
          />

          <image
            href="/fitment-suspension-mockup.png"
            x={assemblyX}
            y={assemblyY}
            width={assemblyWidth}
            height={assemblyHeight}
            preserveAspectRatio="xMidYMid meet"
          />
          <image
            href="/fitment-tire-mockup.png"
            x={tireX}
            y={assemblyY}
            width={tireRenderWidth}
            height={assemblyHeight}
            preserveAspectRatio="none"
          />

          <line
            x1={fenderX}
            y1="70"
            x2={fenderX}
            y2="344"
            stroke="#fb4b55"
            strokeWidth="2.5"
          />
          <text
            x={fenderX}
            y="78"
            fill="#fb737b"
            fontSize="12"
            fontWeight="800"
            letterSpacing="0.5"
            textAnchor="middle"
          >
            FENDER LINE
          </text>

          <line
            x1={measureStart}
            y1="172"
            x2={measureEnd}
            y2="172"
            stroke="#ffffff"
            strokeWidth="2"
            markerStart={`url(#${arrowId})`}
            markerEnd={`url(#${arrowId})`}
          />
          <text
            x={fenderX + 16}
            y="165"
            fill="#aeb4bd"
            fontSize="11"
            fontWeight="700"
          >
            OUTER POSITION
          </text>
          <text
            x={fenderX + 16}
            y="190"
            fill="#ffffff"
            fontSize="20"
            fontWeight="800"
          >
            {formatPosition(position)}
          </text>

          <line x1="44" y1="376" x2="476" y2="376" stroke="#707783" strokeWidth="1.5" />
          <line x1="146" y1="370" x2="146" y2="382" stroke="#707783" />
          <line x1="260" y1="370" x2="260" y2="382" stroke="#707783" />
          <line x1="374" y1="370" x2="374" y2="382" stroke="#707783" />
          <circle cx={44 + (432 * scalePosition) / 100} cy="376" r="8" fill="#fb4b55" />
          <text x="52" y="358" fill="#a2a8b2" fontSize="11" fontWeight="700">TUCKED</text>
          <text x="260" y="358" fill="#a2a8b2" fontSize="11" fontWeight="700" textAnchor="middle">FLUSH</text>
          <text x="468" y="358" fill="#fb5f68" fontSize="11" fontWeight="700" textAnchor="end">POKE</text>

          <rect x="174" y="394" width="172" height="28" rx="14" fill="#190d0f" stroke="#ef4444" strokeOpacity="0.8" />
          <text x="260" y="413" fill="#fb636c" fontSize="11" fontWeight="800" letterSpacing="0.8" textAnchor="middle">
            {status.toUpperCase()}
          </text>
        </svg>
        {inner ? (
          <p className="border-t border-white/10 px-5 py-3 text-[11px] text-white/35">
            Inner clearance <span className="font-bold text-white/55">{inner}</span>
          </p>
        ) : null}
      </div>
    </article>
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
    <section className="rounded-[2rem] border border-white/10 bg-white/[0.035] p-5 shadow-2xl shadow-black/20 sm:p-6">
      <div className="mb-6 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-xs font-black uppercase tracking-[0.25em] text-red-400/70">
            Visual Fitment Analysis
          </p>
          <h2 className="mt-2 text-3xl font-black tracking-[-0.03em] text-white">
            {title}
          </h2>
          {subtitle ? <p className="mt-2 text-white/45">{subtitle}</p> : null}
        </div>

        <div className="w-fit rounded-2xl border border-red-500/30 bg-red-500/10 px-4 py-2 text-sm font-semibold text-red-300">
          {risk}
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-[1fr_310px]">
        <div className="grid gap-5 md:grid-cols-2">
          <WheelDiagram
            label="Front View"
            poke={pokeFront}
            inner={innerFront}
            wheel={frontWheel}
            tire={frontTire}
            axle="front"
          />
          <WheelDiagram
            label="Rear View"
            poke={pokeRear}
            inner={innerRear}
            wheel={rearWheel}
            tire={rearTire}
            axle="rear"
          />
        </div>

        <aside className="space-y-5 rounded-[1.6rem] border border-white/10 bg-black/30 p-5">
          <div>
            <p className="text-xs font-black uppercase tracking-[0.12em] text-white/30">
              Front Setup
            </p>
            <p className="mt-2 text-2xl font-black tracking-[-0.025em] text-white">
              {frontWheel}
            </p>
            <p className="mt-1 font-semibold text-white/45">{frontTire}</p>
          </div>

          <div className="border-t border-white/10 pt-5">
            <p className="text-xs font-black uppercase tracking-[0.12em] text-white/30">
              Rear Setup
            </p>
            <p className="mt-2 text-2xl font-black tracking-[-0.025em] text-white">
              {rearWheel}
            </p>
            <p className="mt-1 font-semibold text-white/45">{rearTire}</p>
          </div>

          <div className="space-y-5 border-t border-white/10 pt-5">
            <Meter label="Aggression" value={aggression} />
            <Meter label="Daily" value={daily} />
          </div>
        </aside>
      </div>
    </section>
  );
}
