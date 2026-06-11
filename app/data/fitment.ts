export type MakeKey =
  | "Tesla"
  | "BMW"
  | "Toyota"
  | "Porsche"
  | "Honda"
  | "McLaren"
  | string;

export type StyleKey = "oemplus" | "flush" | "aggressive";

export type ModelKey = string;

export type Preset = {
  title: string;
  subtitle: string;
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  pokeFront: string;
  pokeRear: string;
  innerFront: string;
  innerRear: string;
  diameter: string;
  aggression: number;
  daily: number;
  risk: string;
  verdict: string;
  warnings: string[];
  alternate: string;
};

export type TrimData = {
  trim: string;
  baseline: {
    front: string;
    rear: string;
    tire: string;
    boltPattern: string;
    centerBore: string;
  };
  presets: Record<StyleKey, Preset>;
};

/**
 * Supabase is now the source of truth.
 * These empty exports keep older pages from breaking during the migration.
 */
export const fitmentData: Record<ModelKey, TrimData[]> = {};

export const makes: { label: MakeKey; active: boolean }[] = [];

export const makeModelOptions: Record<MakeKey, ModelKey[]> = {};

export const modelOptions: ModelKey[] = [];

export function getModelsForMake(make: MakeKey): ModelKey[] {
  return makeModelOptions[make] ?? [];
}

export function getDefaultModelForMake(make: MakeKey): ModelKey {
  return getModelsForMake(make)[0] ?? "";
}

export function getTrims(model: ModelKey): string[] {
  return fitmentData[model]?.map((entry) => entry.trim) ?? [];
}

export function getTrimData(model: ModelKey, trim: string): TrimData | null {
  const entries = fitmentData[model];
  if (!entries || entries.length === 0) return null;
  return entries.find((entry) => entry.trim === trim) ?? entries[0];
}

export function modelSlug(model: ModelKey): string {
  return model
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

export function normalizeModel(value: string | null, make: MakeKey = "Tesla"): ModelKey {
  return (value || "").replace(/[-_]/g, " ").trim();
}

export function normalizeStyle(value: string | null): StyleKey {
  const input = (value || "").toLowerCase().trim();
  if (input === "oemplus" || input === "oem+") return "oemplus";
  if (input === "flush") return "flush";
  return "aggressive";
}

export function normalizeMake(value: string | null): MakeKey {
  const input = (value || "").toLowerCase().trim();

  if (input === "bmw") return "BMW";
  if (input === "toyota") return "Toyota";
  if (input === "honda") return "Honda";
  if (input === "mclaren") return "McLaren";
  if (input === "porsche") return "Porsche";
  if (input === "tesla") return "Tesla";

  return value || "Tesla";
}
