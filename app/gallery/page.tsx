"use client";

import { useMemo, useState } from "react";
import { galleryExamples } from "../data/gallery";
import {
  getModelsForMake,
  makes,
  MakeKey,
  ModelKey,
  StyleKey,
} from "../data/fitment";

const styleLabels: Record<StyleKey, string> = {
  oemplus: "OEM+",
  flush: "Flush",
  aggressive: "Aggressive",
};

export default function GalleryPage() {
  const [make, setMake] = useState<MakeKey>("Tesla");

  const builds = useMemo(() => {
    const models = getModelsForMake(make);

    return models.flatMap((model) => {
      const modelBuilds = galleryExamples[model as ModelKey];

      if (!modelBuilds) return [];

      return (Object.keys(modelBuilds) as StyleKey[]).flatMap((style) =>
        modelBuilds[style]
          .filter((build) => build.imageStatus === "verified" && build.imageUrl)
          .map((build) => ({
            ...build,
            model,
            style,
          }))
      );
    });
  }, [make]);

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-6xl">
        <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">
          Real Build References
        </p>

        <h1 className="mt-2 text-3xl font-bold md:text-4xl">
          Gallery
        </h1>

        <p className="mt-3 max-w-2xl text-white/50">
          Browse verified fitment references by make.
        </p>

        <div className="mt-8 flex flex-wrap gap-3">
          {makes
            .filter((item) => item.active)
            .map((item) => (
              <button
                key={item.label}
                onClick={() => setMake(item.label)}
                className={`rounded-2xl border px-5 py-3 font-semibold transition ${
                  make === item.label
                    ? "border-emerald-400/60 bg-emerald-400/10 text-emerald-200"
                    : "border-white/10 bg-white/[0.03] text-white/70 hover:border-white/25"
                }`}
              >
                {item.label}
              </button>
            ))}
        </div>

        {builds.length === 0 ? (
          <div className="mt-10 rounded-3xl border border-white/10 bg-white/[0.03] p-8 text-white/55">
            No verified gallery images yet for {make}.
          </div>
        ) : (
          <div className="mt-10 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {builds.map((build, index) => (
              <article
                key={`${build.model}-${build.style}-${build.label}-${index}`}
                className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.03]"
              >
                <div className="aspect-[4/3] overflow-hidden bg-black">
                  <img
                    src={build.imageUrl}
                    alt={build.label}
                    className="h-full w-full object-cover transition duration-500 hover:scale-105"
                  />
                </div>

                <div className="p-5">
                  <div className="flex items-center justify-between gap-3">
                    <p className="text-sm text-emerald-300">
                      {build.model}
                    </p>
                    <span className="rounded-full border border-white/10 px-3 py-1 text-xs text-white/50">
                      {styleLabels[build.style]}
                    </span>
                  </div>

                  <h2 className="mt-3 text-xl font-bold">
                    {build.label}
                  </h2>

                  <div className="mt-4 space-y-2 text-sm text-white/60">
                    <p>
                      <span className="text-white/35">Wheel:</span>{" "}
                      {build.wheel}
                    </p>
                    <p>
                      <span className="text-white/35">Tire:</span>{" "}
                      {build.tire}
                    </p>
                    <p>
                      <span className="text-white/35">Source:</span>{" "}
                      {build.sourceName}
                    </p>
                  </div>

                  <div className="mt-5 flex flex-wrap gap-2">
                    <span className="rounded-full bg-emerald-400/10 px-3 py-1 text-xs text-emerald-300">
                      {build.match}
                    </span>

                    {build.tags.slice(0, 3).map((tag) => (
                      <span
                        key={tag}
                        className="rounded-full bg-white/[0.06] px-3 py-1 text-xs text-white/45"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                </div>
              </article>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
