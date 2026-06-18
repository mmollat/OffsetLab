"use client";

import { useEffect, useMemo, useState } from "react";
import { createClient } from "@supabase/supabase-js";
import { ModelKey, modelSlug } from "../data/fitment";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { getVehicleTrims, VehicleTrim } from "../lib/getVehicleTrims";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

type TorqueMake = {
  id: string;
  name: string;
  slug: string;
};

type TorqueModel = {
  id: string;
  make_id: string;
  name: string;
  slug: string;
};

type TorqueGeneration = {
  id: string;
  model_id: string;
  name: string;
  slug: string;
  start_year?: number;
  end_year?: number | null;
};

type Category = {
  id: string;
  name: string;
  slug: string;
  sort_order?: number;
};

type Spec = {
  id: string;
  component: string;
  fastener: string;
  torque_ft_lb: number | null;
  torque_nm: number | null;
  angle_degrees: number | null;
  notes: string | null;
  warning: string | null;
  source_status: "verified" | "community" | "needs_review";
  source_name: string | null;
  source_url: string | null;
  source_note: string | null;
  source_checked_at: string | null;
};

function sourceLabel(status: Spec["source_status"]) {
  if (status === "verified") return "Verified";
  if (status === "community") return "Community";
  return "Needs Review";
}

function sourceClass(status: Spec["source_status"]) {
  if (status === "verified") {
    return "border-emerald-500/30 bg-emerald-500/10 text-emerald-300";
  }

  if (status === "community") {
    return "border-blue-500/30 bg-blue-500/10 text-blue-300";
  }

  return "border-yellow-500/30 bg-yellow-500/10 text-yellow-300";
}

function displaySourceStatus(spec: Spec): Spec["source_status"] {
  if (spec.source_status === "verified" && !spec.source_name?.trim()) {
    return "needs_review";
  }

  return spec.source_status;
}

function sourceDescription(status: Spec["source_status"]) {
  if (status === "verified") {
    return "Checked against an identified manufacturer or service source.";
  }

  if (status === "community") {
    return "Community-supplied information that has not received full source verification.";
  }

  return "A working reference that must be confirmed before use.";
}

