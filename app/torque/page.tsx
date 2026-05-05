"use client";

import { useEffect, useMemo, useState } from "react";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

type Make = {
  id: string;
  name: string;
  slug: string;
};

type Model = {
  id: string;
  name: string;
  slug: string;
};

type Generation = {
  id: string;
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

export default function TorquePage() {
  const [makes, setMakes] = useState<Make[]>([]);
  const [models, setModels] = useState<Model[]>([]);
  const [generations, setGenerations] = useState<Generation[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [specs, setSpecs] = useState<Spec[]>([]);

  const [selectedMake, setSelectedMake] = useState("");
  const [selectedModel, setSelectedModel] = useState("");
  const [selectedGeneration, setSelectedGeneration] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("");

  const [loadingSpecs, setLoadingSpecs] = useState(false);

  useEffect(() => {
    fetchMakes();
    fetchCategories();
  }, []);

  useEffect(() => {
    if (selectedGeneration && selectedCategory) {
      fetchSpecs(selectedGeneration, selectedCategory);
    }
  }, [selectedGeneration, selectedCategory]);

  const selectedMakeName = useMemo(() => {
    return makes.find((make) => make.id === selectedMake)?.name;
  }, [makes, selectedMake]);

  const selectedModelName = useMemo(() => {
    return models.find((model) => model.id === selectedModel)?.name;
  }, [models, selectedModel]);

  const selectedGenerationName = useMemo(() => {
    return generations.find((generation) => generation.id === selectedGeneration)
      ?.name;
  }, [generations, selectedGeneration]);

  async function fetchMakes() {
    const { data, error } = await supabase
      .from("torque_vehicle_makes")
      .select("*")
      .order("name", { ascending: true });

    if (error) {
      console.error("Error fetching makes:", error);
      return;
    }

    setMakes(data || []);
  }

  async function fetchModels(makeId: string) {
    const { data, error } = await supabase
      .from("torque_vehicle_models")
      .select("*")
      .eq("make_id", makeId)
      .order("name", { ascending: true });

    if (error) {
      console.error("Error fetching models:", error);
      return;
    }

    setModels(data || []);
  }

  async function fetchGenerations(modelId: string) {
    const { data, error } = await supabase
      .from("torque_vehicle_generations")
      .select("*")
      .eq("model_id", modelId)
      .order("start_year", { ascending: true });

    if (error) {
      console.error("Error fetching generations:", error);
      return;
    }

    setGenerations(data || []);
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
    setSelectedGeneration("");
    setSelectedCategory("");
    setModels([]);
    setGenerations([]);
    setSpecs([]);

    if (makeId) fetchModels(makeId);
  }

  function handleModelChange(modelId: string) {
    setSelectedModel(modelId);
    setSelectedGeneration("");
    setSelectedCategory("");
    setGenerations([]);
    setSpecs([]);

    if (modelId) fetchGenerations(modelId);
  }

  function handleGenerationChange(generationId: string) {
    setSelectedGeneration(generationId);
    setSelectedCategory("");
    setSpecs([]);
  }

  return (
    <main className="min-h-screen bg-black text-white">
      <section className="border-t border-neutral-800 bg-gradient-to-br from-black via-black to-emerald-950/20 px-6 py-16">
        <div className="mx-auto max-w-7xl">
          <div className="mb-10">
            <p className="mb-3 text-xs font-semibold uppercase tracking-[0.3em] text-red-500">
              Offset Lab Tool
            </p>

            <h1 className="text-4xl font-bold tracking-tight md:text-6xl">
              TorqueHub
            </h1>

            <p className="mt-4 max-w-2xl text-base leading-7 text-neutral-400">
              Fast torque spec lookup for wheels, brakes, suspension, fluids,
              and common DIY automotive work.
            </p>
          </div>

          <div className="grid gap-4 md:grid-cols-3">
            <select
              value={selectedMake}
              onChange={(event) => handleMakeChange(event.target.value)}
              className="h-14 rounded-xl border border-neutral-700 bg-black px-4 text-lg font-semibold text-white outline-none transition focus:border-red-500"
            >
              <option value="">Select Make</option>
              {makes.map((make) => (
                <option key={make.id} value={make.id}>
                  {make.name}
                </option>
              ))}
            </select>

            <select
              value={selectedModel}
              onChange={(event) => handleModelChange(event.target.value)}
              disabled={!selectedMake}
              className="h-14 rounded-xl border border-neutral-700 bg-black px-4 text-lg font-semibold text-white outline-none transition focus:border-red-500 disabled:cursor-not-allowed disabled:opacity-40"
            >
              <option value="">Select Model</option>
              {models.map((model) => (
                <option key={model.id} value={model.id}>
                  {model.name}
                </option>
              ))}
            </select>

            <select
              value={selectedGeneration}
              onChange={(event) => handleGenerationChange(event.target.value)}
              disabled={!selectedModel}
              className="h-14 rounded-xl border border-neutral-700 bg-black px-4 text-lg font-semibold text-white outline-none transition focus:border-red-500 disabled:cursor-not-allowed disabled:opacity-40"
            >
              <option value="">Select Generation</option>
              {generations.map((generation) => (
                <option key={generation.id} value={generation.id}>
                  {generation.name}
                </option>
              ))}
            </select>
          </div>

          {selectedGeneration && (
            <div className="mt-8">
              <div className="mb-3 text-xs font-semibold uppercase tracking-[0.25em] text-neutral-500">
                Category
              </div>

              <div className="flex flex-wrap gap-3">
                {categories.map((category) => {
                  const isActive = selectedCategory === category.id;

                  return (
                    <button
                      key={category.id}
                      type="button"
                      onClick={() => setSelectedCategory(category.id)}
                      className={`rounded-full border px-5 py-3 text-sm font-semibold transition ${
                        isActive
                          ? "border-white bg-white text-black"
                          : "border-neutral-700 bg-neutral-950 text-neutral-400 hover:border-neutral-500 hover:text-white"
                      }`}
                    >
                      {category.name}
                    </button>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      </section>

      <section className="px-6 py-10">
        <div className="mx-auto max-w-7xl">
          {selectedMakeName && selectedModelName && selectedGenerationName && (
            <div className="mb-6 text-sm text-neutral-500">
              {selectedMakeName} / {selectedModelName} /{" "}
              {selectedGenerationName}
            </div>
          )}

          {!selectedGeneration && (
            <div className="rounded-2xl border border-neutral-800 bg-neutral-950 p-8 text-neutral-400">
              Select a vehicle to begin.
            </div>
          )}

          {selectedGeneration && !selectedCategory && (
            <div className="rounded-2xl border border-neutral-800 bg-neutral-950 p-8 text-neutral-400">
              Select a category to view torque specs.
            </div>
          )}

          {loadingSpecs && (
            <div className="rounded-2xl border border-neutral-800 bg-neutral-950 p-8 text-neutral-400">
              Loading torque specs...
            </div>
          )}

          {!loadingSpecs && selectedCategory && specs.length === 0 && (
            <div className="rounded-2xl border border-neutral-800 bg-neutral-950 p-8 text-neutral-400">
              No torque specs found for this selection yet.
            </div>
          )}

          {!loadingSpecs && specs.length > 0 && (
            <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
              {specs.map((spec) => (
                <article
                  key={spec.id}
                  className="rounded-2xl border border-neutral-800 bg-neutral-900/80 p-6 shadow-2xl shadow-black/20"
                >
                  <div className="mb-4 flex items-start justify-between gap-4">
                    <div>
                      <div className="text-xs font-semibold uppercase tracking-[0.2em] text-neutral-500">
                        {spec.component}
                      </div>

                      <h2 className="mt-2 text-2xl font-bold tracking-tight">
                        {spec.fastener}
                      </h2>
                    </div>

                    <span
                      className={`shrink-0 rounded-full border px-3 py-1 text-xs font-semibold ${sourceClass(
                        spec.source_status
                      )}`}
                    >
                      {sourceLabel(spec.source_status)}
                    </span>
                  </div>

                  <div className="mt-5">
                    {spec.torque_ft_lb !== null ? (
                      <div className="text-4xl font-black tracking-tight">
                        {spec.torque_ft_lb}
                        <span className="ml-2 text-xl font-semibold text-neutral-400">
                          ft-lb
                        </span>
                      </div>
                    ) : (
                      <div className="text-2xl font-bold text-neutral-400">
                        Torque unavailable
                      </div>
                    )}

                    {spec.torque_nm !== null && (
                      <div className="mt-1 text-lg font-semibold text-neutral-500">
                        {spec.torque_nm} Nm
                      </div>
                    )}

                    {spec.angle_degrees !== null && (
                      <div className="mt-2 text-sm font-semibold text-red-400">
                        + {spec.angle_degrees}° angle torque
                      </div>
                    )}
                  </div>

                  {spec.notes && (
                    <p className="mt-5 text-sm leading-6 text-neutral-400">
                      {spec.notes}
                    </p>
                  )}

                  {spec.warning && (
                    <div className="mt-5 rounded-xl border border-red-500/20 bg-red-500/10 p-4 text-sm leading-6 text-red-200">
                      {spec.warning}
                    </div>
                  )}
                </article>
              ))}
            </div>
          )}
        </div>
      </section>
    </main>
  );
}
