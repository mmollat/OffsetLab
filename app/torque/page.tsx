"use client";

import { useEffect, useState } from "react";
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
};

type Category = {
  id: string;
  name: string;
  slug: string;
};

type Spec = {
  id: string;
  component: string;
  fastener: string;
  torque_ft_lb: number;
  torque_nm: number;
  notes: string;
};

export default function TorquePage() {
  const [makes, setMakes] = useState<Make[]>([]);
  const [models, setModels] = useState<Model[]>([]);
  const [generations, setGenerations] = useState<Generation[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [specs, setSpecs] = useState<Spec[]>([]);

  const [selectedMake, setSelectedMake] = useState<string | null>(null);
  const [selectedModel, setSelectedModel] = useState<string | null>(null);
  const [selectedGen, setSelectedGen] = useState<string | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  useEffect(() => {
    fetchMakes();
    fetchCategories();
  }, []);

  async function fetchMakes() {
    const { data } = await supabase.from("torque_vehicle_makes").select("*");
    setMakes(data || []);
  }

  async function fetchModels(makeId: string) {
    const { data } = await supabase
      .from("torque_vehicle_models")
      .select("*")
      .eq("make_id", makeId);

    setModels(data || []);
  }

  async function fetchGenerations(modelId: string) {
    const { data } = await supabase
      .from("torque_vehicle_generations")
      .select("*")
      .eq("model_id", modelId);

    setGenerations(data || []);
  }

  async function fetchCategories() {
    const { data } = await supabase
      .from("torque_categories")
      .select("*")
      .order("sort_order");

    setCategories(data || []);
  }

  async function fetchSpecs(genId: string, categoryId: string) {
    const { data } = await supabase
      .from("torque_specs")
      .select("*")
      .eq("generation_id", genId)
      .eq("category_id", categoryId);

    setSpecs(data || []);
  }

  return (
    <div className="p-6 text-white">
      <h1 className="text-2xl font-semibold mb-6">TorqueHub</h1>

      {/* MAKE */}
      <select
        className="bg-black border p-2 mr-2"
        onChange={(e) => {
          setSelectedMake(e.target.value);
          fetchModels(e.target.value);
        }}
      >
        <option>Select Make</option>
        {makes.map((m) => (
          <option key={m.id} value={m.id}>
            {m.name}
          </option>
        ))}
      </select>

      {/* MODEL */}
      <select
        className="bg-black border p-2 mr-2"
        onChange={(e) => {
          setSelectedModel(e.target.value);
          fetchGenerations(e.target.value);
        }}
      >
        <option>Select Model</option>
        {models.map((m) => (
          <option key={m.id} value={m.id}>
            {m.name}
          </option>
        ))}
      </select>

      {/* GENERATION */}
      <select
        className="bg-black border p-2 mr-2"
        onChange={(e) => {
          setSelectedGen(e.target.value);
        }}
      >
        <option>Select Generation</option>
        {generations.map((g) => (
          <option key={g.id} value={g.id}>
            {g.name}
          </option>
        ))}
      </select>

      {/* CATEGORY */}
      <select
        className="bg-black border p-2"
        onChange={(e) => {
          setSelectedCategory(e.target.value);
          if (selectedGen) {
            fetchSpecs(selectedGen, e.target.value);
          }
        }}
      >
        <option>Select Category</option>
        {categories.map((c) => (
          <option key={c.id} value={c.id}>
            {c.name}
          </option>
        ))}
      </select>

      {/* RESULTS */}
      <div className="mt-8 grid gap-4">
  {specs.map((s) => (
    <div
      key={s.id}
      className="bg-neutral-900 border border-neutral-800 rounded-xl p-4"
    >
      <div className="text-sm text-gray-400">{s.component}</div>

      <div className="text-lg font-semibold mt-1">
        {s.fastener}
      </div>

      <div className="text-xl mt-2">
        {s.torque_ft_lb} ft-lb
        <span className="text-gray-500 text-sm ml-2">
          ({s.torque_nm} Nm)
        </span>
      </div>

      {s.notes && (
        <div className="text-xs text-gray-500 mt-2">
          {s.notes}
        </div>
      )}
    </div>
  ))}
</div>
    </div>
  );
}