function formatCheckedDate(value: string | null) {
  if (!value) return null;

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;

  return new Intl.DateTimeFormat("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  }).format(date);
}

function isSafeSourceUrl(value: string | null) {
  if (!value) return false;

  try {
    const url = new URL(value);
    return url.protocol === "https:" || url.protocol === "http:";
  } catch {
    return false;
  }
}

function normalizeLookup(value: string | null | undefined) {
  return modelSlug(value ?? "");
}

function splitFitmentVehicle(vehicle: VehicleModel) {
  const label = vehicle.display_name ?? vehicle.model;
  const [generationLabel, modelLabel] = label.includes(" - ")
    ? label.split(" - ", 2)
    : ["", label];

  return {
    label,
    generationLabel: generationLabel.trim(),
    modelLabel: modelLabel.trim(),
    modelKey: vehicle.model,
  };
}

function resolveTorqueMatch(
  vehicle: VehicleModel,
  torqueMakes: TorqueMake[],
  torqueModels: TorqueModel[],
  torqueGenerations: TorqueGeneration[]
) {
  const parts = splitFitmentVehicle(vehicle);
  const torqueMake = torqueMakes.find(
    (make) => normalizeLookup(make.name) === normalizeLookup(vehicle.make)
  );

  if (!torqueMake) return null;

  const modelCandidates = [
    parts.modelLabel,
    parts.modelKey,
    parts.label,
  ].map(normalizeLookup);

  const torqueModel =
    torqueModels.find(
      (model) =>
        model.make_id === torqueMake.id &&
        modelCandidates.includes(normalizeLookup(model.name))
    ) ??
    torqueModels.find(
      (model) =>
        model.make_id === torqueMake.id &&
        modelCandidates.includes(normalizeLookup(model.slug))
    );

  if (!torqueModel) return null;

  const generations = torqueGenerations.filter(
    (generation) => generation.model_id === torqueModel.id
  );
  const generationCandidates = [
    parts.generationLabel,
    parts.generationLabel.replace(/\bgen\b/i, "Generation"),
    parts.modelKey,
    parts.label,
  ]
    .filter(Boolean)
    .map(normalizeLookup);
  const preferredGeneration =
    generations.find((generation) =>
      generationCandidates.includes(normalizeLookup(generation.name))
    ) ??
    generations.find((generation) =>
      generationCandidates.includes(normalizeLookup(generation.slug))
    ) ??
    (generations.length === 1 ? generations[0] : null);

  return {
    torqueMake,
    torqueModel,
    generations,
    preferredGeneration,
  };
}

export default function TorquePage() {
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [vehicleTrims, setVehicleTrims] = useState<VehicleTrim[]>([]);
  const [torqueMakes, setTorqueMakes] = useState<TorqueMake[]>([]);
  const [torqueModels, setTorqueModels] = useState<TorqueModel[]>([]);
  const [torqueGenerations, setTorqueGenerations] = useState<TorqueGeneration[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [specs, setSpecs] = useState<Spec[]>([]);

  const [selectedMake, setSelectedMake] = useState("");
  const [selectedModel, setSelectedModel] = useState("");
  const [selectedTrim, setSelectedTrim] = useState("");
  const [selectedGeneration, setSelectedGeneration] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("");

  const [loadingSpecs, setLoadingSpecs] = useState(false);

  useEffect(() => {
    fetchInitialData();
  }, []);

  useEffect(() => {
    if (selectedGeneration && selectedCategory) {
      fetchSpecs(selectedGeneration, selectedCategory);
    }
  }, [selectedGeneration, selectedCategory]);

  const makes = useMemo(() => {
    return Array.from(new Set(vehicleModels.map((item) => item.make))).sort((a, b) =>
      String(a).localeCompare(String(b))
    );
  }, [vehicleModels]);

  const models = useMemo(() => {
    if (!selectedMake) return [];

    return vehicleModels
      .filter((item) => item.make === selectedMake)
      .sort((a, b) => a.sort_order - b.sort_order);
  }, [selectedMake, vehicleModels]);

  const selectedVehicle = useMemo(() => {
    return (
      vehicleModels.find(
        (vehicle) => vehicle.make === selectedMake && vehicle.model === selectedModel
      ) ?? null
    );
  }, [selectedMake, selectedModel, vehicleModels]);

  const trims = useMemo(() => {
    if (!selectedMake || !selectedModel) return [];

    return vehicleTrims.filter(
      (item) => item.make === selectedMake && item.model === selectedModel
    );
  }, [selectedMake, selectedModel, vehicleTrims]);

  const torqueMatch = useMemo(() => {
    if (!selectedVehicle) return null;
    return resolveTorqueMatch(selectedVehicle, torqueMakes, torqueModels, torqueGenerations);
  }, [selectedVehicle, torqueMakes, torqueModels, torqueGenerations]);

  const selectedMakeName = selectedMake || undefined;
  const selectedModelName = selectedVehicle
    ? selectedVehicle.display_name ?? selectedVehicle.model
    : undefined;
  const selectedTrimName =
    trims.find((trim) => trim.trim === selectedTrim)?.display_name ?? selectedTrim;
  const selectedGenerationName = useMemo(() => {
    return torqueMatch?.generations.find((generation) => generation.id === selectedGeneration)
      ?.name;
  }, [torqueMatch, selectedGeneration]);

  async function fetchInitialData() {
    const [fitmentModels, fitmentTrims, torqueMakesResult, torqueModelsResult, torqueGenerationsResult] =
      await Promise.all([
        getVehicleModels(),
        getVehicleTrims(),
        supabase.from("torque_vehicle_makes").select("*").order("name", { ascending: true }),
        supabase.from("torque_vehicle_models").select("*").order("name", { ascending: true }),
        supabase
          .from("torque_vehicle_generations")
          .select("*")
          .order("start_year", { ascending: true }),
      ]);

    setVehicleModels(fitmentModels);
    setVehicleTrims(fitmentTrims);

    if (torqueMakesResult.error) {
      console.error("Error fetching torque makes:", torqueMakesResult.error);
    } else {
      setTorqueMakes((torqueMakesResult.data || []) as TorqueMake[]);
    }

    if (torqueModelsResult.error) {
      console.error("Error fetching torque models:", torqueModelsResult.error);
    } else {
      setTorqueModels((torqueModelsResult.data || []) as TorqueModel[]);
    }

    if (torqueGenerationsResult.error) {
      console.error("Error fetching torque generations:", torqueGenerationsResult.error);
    } else {
      setTorqueGenerations((torqueGenerationsResult.data || []) as TorqueGeneration[]);
    }

    await fetchCategories();
  }

  async function fetchCategories() {
    const { data, error } = await supabase
      .from("torque_categories")
      .select("*")
      .order("sort_order", { ascending: true });

    if (error) {
      console.error("Error fetching categories:", error);
      return;
    }

    setCategories(data || []);
  }

  async function fetchSpecs(generationId: string, categoryId: string) {
    setLoadingSpecs(true);

    const { data, error } = await supabase
      .from("torque_specs")
      .select("*")
      .eq("generation_id", generationId)
      .eq("category_id", categoryId)
      .order("component", { ascending: true })
      .order("fastener", { ascending: true });

    if (error) {
      console.error("Error fetching specs:", error);
      setSpecs([]);
      setLoadingSpecs(false);
      return;
    }

    setSpecs(data || []);
    setLoadingSpecs(false);
  }

  function handleMakeChange(makeId: string) {
    setSelectedMake(makeId);
    setSelectedModel("");
    setSelectedTrim("");
    setSelectedGeneration("");
    setSelectedCategory("");
    setSpecs([]);
  }

  function handleModelChange(modelId: ModelKey) {
    setSelectedModel(modelId);
    setSelectedTrim("");
    setSelectedGeneration("");
    setSelectedCategory("");
    setSpecs([]);

    const nextTrim =
      vehicleTrims.find(
        (vehicleTrim) =>
          vehicleTrim.make === selectedMake && vehicleTrim.model === modelId
      )?.trim ?? "";

    setSelectedTrim(nextTrim);

    const vehicle = vehicleModels.find(
      (item) => item.make === selectedMake && item.model === modelId
    );
    const match = vehicle
      ? resolveTorqueMatch(vehicle, torqueMakes, torqueModels, torqueGenerations)
      : null;

    setSelectedGeneration(match?.preferredGeneration?.id ?? "");
  }

  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <section className="relative isolate min-h-[680px] overflow-hidden border-b border-white/10">
        <img
          src="/torque-hero.jpg"
          alt=""
          className="absolute inset-0 -z-20 h-full w-full object-cover object-[68%_center]"
        />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(90deg,rgba(3,4,6,0.99)_0%,rgba(3,4,6,0.92)_35%,rgba(3,4,6,0.3)_68%,rgba(3,4,6,0.62)_100%)]" />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(0deg,rgba(5,6,9,1)_0%,transparent_42%,rgba(5,6,9,0.18)_100%)]" />
        <div className="absolute -left-24 top-24 -z-10 h-80 w-80 rounded-full bg-red-500/10 blur-[120px]" />

        <div className="mx-auto flex min-h-[680px] max-w-7xl flex-col justify-center px-5 py-16 md:px-8">
          <div className="max-w-2xl">
            <p className="text-xs font-bold uppercase tracking-[0.38em] text-red-400/80">
              Offset Lab Torque Hub
            </p>
            <h1 className="mt-5 text-5xl font-black leading-[0.92] tracking-[-0.04em] sm:text-6xl md:text-7xl">
              Torque With
              <br />
              Confidence.
            </h1>
            <p className="mt-6 max-w-xl text-base leading-7 text-white/60 md:text-lg">
              Fast, vehicle-specific torque specs for wheels, brakes,
              suspension, fluids, and common automotive work.
            </p>
          </div>

          <div className="mt-10 max-w-5xl rounded-[1.6rem] border border-white/15 bg-black/75 p-4 shadow-2xl shadow-black/50 backdrop-blur-xl md:p-5">
            <div className="mb-4 flex items-center gap-3 text-[10px] font-bold uppercase tracking-[0.24em] text-white/35">
              <span className="flex h-6 w-6 items-center justify-center rounded-full bg-red-500 text-white">
                1
              </span>
              Select Your Vehicle
            </div>

            <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-4">
              <label>
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
                  Make
                </span>
                <select
                  value={selectedMake}
                  onChange={(event) => handleMakeChange(event.target.value)}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60"
                >
                  <option value="">Select make</option>
                  {makes.map((make) => (
                    <option key={make} value={make}>
                      {make}
                    </option>
                  ))}
                </select>
              </label>

              <label>
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
                  Vehicle
                </span>
                <select
                  value={selectedModel}
                  onChange={(event) => handleModelChange(event.target.value as ModelKey)}
                  disabled={!selectedMake}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60 disabled:cursor-not-allowed disabled:opacity-40"
                >
                  <option value="">Select vehicle</option>
                  {models.map((model) => (
                    <option key={`${model.make}-${model.model}`} value={model.model}>
                      {model.display_name ?? model.model}
                    </option>
                  ))}
                </select>
              </label>

              <label>
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
                  Trim
                </span>
                <select
                  value={selectedTrim}
                  onChange={(event) => setSelectedTrim(event.target.value)}
                  disabled={!selectedModel}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60 disabled:cursor-not-allowed disabled:opacity-40"
                >
                  <option value="">Select trim</option>
                  {trims.map((trim) => (
                    <option key={trim.trim} value={trim.trim}>
                      {trim.display_name ?? trim.trim}
                    </option>
                  ))}
                </select>
              </label>

              <label>
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.22em] text-white/40">
                  Torque Match
                </span>
                <select
                  value={selectedGeneration}
                  onChange={(event) => {
                    setSelectedGeneration(event.target.value);
                    setSelectedCategory("");
                    setSpecs([]);
                  }}
                  disabled={!torqueMatch || torqueMatch.generations.length === 0}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60 disabled:cursor-not-allowed disabled:opacity-40"
                >
                  <option value="">
                    {selectedModel && torqueMatch?.generations.length
                      ? "Select torque generation"
                      : selectedModel
                        ? "No torque specs yet"
                        : "Select vehicle first"}
                  </option>
                  {torqueMatch?.generations.map((generation) => (
                    <option key={generation.id} value={generation.id}>
                      {generation.name}
                    </option>
                  ))}
                </select>
              </label>
            </div>

            <div className="mt-5 flex flex-wrap gap-x-6 gap-y-2 border-t border-white/10 pt-4 text-xs text-white/40">
              <span>Same vehicle list as Fitment</span>
              <span>ft-lb and Nm values</span>
              <span>Source and review status on every spec</span>
            </div>
          </div>
        </div>
      </section>

      <section className="px-5 py-16 md:px-8 md:py-20">
        <div className="mx-auto max-w-7xl">
          <div className="flex flex-col gap-5 border-b border-white/10 pb-8 md:flex-row md:items-end md:justify-between">
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.32em] text-red-400/70">
                {selectedGeneration ? "Step 2" : "Torque Database"}
              </p>
              <h2 className="mt-3 text-3xl font-black tracking-tight md:text-5xl">
                {selectedGeneration
                  ? "Choose a Category"
                  : "Find the Right Specification"}
              </h2>
              <p className="mt-3 max-w-2xl text-sm leading-6 text-white/45">
                {selectedGeneration
                  ? `${selectedMakeName} / ${selectedModelName}${selectedTrimName ? ` / ${selectedTrimName}` : ""} / ${selectedGenerationName}`
                  : "Select your vehicle above, then choose the system you are working on."}
              </p>
            </div>
          </div>

          {selectedGeneration ? (
            <div className="mt-8">
              <div className="flex flex-wrap gap-3">
                {categories.map((category) => {
                  const isActive = selectedCategory === category.id;

                  return (
                    <button
                      key={category.id}
                      type="button"
                      onClick={() => {
                        setSelectedCategory(category.id);
                        window.requestAnimationFrame(() => {
                          document
                            .getElementById("torque-results")
                            ?.scrollIntoView({
                              behavior: "smooth",
                              block: "start",
                            });
                        });
                      }}
                      className={`rounded-xl border px-5 py-3 text-sm font-bold transition ${
                        isActive
                          ? "border-red-400 bg-red-500 text-white shadow-lg shadow-red-950/30"
                          : "border-white/10 bg-white/[0.035] text-white/60 hover:border-white/25 hover:text-white"
                      }`}
                    >
                      {category.name}
                    </button>
                  );
                })}
              </div>

              <div className="mt-7 grid gap-3 rounded-[1.5rem] border border-white/10 bg-white/[0.025] p-5 sm:grid-cols-3">
                {(["verified", "community", "needs_review"] as const).map((status) => (
                  <div key={status} className="flex items-start gap-3">
                    <span
                      className={`mt-0.5 shrink-0 rounded-full border px-2.5 py-1 text-[9px] font-bold uppercase tracking-[0.1em] ${sourceClass(
                        status
                      )}`}
                    >
                      {sourceLabel(status)}
                    </span>
                    <p className="text-xs leading-5 text-white/45">
                      {sourceDescription(status)}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="mt-8 grid gap-4 sm:grid-cols-3">
              {[
                ["01", "Select Vehicle", "Choose the exact make, model, and generation."],
                ["02", "Pick a System", "Open wheels, brakes, suspension, fluids, or another category."],
                ["03", "Read the Spec", "Review torque, units, notes, warnings, and source status."],
              ].map(([number, title, copy]) => (
                <div
                  key={number}
                  className="rounded-[1.4rem] border border-white/10 bg-white/[0.025] p-6"
                >
                  <p className="text-xs font-black tracking-[0.22em] text-red-400">
                    {number}
                  </p>
                  <h3 className="mt-4 text-lg font-black">{title}</h3>
                  <p className="mt-2 text-sm leading-6 text-white/45">{copy}</p>
                </div>
              ))}
            </div>
          )}

          {selectedModel && !selectedGeneration ? (
            <div className="mt-8 rounded-[1.5rem] border border-yellow-500/20 bg-yellow-500/[0.06] p-6 text-sm leading-6 text-yellow-100/80">
              This vehicle is available from the Fitment list, but torque specs have not been mapped for it yet.
            </div>
          ) : null}

          <div id="torque-results" className="scroll-mt-24 pt-10">
            {selectedGeneration && !selectedCategory ? (
              <div className="rounded-[1.5rem] border border-white/10 bg-white/[0.025] p-8 text-white/45">
                Select a category to view torque specifications.
              </div>
            ) : null}

            {loadingSpecs ? (
              <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                {[0, 1, 2].map((item) => (
                  <div
                    key={item}
                    className="h-64 animate-pulse rounded-[1.5rem] border border-white/10 bg-white/[0.04]"
                  />
                ))}
              </div>
            ) : null}

            {!loadingSpecs && selectedCategory && specs.length === 0 ? (
              <div className="rounded-[1.5rem] border border-white/10 bg-white/[0.025] p-8 text-white/45">
                No torque specs found for this selection yet.
              </div>
            ) : null}

            {!loadingSpecs && specs.length > 0 ? (
              <>
                <div className="mb-5 rounded-[1.3rem] border border-amber-400/20 bg-amber-400/[0.06] p-5">
                  <p className="text-xs font-black uppercase tracking-[0.18em] text-amber-200">
                    Safety first
                  </p>
                  <p className="mt-2 max-w-4xl text-sm leading-6 text-amber-50/65">
                    Confirm safety-critical values against the exact model-year service
                    manual. Use the correct tightening sequence and a calibrated torque
                    wrench; replace single-use hardware where specified.
                  </p>
                </div>

                <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                  {specs.map((spec) => {
                    const checkedDate = formatCheckedDate(spec.source_checked_at);
                    const sourceUrlAvailable = isSafeSourceUrl(spec.source_url);
                    const displayedStatus = displaySourceStatus(spec);

                    return (
                  <article
                    key={spec.id}
                    className="flex flex-col rounded-[1.5rem] border border-white/10 bg-[#0a0b0e] p-6 shadow-2xl shadow-black/20"
                  >
                    <div className="flex items-start justify-between gap-4">
                      <div>
                        <p className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/35">
                          {spec.component}
                        </p>
                        <h2 className="mt-2 text-xl font-black tracking-tight">
                          {spec.fastener}
                        </h2>
                      </div>

                      <span
                        className={`shrink-0 rounded-full border px-3 py-1 text-[10px] font-bold uppercase tracking-[0.12em] ${sourceClass(
                          displayedStatus
                        )}`}
                      >
                        {sourceLabel(displayedStatus)}
                      </span>
                    </div>

                    <div className="mt-7 border-y border-white/10 py-5">
                      {spec.torque_ft_lb !== null ? (
                        <div className="text-5xl font-black tracking-[-0.04em]">
                          {spec.torque_ft_lb}
                          <span className="ml-2 text-base font-bold tracking-normal text-white/40">
                            ft-lb
                          </span>
                        </div>
                      ) : (
                        <div className="text-xl font-bold text-white/45">
                          Torque unavailable
                        </div>
                      )}

                      {spec.torque_nm !== null ? (
                        <div className="mt-2 text-sm font-semibold text-white/40">
                          {spec.torque_nm} Nm
                        </div>
                      ) : null}

                      {spec.angle_degrees !== null ? (
                        <div className="mt-2 text-sm font-bold text-red-400">
                          + {spec.angle_degrees}° angle torque
                        </div>
                      ) : null}
                    </div>

                    {spec.notes ? (
                      <p className="mt-5 text-sm leading-6 text-white/45">
                        {spec.notes}
                      </p>
                    ) : null}

                    {spec.warning ? (
                      <div className="mt-5 rounded-xl border border-red-500/20 bg-red-500/10 p-4 text-sm leading-6 text-red-200">
                        {spec.warning}
                      </div>
                    ) : null}

                    <div className="mt-auto pt-6">
                      <div className="border-t border-white/10 pt-5">
                        <div className="flex items-center justify-between gap-3">
                          <p className="text-[10px] font-bold uppercase tracking-[0.2em] text-white/30">
                            Source
                          </p>
                          {checkedDate ? (
                            <p className="text-[10px] font-semibold text-white/30">
                              Checked {checkedDate}
                            </p>
                          ) : null}
                        </div>

                        <p className="mt-2 text-sm font-semibold text-white/72">
                          {spec.source_name || "Source not yet attached"}
                        </p>

                        {spec.source_note ? (
                          <p className="mt-2 text-xs leading-5 text-white/38">
                            {spec.source_note}
                          </p>
                        ) : null}

                        {sourceUrlAvailable ? (
                          <a
                            href={spec.source_url!}
                            target="_blank"
                            rel="noreferrer"
                            className="mt-4 inline-flex items-center gap-2 text-xs font-bold text-red-400 transition hover:text-red-300"
                          >
                            Open source <span aria-hidden="true">-&gt;</span>
                          </a>
                        ) : (
                          <p className="mt-4 text-xs font-semibold text-yellow-200/55">
                            Direct source link pending
                          </p>
                        )}
                      </div>
                    </div>
                  </article>
                    );
                  })}
                </div>
              </>
            ) : null}
          </div>
        </div>
      </section>
    </main>
  );
}
