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
      <div className="mx-auto max-w-6xl">
        <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">
          Real Build References
        </p>

        <h1 className="mt-2 text-3xl font-bold md:text-4xl">Gallery</h1>

        <p className="mt-3 max-w-2xl text-white/50">
          Browse verified reference builds and approved community submissions by vehicle.
        </p>

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
                    ? "border-emerald-400/60 bg-emerald-400/10 text-emerald-200"
                    : "border-white/10 bg-white/[0.03] text-white/70 hover:border-white/25"
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
                  : "border-white/10 bg-white/[0.03] text-white/60 hover:border-white/25"
              }`}
            >
              {item}
            </button>
          ))}
        </div>

        {builds.length === 0 ? (
          <div className="mt-10 rounded-3xl border border-white/10 bg-white/[0.03] p-8 text-white/55">
            No verified gallery images yet for {safeModel}.
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
                    <p className="text-sm text-emerald-300">{build.model}</p>

                    <span className="rounded-full border border-white/10 px-3 py-1 text-xs text-white/50">
                      {styleLabels[build.style as StyleKey] ?? build.style}
                    </span>
                  </div>

                  <h2 className="mt-3 text-xl font-bold">{build.label}</h2>

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
