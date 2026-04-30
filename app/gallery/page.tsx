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

  // ✅ ALPHABETICAL MAKES
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

  // ✅ ALPHABETICAL MODELS (USING DISPLAY NAME)
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
            imageStatus: "verified",
            sourceType: "community",
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

  const referenceBuilds = useMemo<GalleryBuild[]>(() => {
    if (!safeModel) return [];

    const modelBuilds = galleryExamples[safeModel];
    if (!modelBuilds) return [];

    return (Object.keys(modelBuilds) as StyleKey[]).flatMap((style) =>
      modelBuilds[style]
        .filter((b) => b.imageStatus === "verified" && Boolean(b.imageUrl))
.map((b): GalleryBuild => ({
  label: b.label,
  imageUrl: b.imageUrl,
  imageStatus: "verified",
  sourceType: b.sourceType ?? "community",
  sourceName: b.sourceName,
  sourceUrl: b.sourceUrl,
  wheel: b.wheel,
  tire: b.tire,
  suspension: b.suspension,
  note: b.note,
  verificationNote: b.verificationNote,
  tags: b.tags,
  match: b.match,
  model: safeModel,
  style,
}))
    );
  }, [safeModel]);

  const builds = [...submittedBuilds, ...referenceBuilds];

  if (vehicleModels.length === 0) {
    return <div className="text-white">Loading gallery data...</div>;
  }

  return (
    <main className="min-h-screen bg-[#050609] px-5 py-8">
      <div className="mx-auto max-w-7xl">

        {/* MAKES */}
        <div className="flex flex-wrap gap-3">
          {activeMakes.map((item) => (
            <button
              key={item.label}
              onClick={() => {
                setMake(item.label);
                const nextModel = vehicleModels.find(
                  (v) => v.make === item.label
                )?.model as ModelKey;
                setModel(nextModel);
              }}
              className={`px-4 py-2 rounded-xl ${
                make === item.label ? "bg-red-500" : "bg-black/30"
              }`}
            >
              {item.label}
            </button>
          ))}
        </div>

        {/* MODELS */}
        <div className="mt-5 flex flex-wrap gap-3">
          {availableModels.map((item) => {
            const modelObj = vehicleModels.find(
              (v) => v.make === make && v.model === item
            );

            return (
              <button
                key={item}
                onClick={() => setModel(item)}
                className={`px-4 py-2 rounded-xl ${
                  model === item ? "bg-white/20" : "bg-black/30"
                }`}
              >
                {modelObj?.display_name ?? item}
              </button>
            );
          })}
        </div>

        {/* BUILDS */}
        <div className="mt-10 grid gap-6 md:grid-cols-3">
          {builds.map((build, i) => (
            <div key={i} className="bg-black/30 p-4 rounded-xl text-white">
              <img src={build.imageUrl} className="rounded-lg mb-3" />
              <p>{build.label}</p>
            </div>
          ))}
        </div>
      </div>
    </main>
  );
}
