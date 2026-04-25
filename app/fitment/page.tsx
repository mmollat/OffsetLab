"use client";

import { useEffect, useMemo, useState } from "react";
import GalleryCard from "../components/GalleryCard";
import { supabase } from "../lib/supabase";
import { galleryExamples } from "../data/gallery";
import {
  getDefaultModelForMake,
  getModelsForMake,
  getTrims,
  makes,
  MakeKey,
  ModelKey,
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
  const [configuration, setConfiguration] = useState<ConfigurationKey>("staggered");
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

  // 🔥 Load Supabase builds (exact match)
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

  // 🔥 SOURCE PRIORITY
  const sourceRank: Record<string, number> = {
    official: 1,
    wheelBrand: 2,
    community: 3,
  };

  const configurationTag =
    configuration === "square" ? "Square" : "Staggered";

  // 🔥 FIXED: FILTER REFERENCE BUILDS CORRECTLY
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

  // 🔥 FILTER COMMUNITY BUILDS
  const communityBuilds = approvedBuilds.filter((build) => {
    return (
      build.tags?.includes(safeModel) ||
      build.label.toLowerCase().includes(safeModel.toLowerCase())
    );
  });

  const rawBuilds = [...referenceBuilds, ...communityBuilds];

  const builds = [...rawBuilds].sort(
    (a, b) =>
      (sourceRank[a.sourceType || "community"] ?? 99) -
      (sourceRank[b.sourceType || "community"] ?? 99)
  );

  return (
    <main className="p-6">
      <div className="grid gap-6">
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
    </main>
  );
}
