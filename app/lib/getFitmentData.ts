import { supabase } from "./supabase";
import {
  fitmentData,
  ModelKey,
  StyleKey,
  TrimData,
  Preset,
} from "../data/fitment";

type FitmentPresetRow = {
  make: string;
  model: ModelKey;
  trim: string;
  style: StyleKey;
  baseline_front: string;
  baseline_rear: string;
  baseline_tire: string;
  bolt_pattern: string;
  center_bore: string;
  title: string;
  subtitle: string;
  front_wheel: string;
  rear_wheel: string;
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
  warnings: string[];
  alternate: string;
};

function rowToPreset(row: FitmentPresetRow): Preset {
  return {
    title: row.title,
    subtitle: row.subtitle,
    front: row.front_wheel,
    rear: row.rear_wheel,
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
    warnings: row.warnings,
    alternate: row.alternate,
  };
}

export async function getFitmentData(): Promise<Record<ModelKey, TrimData[]>> {
  const { data, error } = await supabase
    .from("fitment_presets")
    .select("*")
    .eq("active", true)
    .order("sort_order", { ascending: true });

  if (error || !data) {
    console.warn("Using hardcoded fitment fallback:", error);
    return fitmentData;
  }

  const merged: Record<ModelKey, TrimData[]> = { ...fitmentData };

  for (const row of data as FitmentPresetRow[]) {
    if (!merged[row.model]) {
      merged[row.model] = [];
    }

    let trimEntry = merged[row.model].find((entry) => entry.trim === row.trim);

    if (!trimEntry) {
      trimEntry = {
        trim: row.trim,
        baseline: {
          front: row.baseline_front,
          rear: row.baseline_rear,
          tire: row.baseline_tire,
          boltPattern: row.bolt_pattern,
          centerBore: row.center_bore,
        },
        presets: {
          oemplus: rowToPreset(row),
          flush: rowToPreset(row),
          aggressive: rowToPreset(row),
        },
      };

      merged[row.model].push(trimEntry);
    }

    trimEntry.presets[row.style] = rowToPreset(row);
  }

  return merged;
}
