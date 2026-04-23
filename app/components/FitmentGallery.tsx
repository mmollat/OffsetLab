"use client";

import type { StyleKey } from "../data/fitment";

type GalleryExample = {
  label: string;
  vehicle: string;
  wheel: string;
  tire: string;
  note: string;
  placeholder: string;
};

const examples: Record<StyleKey, GalleryExample[]> = {
  oemplus: [
    {
      label: "OEM+ Reference",
      vehicle: "Tesla Model 3",
      wheel: "19x8.5 +35",
      tire: "245/40R19",
      note: "Clean upgrade with near-stock usability and a sharper stance.",
      placeholder: "OEM+",
    },
    {
      label: "Daily Clean",
      vehicle: "Tesla Model Y",
      wheel: "20x9.5 +40",
      tire: "255/40R20",
      note: "Subtle fitment improvement without pushing clearance.",
      placeholder: "DAILY",
    },
  ],
  flush: [
    {
      label: "Flush Reference",
      vehicle: "Tesla Model 3",
      wheel: "19x9.5 +30",
      tire: "265/35R19",
      note: "Balanced stance that fills the fenders without looking overdone.",
      placeholder: "FLUSH",
    },
    {
      label: "SUV Flush",
      vehicle: "Tesla Model Y",
      wheel: "20x10 +35",
      tire: "275/40R20",
      note: "A strong daily fitment with more presence and low compromise.",
      placeholder: "Y FLUSH",
    },
  ],
  aggressive: [
    {
      label: "Aggressive Reference",
      vehicle: "Tesla Model 3 Performance",
      wheel: "20x9 +25 / 20x10.5 +38",
      tire: "245/35R20 / 285/30R20",
      note: "Strong visual stance with tighter but manageable fitment.",
      placeholder: "AGGRO",
    },
    {
      label: "Wide Rear",
      vehicle: "Tesla Model S Plaid",
      wheel: "21x10 +30 / 21x11 +38",
      tire: "275/35R21 / 305/30R21",
      note: "Sharper stance for a performance sedan without going full show car.",
      placeholder: "PLAID",
    },
  ],
};

export default function FitmentGallery({
  model,
  trim,
  style,
}: {
  model: string;
  trim: string;
  style: StyleKey;
}) {
  const cards = examples[style];

  return (
    <section className="mt-8 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-wide text-white/40">
            Visual Fitment Examples
          </p>
          <h3 className="mt-2 text-2xl font-bold">See the stance before you commit</h3>
          <p className="mt-2 max-w-2xl text-sm leading-6 text-white/55">
            Early example cards for {model} {trim}. Real owner photos and verified
            setups can replace these placeholders later.
          </p>
        </div>

        <div className="rounded-full border border-white/10 bg-black/30 px-4 py-2 text-sm text-white/55">
          Gallery v1
        </div>
      </div>

      <div className="mt-6 grid gap-4 md:grid-cols-2">
        {cards.map((card) => (
          <article
            key={`${card.label}-${card.vehicle}`}
            className="overflow-hidden rounded-3xl border border-white/10 bg-black/30"
          >
            <div className="flex h-44 items-center justify-center bg-white/[0.04]">
              <div className="text-center">
                <p className="text-xs uppercase tracking-[0.35em] text-white/30">
                  Image Placeholder
                </p>
                <p className="mt-3 text-3xl font-black tracking-tight text-white/75">
                  {card.placeholder}
                </p>
              </div>
            </div>

            <div className="p-5">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-sm text-white/45">{card.label}</p>
                  <h4 className="mt-1 text-lg font-semibold">{card.vehicle}</h4>
                </div>
                <span className="rounded-full border border-white/10 px-3 py-1 text-xs text-white/50">
                  {style === "oemplus" ? "OEM+" : style === "flush" ? "Flush" : "Aggressive"}
                </span>
              </div>

              <div className="mt-4 grid gap-3 sm:grid-cols-2">
                <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-4">
                  <p className="text-xs uppercase tracking-wide text-white/35">Wheel</p>
                  <p className="mt-2 text-sm font-semibold">{card.wheel}</p>
                </div>
                <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-4">
                  <p className="text-xs uppercase tracking-wide text-white/35">Tire</p>
                  <p className="mt-2 text-sm font-semibold">{card.tire}</p>
                </div>
              </div>

              <p className="mt-4 text-sm leading-6 text-white/60">{card.note}</p>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
