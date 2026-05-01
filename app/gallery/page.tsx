"use client";

import { useEffect, useMemo, useState } from "react";
import { galleryExamples } from "../data/gallery";
import { supabase } from "../lib/supabase";
import { MakeKey, ModelKey, StyleKey } from "../data/fitment";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";

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
    return "border-red-500/40 bg-red-500/10 text-red-400";
  }

  if (build.sourceType === "wheelBrand") {
    return "border-blue-400/40 bg-blue-400/10 text-blue-300";
  }

  return "border-white/15 bg-white/[0.06] text-white/65";
}

function normalizeStyle(style: string): StyleKey {
  const value = style.toLowerCase();

  if (value.includes("oem")) return "oemplus";
  if (value.includes("flush")) return "flush";
  return "aggressive";
}

export default function GalleryPage() {
  const [make, setMake] = useState<MakeKey | null>(null);
  const [model, setModel] = useState<ModelKey | null>(null);
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [submittedBuilds, setSubmittedBuilds] = useState<GalleryBuild[]>([]);

  useEffect(() => {
    let cancelled = false;

    async function loadVehicleModels() {
      const data = await getVehicleModels();

      if (cancelled) return;

      setVehicleModels(data);

      const firstVehicle = data[0];

      if (firstVehicle) {
        setMake(firstVehicle.make as MakeKey);
        setModel(firstVehicle.model as ModelKey);
      }
    }

    loadVehicleModels();

    return () => {
      cancelled = true;
    };
  }, []);

  const activeMakes = useMemo(() => {
    const uniqueMakes = Array.from(
      new Map(
        vehicleModels.map((item) => [
          item.make,
          {
            label: item.make as MakeKey,
            active: item.active,
          },
        ])
      ).values()
    );

    return uniqueMakes.sort((a, b) =>
      String(a.label).localeCompare(String(b.label))
    );
  }, [vehicleModels]);

  const availableModels = useMemo(() => {
    if (!make) return [];

    return vehicleModels
      .filter((item) => item.make === make && item.active)
      .sort((a, b) =>
        String(a.display_name ?? a.model).localeCompare(
          String(b.display_name ?? b.model)
        )
      )
      .map((item) => item.model as ModelKey);
  }, [make, vehicleModels]);

  const safeModel =
    model && availableModels.includes(model)
      ? model
      : availableModels.length > 0
      ? availableModels[0]
      : null;

  useEffect(() => {
    if (!safeModel) return;

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

      const mapped: GalleryBuild[] = data
        .filter((row) => row.image_url)
        .map((row) => {
          const style = normalizeStyle(String(row.fitment_style || ""));
          const rowModel = String(row.model || safeModel);
          const trim = String(row.trim || "").trim();

          return {
            label: `${rowModel}${trim ? ` ${trim}` : ""}`,
            imageUrl: String(row.image_url || ""),
            imageStatus: "verified",
            sourceType: "community",
            sourceName: row.instagram_handle
              ? `@${String(row.instagram_handle).replace(/^@/, "")}`
              : "Offset Lab Community",
            sourceUrl: row.instagram_handle
              ? `https://instagram.com/${String(row.instagram_handle).replace(/^@/, "")}`
              : undefined,
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
            tags: [rowModel, trim, "Community"].filter(Boolean),
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

  const referenceBuilds = useMemo<GalleryBuild[]>(() => {
    if (!safeModel) return [];

    const modelBuilds = galleryExamples[safeModel];
    if (!modelBuilds) return [];

    return (Object.keys(modelBuilds) as StyleKey[]).flatMap((style) =>
      modelBuilds[style]
        .filter((build) => build.imageStatus === "verified" && Boolean(build.imageUrl))
        .map(
          (build): GalleryBuild => ({
            label: build.label,
            imageUrl: build.imageUrl,
            imageStatus: "verified",
            sourceType: build.sourceType ?? "community",
            sourceName: build.sourceName,
            sourceUrl: build.sourceUrl,
            wheel: build.wheel,
            tire: build.tire,
            suspension: build.suspension,
            note: build.note,
            verificationNote: build.verificationNote,
            tags: build.tags,
            match: build.match,
            model: safeModel,
            style,
          })
        )
    );
  }, [safeModel]);

  const builds = submittedBuilds;

  if (vehicleModels.length === 0) {
    return (
      <main className="min-h-screen bg-[#050609] px-5 py-8 text-white">
        Loading gallery data...
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8">
          <p className="text-xs font-semibold uppercase tracking-[0.35em] text-red-400/70">
            Offset Lab Gallery
          </p>
          <h1 className="mt-3 text-4xl font-black tracking-tight text-white md:text-6xl">
            Verified Fitment Builds
          </h1>
          <p className="mt-4 max-w-2xl text-sm leading-6 text-white/55">
            Browse approved community submissions and verified reference builds
            by platform, wheel setup, tire sizing, and fitment style.
          </p>
        </div>

        <div className="rounded-3xl border border-white/10 bg-black/25 p-5">
          <p className="mb-4 text-xs font-bold uppercase tracking-[0.25em] text-white/35">
            Select Make
          </p>

          <div className="flex flex-wrap gap-3">
            {activeMakes.map((item) => (
              <button
                key={item.label}
                onClick={() => {
                  setMake(item.label);

                  const nextModel = vehicleModels
                    .filter((vehicle) => vehicle.make === item.label && vehicle.active)
                    .sort((a, b) =>
                      String(a.display_name ?? a.model).localeCompare(
                        String(b.display_name ?? b.model)
                      )
                    )[0]?.model as ModelKey | undefined;

                  setModel(nextModel ?? null);
                }}
                className={`rounded-xl px-4 py-2 text-sm font-semibold transition ${
                  make === item.label
                    ? "bg-red-500 text-white"
                    : "bg-black/35 text-white/70 hover:bg-white/10 hover:text-white"
                }`}
              >
                {item.label}
              </button>
            ))}
          </div>

          <p className="mb-4 mt-7 text-xs font-bold uppercase tracking-[0.25em] text-white/35">
            Select Model
          </p>

          <div className="flex flex-wrap gap-3">
            {availableModels.map((item) => {
              const modelObj = vehicleModels.find(
                (vehicle) => vehicle.make === make && vehicle.model === item
              );

              const selected = safeModel === item;

              return (
                <button
                  key={item}
                  onClick={() => setModel(item)}
                  className={`rounded-xl px-4 py-2 text-sm font-semibold transition ${
                    selected
                      ? "bg-white/20 text-white"
                      : "bg-black/35 text-white/70 hover:bg-white/10 hover:text-white"
                  }`}
                >
                  {modelObj?.display_name ?? item}
                </button>
              );
            })}
          </div>
        </div>

        <div className="mt-10 grid gap-6 md:grid-cols-2 xl:grid-cols-3">
          {builds.map((build, index) => {
            const normalizedStyle = normalizeStyle(String(build.style || ""));
            const styleLabel = styleLabels[normalizedStyle];

            return (
              <article
                key={`${build.label}-${index}`}
                className="overflow-hidden rounded-3xl border border-white/10 bg-black/35 text-white shadow-2xl shadow-black/30"
              >
                <div className="aspect-[4/3] overflow-hidden bg-white/[0.03]">
                  <img
                    src={build.imageUrl}
                    alt={build.label}
                    className="h-full w-full object-cover transition duration-500 hover:scale-[1.03]"
                    loading="lazy"
                  />
                </div>

                <div className="p-5">
                  <div className="mb-3 flex flex-wrap items-center gap-2">
                    <span
                      className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase tracking-[0.18em] ${sourceBadgeClass(
                        build
                      )}`}
                    >
                      {sourceBadge(build)}
                    </span>

                    <span className="rounded-full border border-white/10 bg-white/[0.04] px-3 py-1 text-[11px] font-bold uppercase tracking-[0.18em] text-white/55">
                      {styleLabel}
                    </span>
                  </div>

                  <h2 className="text-xl font-black tracking-tight">
                    {build.label}
                  </h2>

                  <div className="mt-4 space-y-3 text-sm">
                    <div>
                      <p className="text-[11px] font-bold uppercase tracking-[0.22em] text-white/35">
                        Wheels
                      </p>
                      <p className="mt-1 text-white/85">{build.wheel || "Not provided"}</p>
                    </div>

                    <div>
                      <p className="text-[11px] font-bold uppercase tracking-[0.22em] text-white/35">
                        Tires
                      </p>
                      <p className="mt-1 text-white/85">{build.tire || "Not provided"}</p>
                    </div>

                    {build.suspension ? (
                      <div>
                        <p className="text-[11px] font-bold uppercase tracking-[0.22em] text-white/35">
                          Suspension
                        </p>
                        <p className="mt-1 text-white/75">{build.suspension}</p>
                      </div>
                    ) : null}

                    {build.note ? (
                      <p className="rounded-2xl border border-white/10 bg-white/[0.03] p-3 text-white/60">
                        {build.note}
                      </p>
                    ) : null}
                  </div>

                  <div className="mt-5 flex flex-wrap gap-2">
                    {build.tags.slice(0, 4).map((tag) => (
                      <span
                        key={tag}
                        className="rounded-full bg-white/[0.06] px-3 py-1 text-xs text-white/45"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>

                  <div className="mt-5 flex items-center justify-between border-t border-white/10 pt-4 text-xs text-white/45">
                    {build.sourceUrl ? (
                      <a
                        href={build.sourceUrl}
                        target="_blank"
                        rel="noreferrer"
                        className="hover:text-white"
                      >
                        {build.sourceName}
                      </a>
                    ) : (
                      <span>{build.sourceName}</span>
                    )}

                    <span>{build.match}</span>
                  </div>
                </div>
              </article>
            );
          })}
        </div>

        {builds.length === 0 ? (
          <div className="mt-10 rounded-3xl border border-white/10 bg-black/30 p-8 text-center text-white/55">
            No approved gallery builds found for this model yet.
          </div>
        ) : null}
      </div>
    </main>
  );
}
