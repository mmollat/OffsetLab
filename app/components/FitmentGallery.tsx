"use client";

import type { ModelKey, StyleKey } from "../data/fitment";

type GalleryExample = {
  label: string;
  wheel: string;
  tire: string;
  note: string;
  sourceName: string;
  sourceUrl: string;
  placeholder: string;
};

const examples: Record<ModelKey, Record<StyleKey, GalleryExample[]>> = {
  "Model 3": {
    oemplus: [
      {
        label: "Model 3 OEM+ Daily",
        wheel: "19x8.5 +35",
        tire: "245/40R19",
        note: "Clean OEM+ look with near-stock usability and a sharper stance.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 OEM+",
      },
      {
        label: "Model 3 Clean Street",
        wheel: "19x9 +35",
        tire: "255/40R19",
        note: "Slightly wider, still conservative, good daily-driver fitment.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 DAILY",
      },
    ],
    flush: [
      {
        label: "Model 3 Flush Daily",
        wheel: "19x9.5 +30",
        tire: "265/35R19",
        note: "Balanced stance that fills the fenders without looking overdone.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 FLUSH",
      },
      {
        label: "Model 3 20-inch Flush",
        wheel: "20x9 +30",
        tire: "255/35R20",
        note: "Sharper 20-inch fitment with a clean flush look.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 20s",
      },
    ],
    aggressive: [
      {
        label: "Model 3 Aggressive Staggered",
        wheel: "20x9 +25 / 20x10.5 +38",
        tire: "245/35R20 / 285/30R20",
        note: "Strong visual stance with tighter but manageable fitment.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 AGGRO",
      },
      {
        label: "Model 3 Aggressive Square",
        wheel: "19x9.5 +25",
        tire: "275/35R19",
        note: "Track-inspired square fitment with more front clearance sensitivity.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=3",
        placeholder: "M3 SQ",
      },
    ],
  },

  "Model Y": {
    oemplus: [
      {
        label: "Model Y OEM+ Daily",
        wheel: "20x9.5 +40",
        tire: "255/40R20",
        note: "Subtle improvement over stock with very low compromise.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MY OEM+",
      },
      {
        label: "Model Y Clean Upgrade",
        wheel: "20x10 +40",
        tire: "265/40R20",
        note: "Wider but still daily-friendly, good for a clean street setup.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MY DAILY",
      },
    ],
    flush: [
      {
        label: "Model Y Flush Square",
        wheel: "20x10 +35",
        tire: "275/40R20",
        note: "Filled-out Model Y stance with strong daily usability.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MY FLUSH",
      },
      {
        label: "Model Y Performance Flush",
        wheel: "21x9.5 +35 / 21x10.5 +42",
        tire: "265/35R21 / 295/35R21",
        note: "Clean staggered look with more authority than stock.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MYP FLUSH",
      },
    ],
    aggressive: [
      {
        label: "Model Y Aggressive Daily",
        wheel: "21x9.5 +30 / 21x10.5 +38",
        tire: "275/35R21 / 295/35R21",
        note: "Sharper stance with more presence, best when ride height is dialed.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MY AGGRO",
      },
      {
        label: "Model Y Wide Square",
        wheel: "20x10 +30",
        tire: "275/40R20",
        note: "Aggressive square setup with a planted SUV stance.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=Y",
        placeholder: "MY SQ",
      },
    ],
  },

  "Model S": {
    oemplus: [
      {
        label: "Model S OEM+ Luxury",
        wheel: "20x9 +35 / 20x10 +40",
        tire: "245/40R20 / 285/35R20",
        note: "Elegant OEM+ setup that sharpens the car without losing luxury feel.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "MS OEM+",
      },
      {
        label: "Model S Clean 21",
        wheel: "21x9 +35",
        tire: "255/35R21",
        note: "Clean 21-inch look with a conservative performance stance.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "MS CLEAN",
      },
    ],
    flush: [
      {
        label: "Model S Flush Staggered",
        wheel: "21x9 +30 / 21x10.5 +35",
        tire: "255/35R21 / 295/30R21",
        note: "Balanced luxury-performance stance with proper rear presence.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "MS FLUSH",
      },
      {
        label: "Model S Plaid Flush",
        wheel: "21x9.5 +35 / 21x10.5 +40",
        tire: "275/35R21 / 295/30R21",
        note: "Sharper flush fitment for a high-performance sedan.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "PLAID FLUSH",
      },
    ],
    aggressive: [
      {
        label: "Model S Aggressive Daily",
        wheel: "21x9.5 +28 / 21x10.5 +30",
        tire: "265/35R21 / 295/30R21",
        note: "More visual impact with a tighter fitment envelope.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "MS AGGRO",
      },
      {
        label: "Model S Plaid Wide",
        wheel: "21x10 +30 / 21x11 +38",
        tire: "275/35R21 / 305/30R21",
        note: "Aggressive Plaid fitment with stronger rear muscle.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=S",
        placeholder: "PLAID",
      },
    ],
  },

  "Model X": {
    oemplus: [
      {
        label: "Model X OEM+ SUV",
        wheel: "20x9.5 +35 / 20x10.5 +35",
        tire: "265/45R20 / 285/40R20",
        note: "Practical OEM+ SUV fitment that tightens the look.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX OEM+",
      },
      {
        label: "Model X Clean 22",
        wheel: "22x9.5 +35",
        tire: "265/35R22",
        note: "Large wheel look with a cleaner, more premium stance.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX CLEAN",
      },
    ],
    flush: [
      {
        label: "Model X Flush Staggered",
        wheel: "22x9.5 +30 / 22x10.5 +32",
        tire: "265/35R22 / 285/35R22",
        note: "Strong flush stance for the larger Model X platform.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX FLUSH",
      },
      {
        label: "Model X Plaid Flush",
        wheel: "22x10 +30 / 22x11 +35",
        tire: "275/35R22 / 305/30R22",
        note: "Premium planted look for a heavy performance SUV.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX PLAID",
      },
    ],
    aggressive: [
      {
        label: "Model X Aggressive Daily",
        wheel: "22x10 +28 / 22x11 +30",
        tire: "275/35R22 / 305/30R22",
        note: "Bigger visual impact with tighter clearances.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX AGGRO",
      },
      {
        label: "Model X Plaid Wide",
        wheel: "22x10.5 +28 / 22x11.5 +30",
        tire: "285/35R22 / 315/30R22",
        note: "Aggressive Plaid X setup with serious presence.",
        sourceName: "View reference gallery",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery?make=Tesla&model=X",
        placeholder: "MX WIDE",
      },
    ],
  },
};

