import { supabase } from "./supabase";
import { ModelKey, StyleKey, TrimData } from "../data/fitment";

type FitmentRow = {
  make: string;
  model: ModelKey;
  trim: string;
  style: StyleKey;
  title: string | null;
  subtitle: string | null;
  front: string;
  rear: string;
  front_tire: string;
  rear_tire: string;
  poke_front: string;
  poke_rear: string;
  inner_front: string;
  inner_rear: string;
  diameter: string;
  aggression: number;
  daily: number;
  risk: string;
  verdict: string;
  alternate: string;
  warnings: string[] | null;
  bolt_pattern: string | null;
  center_bore: string | null;
};

export async function getFitmentData(): Promise<Record<ModelKey, TrimData[]>> {
  const { data, error } = await supabase
    .from("fitment_presets")
    .select("*")
    .order("make", { ascending: true })
    .order("model", { ascending: true })
    .order("trim", { ascending: true });

  if (error || !data) {
    console.error("Error loading fitment data:", error);
    return {};
  }

  const grouped: Record<ModelKey, Record<string, TrimData>> = {} as any;

  (data as FitmentRow[]).forEach((row) => {
    if (!grouped[row.model]) grouped[row.model] = {};

    if (!grouped[row.model][row.trim]) {
      grouped[row.model][row.trim] = {
        trim: row.trim,
        baseline: {
          front: row.front,
          rear: row.rear,
          tire: row.front_tire,
          boltPattern: row.bolt_pattern ?? "",
          centerBore: row.center_bore ?? "",
        },
        presets: {} as any,
      };
    }

    if (row.style === "oemplus") {
      grouped[row.model][row.trim].baseline = {
        front: row.front,
        rear: row.rear,
        tire: row.front_tire,
        boltPattern: row.bolt_pattern ?? "",
        centerBore: row.center_bore ?? "",
      };
    }

    grouped[row.model][row.trim].presets[row.style] = {
      title: row.title ?? row.style.toUpperCase(),
      subtitle: row.subtitle ?? "",
      front: row.front,
      rear: row.rear,
      frontTire: row.front_tire,
      rearTire: row.rear_tire,
      pokeFront: row.poke_front,
      pokeRear: row.poke_rear,
      innerFront: row.inner_front,
      innerRear: row.inner_rear,
      diameter: row.diameter,
      aggression: row.aggression,
      daily: row.daily,
      risk: row.risk,
      verdict: row.verdict,
      warnings: row.warnings ?? [],
      alternate: row.alternate,
    };
  });

  const result: Record<ModelKey, TrimData[]> = {} as any;

  Object.entries(grouped).forEach(([model, trims]) => {
    result[model as ModelKey] = Object.values(trims);
  });

  return result;
}
