"use client";

import { useEffect, useMemo, useState } from "react";
import { galleryExamples } from "../data/gallery";
import { supabase } from "../lib/supabase";
import {
  getDefaultModelForMake,
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

type GalleryBuild = {
  label: string;
  imageUrl: string;
  imageStatus: "verified";
  sourceType: "official" | "wheelBrand" | "community";
  sourceName: string;
  sourceUrl?: string;
  wheel: string;
  tire: string;
  suspension?: string;
  note?: string;
  verificationNote?: string;
  tags: string[];
  match: string;
  model: ModelKey | string;
  style: StyleKey | string;
};

function sourceBadge(build: GalleryBuild) {
  if (build.sourceType === "community") return "Community Build";
  if (build.sourceType === "wheelBrand") return "Brand Reference";
  return "Reference Build";
}

function sourceBadgeClass(build: GalleryBuild) {
  if (build.sourceType === "community") {
    return "border-emerald-400/40 bg-emerald-400/10 text-emerald-300";
  }

  if (build.sourceType === "wheelBrand") {
    return "border-blue-400/40 bg-blue-400/10 text-blue-300";
  }

  return "border-white/15 bg-white/[0.06] text-white/65";
}

export default function GalleryPage() {
  const [make, setMake] = useState<MakeKey>("Tesla");
  const [model, setModel] = useState<ModelKey>("Model 3");
  const [submittedBuilds, setSubmittedBuilds] = useState<GalleryBuild[]>([]);

  const availableModels = useMemo(() => getModelsForMake(make), [make]);
  const safeModel = availableModels.includes(model)
    ? model
    : getDefaultModelForMake(make);

  useEffect(() => {
    let cancelled = false;

    async function loadSubmittedBuilds() {
      const { data, error } = await supabase
        .from("build_submissions")
        .select(
          "id, make, model, trim, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, image_url, notes, instagram_handle"
        )
        .eq("status", "approved")
        .eq("model", safeModel);

      if (cancelled) return;

      if (error || !data) {
        setSubmittedBuilds([]);
        return;
      }

      const mapped = data
        .filter((row) => row.image_url)
        .map((row) => {
          const styleRaw = String(row.fitment_style || "").toLowerCase();

          const style: StyleKey = styleRaw.includes("oem")
            ? "oemplus"
            : styleRaw.includes("flush")
              ? "flush"
              : "aggressive";

          const rowModel = String(row.model || safeModel);

          return {
            label: `${rowModel} ${String(row.trim || "")}`.trim(),
            imageUrl: String(row.image_url || ""),
            imageStatus: "verified" as const,
            sourceType: "community" as const,
            sourceName: row.instagram_handle
              ? `@${String(row.instagram_handle).replace(/^@/, "")}`
              : "Offset Lab Community",
            sourceUrl: row.instagram_handle
              ? `https://instagram.com/${String(row.instagram_handle).replace(/^@/, "")}`
              : "#",
            wheel: `${String(row.front_wheel || "")}${
              row.rear_wheel && row.rear_wheel !== row.front_wheel
                ? ` / ${String(row.rear_wheel)}`
                : ""
            }`,
            tire: `${String(row.front_tire || "")}${
              row.rear_tire && row.rear_tire !== row.front_tire
                ? ` / ${String(row.rear_tire)}`
                : ""
            }`,
            suspension: "User submitted build",
            note: String(row.notes || "Approved community build"),
            verificationNote: "Approved community-submitted build.",
            tags: [rowModel, String(row.trim || ""), "Community"],
            match: "Verified Community Build",
            model: rowModel,
            style,
          };
        });

      setSubmittedBuilds(mapped);
    }

    loadSubmittedBuilds();

    return () => {
      cancelled = true;
    };
  }, [safeModel]);

  const referenceBuilds = useMemo(() => {
    const modelBuilds = galleryExamples[safeModel];

    if (!modelBuilds) return [];

    return (Object.keys(modelBuilds) as StyleKey[]).flatMap((style) =>
      modelBuilds[style]
        .filter((build) => build.imageStatus === "verified" && build.imageUrl)
        .map((build) => ({
          ...build,
          model: safeModel,
          style,
        }))
    );
  }, [safeModel]);

  const builds = useMemo(() => {
    return [...submittedBuilds, ...referenceBuilds];
  }, [submittedBuilds, referenceBuilds]);

  return (
    <main className="min-h-[calc(100vh-73px)] bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl">
        <div className="rounded-[2rem] border border-white/10 bg-white/[0.03] p-6 md:p-8">
          <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">
            Real Build References
          </p>

          <div className="mt-3 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
            <div>
              <h1 className="text-3xl font-bold md:text-5xl">Gallery</h1>
              <p className="mt-3 max-w-2xl text-white/50">
                Browse verified reference builds and approved community submissions by vehicle.
              </p>
            </div>

            <div className="rounded-2xl border border-white/10 bg-black/30 px-5 py-4">
              <p className="text-xs uppercase tracking-wide text-white/35">
                Showing
              </p>
              <p className="mt-1 text-2xl font-bold text-white">
                {builds.length}
              </p>
            </div>
          </div>

          <div className="mt-8 flex flex-wrap gap-3">
            {makes
              .filter((item) => item.active)
              .map((item) => (
                <button
                  key={item.label}
                  onClick={() => {
                    setMake(item.label);
                    setModel(getDefaultModelForMake(item.label));
                  }}
                  className={`rounded-2xl border px-5 py-3 font-semibold transition ${
                    make === item.label
                      ? "border-emerald-400/60 bg-emerald-400/15 text-emerald-200"
                      : "border-white/10 bg-black/30 text-white/70 hover:border-white/25"
                  }`}
                >
                  {item.label}
                </button>
              ))}
          </div>

          <div className="mt-5 flex flex-wrap gap-3">
            {availableModels.map((item) => (
              <button
                key={item}
                onClick={() => setModel(item)}
                className={`rounded-2xl border px-5 py-3 text-sm font-semibold transition ${
                  safeModel === item
                    ? "border-white/40 bg-white/10 text-white"
                    : "border-white/10 bg-black/30 text-white/60 hover:border-white/25"
                }`}
              >
                {item}
              </button>
            ))}
          </div>
        </div>

        {builds.length === 0 ? (
          <div className="mt-10 rounded-3xl border border-white/10 bg-white/[0.03] p-8 text-center">
            <p className="text-xl font-bold">No verified gallery images yet for {safeModel}.</p>
            <p className="mt-2 text-white/50">
              Add approved submissions or reference photos to make this gallery feel complete.
            </p>
          </div>
        ) : (
          <div className="mt-10 grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
            {builds.map((build, index) => (
              <article
                key={`${build.model}-${build.style}-${build.label}-${index}`}
                className="group overflow-hidden rounded-[2rem] border border-white/10 bg-white/[0.035] shadow-2xl shadow-black/20 transition hover:border-emerald-400/30 hover:bg-white/[0.055]"
              >
                <div className="relative aspect-[4/3] overflow-hidden bg-black">
                  <img
                    src={build.imageUrl}
                    alt={build.label}
                    className="h-full w-full object-cover transition duration-700 group-hover:scale-105"
                  />

                  <div className="absolute inset-x-0 bottom-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent p-4">
                    <div className="flex flex-wrap gap-2">
                      <span className={`rounded-full border px-3 py-1 text-xs font-semibold ${sourceBadgeClass(build)}`}>
                        {sourceBadge(build)}
                      </span>

                      <span className="rounded-full border border-white/15 bg-black/50 px-3 py-1 text-xs text-white/70">
                        {styleLabels[build.style as StyleKey] ?? build.style}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="p-5">
                  <p className="text-sm text-emerald-300">{build.model}</p>

                  <h2 className="mt-2 text-xl font-bold leading-tight">
                    {build.label}
                  </h2>

                  <div className="mt-5 grid gap-3">
                    <SpecLine label="Wheel" value={build.wheel} />
                    <SpecLine label="Tire" value={build.tire} />
                    <SpecLine label="Source" value={build.sourceName} />
                  </div>

                  {build.note ? (
                    <p className="mt-4 line-clamp-2 text-sm leading-6 text-white/45">
                      {build.note}
                    </p>
                  ) : null}

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

function SpecLine({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-black/25 p-3">
      <p className="text-xs uppercase tracking-wide text-white/35">{label}</p>
      <p className="mt-1 text-sm font-semibold text-white/80">{value || "—"}</p>
    </div>
  );
}