export default function FitmentGallery({
  model,
  trim,
  style,
}: {
  model: ModelKey;
  trim: string;
  style: StyleKey;
}) {
  const cards = examples[model]?.[style] ?? [];

  return (
    <section className="mt-8 rounded-3xl border border-white/10 bg-white/[0.03] p-6">
      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="text-sm uppercase tracking-wide text-white/40">
            Visual Fitment Examples
          </p>
          <h3 className="mt-2 text-2xl font-bold">See the stance before you commit</h3>
          <p className="mt-2 max-w-2xl text-sm leading-6 text-white/55">
            Model-specific example references for {model} {trim}. Photos are linked out
            for now to avoid hosting unapproved imagery.
          </p>
        </div>

        <div className="rounded-full border border-white/10 bg-black/30 px-4 py-2 text-sm text-white/55">
          Tesla Gallery v1
        </div>
      </div>

      <div className="mt-6 grid gap-4 md:grid-cols-2">
        {cards.map((card) => (
          <article
            key={`${model}-${style}-${card.label}`}
            className="overflow-hidden rounded-3xl border border-white/10 bg-black/30"
          >
            <div className="flex h-44 items-center justify-center bg-white/[0.04]">
              <div className="text-center">
                <p className="text-xs uppercase tracking-[0.35em] text-white/30">
                  Visual Reference
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
                  <h4 className="mt-1 text-lg font-semibold">{model}</h4>
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

              <a
                href={card.sourceUrl}
                target="_blank"
                rel="noreferrer"
                className="mt-5 inline-flex rounded-2xl border border-white/15 px-4 py-2 text-sm font-semibold text-white transition hover:border-white/30 hover:bg-white/5"
              >
                View Full Setup →
              </a>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
