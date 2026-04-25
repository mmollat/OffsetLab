"use client";

import { useEffect, useMemo, useState } from "react";
import GalleryCard from "../components/GalleryCard";
import TrustStrip from "../components/TrustStrip";
import SubmitBuildModal from "../components/SubmitBuildModal";
import { supabase } from "../lib/supabase";
import { galleryExamples } from "../data/gallery";
import {
  getDefaultModelForMake,
  getModelsForMake,
  getTrimData,
  getTrims,
  makes,
  MakeKey,
  ModelKey,
  modelSlug,
  normalizeMake,
  normalizeModel,
  normalizeStyle,
  StyleKey,
} from "../data/fitment";

type ConfigurationKey = "staggered" | "square";
type DrivingGoalKey = "street" | "track";

export default function FitmentPage() {
  const [make, setMake] = useState<MakeKey>("Tesla");
  const [model, setModel] = useState<ModelKey>("Model 3");
  const [trim, setTrim] = useState("");
  const [style, setStyle] = useState<StyleKey>("aggressive");
  const [goal, setGoal] = useState<DrivingGoalKey>("street");
  const [configuration, setConfiguration] =
    useState<ConfigurationKey>("staggered");
  const [approvedBuilds, setApprovedBuilds] = useState<any[]>([]);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    setMake(normalizeMake(params.get("make")));
    setModel(normalizeModel(params.get("model"), make));
    setStyle(normalizeStyle(params.get("style")));
  }, []);

  const availableModels = useMemo(() => getModelsForMake(make), [make]);
  const safeModel = availableModels.includes(model)
    ? model
    : getDefaultModelForMake(make);

  const trims = useMemo(() => getTrims(safeModel), [safeModel]);
  const safeTrim = trims.includes(trim) ? trim : trims[0];
  const trimData = useMemo(
    () => getTrimData(safeModel, safeTrim),
    [safeModel, safeTrim]
  );

  // 🔥 LOAD SUPABASE BUILDS
  useEffect(() => {
    async function loadApprovedBuilds() {
      const { data } = await supabase
        .from("build_submissions")
        .select("*")
        .eq("status", "approved")
        .eq("model", safeModel)
        .eq("trim", safeTrim);

      if (!data) return;

      const normalize = (v: string) =>
        v?.toLowerCase().replace("oem+", "oemplus").trim();

      const expected =
        goal === "track"
          ? `${style} track ${configuration}`
          : configuration === "square"
          ? `${style} square`
          : style;

      const filtered = data.filter(
        (row) => normalize(row.fitment_style) === normalize(expected)
      );

      const mapped = filtered.map((row) => ({
        label: `${row.model} ${row.trim}`,
        imageUrl: row.image_url,
        imageStatus: "verified",
        sourceType: "community",
        sourceName: row.instagram_handle
          ? `@${row.instagram_handle}`
          : "Community",
        sourceUrl: "#",
        wheel: row.front_wheel,
        tire: row.front_tire,
        suspension: "User build",
        note: row.notes || "",
        verificationNote: "Community verified",
        tags: [row.model],
        match: "Verified Spec Match",
      }));

      setApprovedBuilds(mapped);
    }

    loadApprovedBuilds();
  }, [safeModel, safeTrim, style, goal, configuration]);

  // 🔥 FIXED IMAGE LOGIC
  const sourceRank: Record<string, number> = {
    official: 1,
    wheelBrand: 2,
    community: 3,
  };

  const configurationTag =
    configuration === "square" ? "Square" : "Staggered";

  const referenceBuilds = (galleryExamples[safeModel]?.[style] ?? []).filter(
    (build) => {
      const matchesModel =
        build.tags?.includes(safeModel) ||
        build.label.toLowerCase().includes(safeModel.toLowerCase());

      const matchesConfig =
        build.tags?.includes(configurationTag) ||
        build.match === "Pending Verified Photo";

      return matchesModel && matchesConfig;
    }
  );

  const communityBuilds = approvedBuilds;

  const rawBuilds = [...referenceBuilds, ...communityBuilds];

  const builds = [...rawBuilds].sort(
    (a, b) =>
      (sourceRank[a.sourceType || "community"] ?? 99) -
      (sourceRank[b.sourceType || "community"] ?? 99)
  );

  return (
    <main className="min-h-screen bg-black text-white p-6">
      <div className="grid gap-6 lg:grid-cols-3">
        <div className="space-y-4">
          <select
            value={make}
            onChange={(e) => setMake(e.target.value as MakeKey)}
          >
            {makes.map((m) => (
              <option key={m.label}>{m.label}</option>
            ))}
          </select>

          <select
            value={safeModel}
            onChange={(e) => setModel(e.target.value as ModelKey)}
          >
            {availableModels.map((m) => (
              <option key={m}>{m}</option>
            ))}
          </select>

          <select value={safeTrim} onChange={(e) => setTrim(e.target.value)}>
            {trims.map((t) => (
              <option key={t}>{t}</option>
            ))}
          </select>

          <select value={style} onChange={(e) => setStyle(e.target.value as StyleKey)}>
            <option value="oemplus">OEM+</option>
            <option value="flush">Flush</option>
            <option value="aggressive">Aggressive</option>
          </select>

          <select
            value={configuration}
            onChange={(e) =>
              setConfiguration(e.target.value as ConfigurationKey)
            }
          >
            <option value="staggered">Staggered</option>
            <option value="square">Square</option>
          </select>
        </div>

        <div className="lg:col-span-2 grid gap-6">
          {builds.length > 0 ? (
            builds.map((build) => (
              <GalleryCard key={build.label} build={build} />
            ))
          ) : (
            <div className="text-center text-white/50">
              No verified build yet for this setup.
            </div>
          )}
        </div>
      </div>
    </main>
  );
}
