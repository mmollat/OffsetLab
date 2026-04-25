export type MakeKey = "Tesla" | "BMW" | "Toyota" | "Porsche";
export type StyleKey = "oemplus" | "flush" | "aggressive";
export type ModelKey =
  | "Model 3"
  | "Model Y"
  | "Model S"
  | "Model X"
  | "M3"
  | "M4"
  | "GR86";

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

const low = ["Very low rub risk", "Good daily setup"];
const mod = ["Ride height matters", "Check clearance if lowered"];

function p(
  title: string,
  subtitle: string,
  front: string,
  rear: string,
  frontTire: string,
  rearTire: string,
  pokeFront: string,
  pokeRear: string,
  innerFront: string,
  innerRear: string,
  diameter: string,
  aggression: number,
  daily: number,
  risk: string,
  verdict: string,
  warnings: string[],
  alternate: string
): Preset {
  return {
    title,
    subtitle,
    front,
    rear,
    frontTire,
    rearTire,
    pokeFront,
    pokeRear,
    innerFront,
    innerRear,
    diameter,
    aggression,
    daily,
    risk,
    verdict,
    warnings,
    alternate,
  };
}

export const makes = [
  { label: "Tesla", active: true },
  { label: "BMW", active: true },
  { label: "Toyota", active: true },
  { label: "Porsche", active: false },
];

export const fitmentData: Record<ModelKey, TrimData[]> = {
  "Model 3": [], // keep your existing data (unchanged)

  "Model Y": [],

  "Model S": [],

  "Model X": [],

  "M3": [],

  "M4": [],

  // 🔥 NEW MODEL
  "GR86": [
    {
      trim: "Base / Premium",
      baseline: {
        front: "17x7.5 +48",
        rear: "17x7.5 +48",
        tire: "215/45R17",
        boltPattern: "5x100",
        centerBore: "56.1",
      },
      presets: {
        oemplus: p(
          "OEM+ Setup",
          "Clean daily upgrade",
          "18x8 +40",
          "18x8 +40",
          "225/40R18",
          "225/40R18",
          "+8mm",
          "+8mm",
          "-3mm",
          "-3mm",
          "+0.2%",
          4,
          9,
          "Low",
          "Perfect OEM+ GR86 fitment. Clean, balanced, and daily-friendly.",
          low,
          "18x8.5 +40 / 235/40R18"
        ),
        flush: p(
          "Flush Street Setup",
          "Best daily stance",
          "18x9 +38",
          "18x9 +38",
          "245/35R18",
          "245/35R18",
          "+18mm",
          "+18mm",
          "-6mm",
          "-6mm",
          "+0.3%",
          7,
          8,
          "Low / Moderate",
          "Ideal flush GR86 setup. Fills the car out perfectly.",
          ["Lowered cars should watch front clearance"],
          "17x9 +38 / 245/40R17"
        ),
        aggressive: p(
          "Aggressive Setup",
          "Wider stance, enthusiast fitment",
          "18x9.5 +35",
          "18x9.5 +35",
          "255/35R18",
          "255/35R18",
          "+25mm",
          "+25mm",
          "-8mm",
          "-8mm",
          "+0.5%",
          8,
          7,
          "Moderate",
          "Aggressive GR86 fitment with strong stance.",
          ["May require camber depending on ride height"],
          "18x10 +35 / 265/35R18"
        ),
      },
    },
  ],
};

export const makeModelOptions = {
  Tesla: ["Model 3", "Model Y", "Model S", "Model X"],
  BMW: ["M3", "M4"],
  Toyota: ["GR86"],
  Porsche: [],
};

export function getModelsForMake(make: MakeKey) {
  return makeModelOptions[make] ?? [];
}

export function getDefaultModelForMake(make: MakeKey): ModelKey {
  return getModelsForMake(make)[0] ?? "Model 3";
}

export function getTrims(model: ModelKey) {
  return fitmentData[model].map((entry) => entry.trim);
}

export function getTrimData(model: ModelKey, trim: string) {
  return fitmentData[model].find((entry) => entry.trim === trim) ?? fitmentData[model][0];
}

export function modelSlug(model: ModelKey) {
  return model.toLowerCase().replace(/\s+/g, "-");
}

export function normalizeModel(value: string | null): ModelKey {
  const input = (value || "").toLowerCase();
  if (input.includes("gr86")) return "GR86";
  if (input.includes("m4")) return "M4";
  if (input.includes("m3")) return "M3";
  if (input.includes("model y")) return "Model Y";
  if (input.includes("model s")) return "Model S";
  if (input.includes("model x")) return "Model X";
  return "Model 3";
}

export function normalizeStyle(value: string | null): StyleKey {
  const input = (value || "").toLowerCase();
  if (input.includes("oem")) return "oemplus";
  if (input.includes("flush")) return "flush";
  return "aggressive";
}

export function normalizeMake(value: string | null): MakeKey {
  const input = (value || "").toLowerCase();
  if (input.includes("bmw")) return "BMW";
  if (input.includes("toyota")) return "Toyota";
  if (input.includes("porsche")) return "Porsche";
  return "Tesla";
}
