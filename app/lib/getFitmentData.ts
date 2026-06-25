import { supabase } from "./supabase";
import {
  ConfigurationKey,
  DrivingGoalKey,
  FitmentVariant,
  ModelKey,
  StyleKey,
  TrimData,
} from "../data/fitment";

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
  factory_front?: string | null;
  factory_rear?: string | null;
  factory_tire?: string | null;
};

type FitmentVariantRow = {
  make: string;
  model: ModelKey;
  trim: string;
  style: StyleKey;
  goal: DrivingGoalKey;
  configuration: ConfigurationKey;
  front: string;
  rear: string;
  front_tire: string;
  rear_tire: string;
  note: string | null;
  active: boolean;
};

function hasFactoryBaseline(row: FitmentRow) {
  return Boolean(row.factory_front || row.factory_rear || row.factory_tire);
}

function getBaselineFromRow(row: FitmentRow) {
  return {
    front: row.factory_front ?? row.front,
    rear: row.factory_rear ?? row.rear,
    tire: row.factory_tire ?? row.front_tire,
    boltPattern: row.bolt_pattern ?? "",
    centerBore: row.center_bore ?? "",
  };
}

function getVariantKey(row: Pick<FitmentVariantRow, "make" | "model" | "trim" | "style">) {
  return [row.make, row.model, row.trim, row.style].join("::");
}

async function getFitmentVariants() {
  const { data, error } = await supabase
    .from("fitment_preset_variants")
    .select("*")
    .eq("active", true);

  if (error || !data) {
    const message = error?.message ?? "";

    if (message.includes("fitment_preset_variants")) {
      console.info("fitment_preset_variants table is not available yet; using fallback fitment variants.");
    } else {
      console.error("Error loading fitment variants:", error);
    }

    return new Map<string, FitmentVariant[]>();
  }

  return (data as FitmentVariantRow[]).reduce((variants, row) => {
    const key = getVariantKey(row);
    const list = variants.get(key) ?? [];

    list.push({
      goal: row.goal,
      configuration: row.configuration,
      front: row.front,
      rear: row.rear,
      frontTire: row.front_tire,
      rearTire: row.rear_tire,
      note: row.note ?? undefined,
    });

    variants.set(key, list);
    return variants;
  }, new Map<string, FitmentVariant[]>());
}

export async function getFitmentData(): Promise<Record<ModelKey, TrimData[]>> {
  const pageSize = 1000;
  let from = 0;
  let allRows: FitmentRow[] = [];
  const variantMap = await getFitmentVariants();

  while (true) {
    const { data, error } = await supabase
      .from("fitment_presets")
      .select("*")
      .eq("active", true)
      .order("make", { ascending: true })
      .order("model", { ascending: true })
      .order("trim", { ascending: true })
      .order("style", { ascending: true })
      .range(from, from + pageSize - 1);

    if (error || !data) {
      console.error("Error loading fitment data:", error);
      return {};
    }

    allRows = [...allRows, ...(data as FitmentRow[])];

    if (data.length < pageSize) break;

    from += pageSize;
  }

  const grouped: Record<ModelKey, Record<string, TrimData>> = {} as any;
  const baselineIsFactory: Record<ModelKey, Record<string, boolean>> = {} as any;

  allRows.forEach((row) => {
    if (!grouped[row.model]) grouped[row.model] = {};
    if (!baselineIsFactory[row.model]) baselineIsFactory[row.model] = {};

    if (!grouped[row.model][row.trim]) {
      grouped[row.model][row.trim] = {
        trim: row.trim,
        baseline: getBaselineFromRow(row),
        presets: {} as any,
      };
      baselineIsFactory[row.model][row.trim] = hasFactoryBaseline(row);
    }

    if (hasFactoryBaseline(row) || (row.style === "oemplus" && !baselineIsFactory[row.model][row.trim])) {
      grouped[row.model][row.trim].baseline = getBaselineFromRow(row);
      baselineIsFactory[row.model][row.trim] = hasFactoryBaseline(row);
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
      variants: variantMap.get(getVariantKey(row)) ?? [],
    };
  });

  const result: Record<ModelKey, TrimData[]> = {} as any;

  Object.entries(grouped).forEach(([model, trims]) => {
    result[model as ModelKey] = Object.values(trims);
  });

  return result;
}
