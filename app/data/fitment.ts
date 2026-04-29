export type MakeKey = string;
export type ModelKey = string;
export type StyleKey = "oemplus" | "flush" | "aggressive";

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

export function modelSlug(model: ModelKey): string {
  return model.toLowerCase().replace(/\s+/g, "-");
}

export function normalizeStyle(value: string | null): StyleKey {
  const input = (value || "").toLowerCase().trim();

  if (input === "oemplus" || input === "oem+" || input === "oem plus") {
    return "oemplus";
  }

  if (input === "flush") {
    return "flush";
  }

  return "aggressive";
}

export function normalizeMake(value: string | null): MakeKey {
  return (value || "").trim();
}

export function normalizeModel(value: string | null): ModelKey {
  return (value || "")
    .replace(/[-_]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}
