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

export const makes: { label: MakeKey; active: boolean }[] = [
  { label: "Tesla", active: true },
  { label: "BMW", active: true },
  { label: "Toyota", active: true },
  { label: "Porsche", active: false },
];

export const fitmentData: Record<ModelKey, TrimData[]> = {
  "Model 3": [
    {
      trim: "Performance",
      baseline: {
        front: "20x9 +34",
        rear: "20x9 +34",
        tire: "235/35R20",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+", "Clean daily", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+7mm", "+7mm", "-1mm", "-1mm", "+0.3%", 4, 9, "Low", "Clean OEM+.", low, "19x9 +35"),
        flush: p("Flush", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+18mm", "+18mm", "-8mm", "-8mm", "+0.5%", 7, 8, "Moderate", "Nice daily.", mod, "20x9 +30"),
        aggressive: p("Aggressive", "Wider stance", "20x9 +26", "20x10.5 +38", "245/35R20", "285/30R20", "+22mm", "+28mm", "-6mm", "-10mm", "+0.8%", 8, 7, "Moderate", "Aggressive look.", mod, "19x9.5 +25"),
      },
    },
  ],

  "Model Y": [
    {
      trim: "Performance",
      baseline: {
        front: "21x9.5 +40",
        rear: "21x10.5 +45",
        tire: "255/35R21 / 275/35R21",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+", "Close to stock", "21x9.5 +38", "21x10.5 +42", "255/35R21", "275/35R21", "+2mm", "+3mm", "-2mm", "-3mm", "0%", 4, 9, "Low", "Minimal change.", low, "20x10 +38"),
        flush: p("Flush", "Sharper stance", "21x10 +35", "21x11 +40", "265/35R21", "295/35R21", "+8mm", "+10mm", "-4mm", "-5mm", "+0.5%", 7, 8, "Moderate", "Clean stance.", mod, "21x10 +35"),
        aggressive: p("Aggressive", "Wide stance", "21x10.5 +30", "21x11.5 +35", "275/35R21", "305/30R21", "+15mm", "+20mm", "-5mm", "-8mm", "+0.8%", 8, 7, "Moderate", "Wide look.", mod, "20x10 +30"),
      },
    },
  ],

  // 👇 REQUIRED to fix your error
  "Model S": [],
  "Model X": [],

  "M3": [
    {
      trim: "G80 M3",
      baseline: {
        front: "19x9.5 ET20",
        rear: "20x10.5 ET20",
        tire: "275/35R19 / 285/30R20",
        boltPattern: "5x112",
        centerBore: "66.6",
      },
      presets: {
        oemplus: p("OEM+", "Factory", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "0", "0", "OEM", "OEM", "OEM", 6, 9, "Low", "Stock+", low, "19x10 ET20"),
        flush: p("Flush", "Street", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Moderate", "Clean.", mod, "20x10 ET18"),
        aggressive: p("Aggressive", "Wide", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Wide stance.", mod, "20x10 ET15"),
      },
    },
  ],

  "M4": [
    {
      trim: "G82 M4",
      baseline: {
        front: "19x9.5 ET20",
        rear: "20x10.5 ET20",
        tire: "275/35R19 / 285/30R20",
        boltPattern: "5x112",
        centerBore: "66.6",
      },
      presets: {
        oemplus: p("OEM+", "Factory", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "0", "0", "OEM", "OEM", "OEM", 6, 9, "Low", "Stock+", low, "19x10 ET20"),
        flush: p("Flush", "Street", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Moderate", "Clean.", mod, "20x10 ET18"),
        aggressive: p("Aggressive", "Wide", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Wide stance.", mod, "20x10 ET15"),
      },
    },
  ],

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
        oemplus: p("OEM+", "Daily", "18x8 +40", "18x8 +40", "225/40R18", "225/40R18", "+8mm", "+8mm", "-3mm", "-3mm", "+0.2%", 4, 9, "Low", "Perfect.", low, "18x8.5 +40"),
        flush: p("Flush", "Balanced", "18x9 +38", "18x9 +38", "245/35R18", "245/35R18", "+18mm", "+18mm", "-6mm", "-6mm", "+0.3%", 7, 8, "Low", "Ideal.", mod, "17x9 +38"),
        aggressive: p("Aggressive", "Wide", "18x9.5 +35", "18x9.5 +35", "255/35R18", "255/35R18", "+25mm", "+25mm", "-8mm", "-8mm", "+0.5%", 8, 7, "Moderate", "Aggressive.", mod, "18x10 +35"),
      },
    },
  ],
};

// ----------------------------
// HELPERS (fixes your import errors)
// ----------------------------

export function normalizeMake(value: string | null): MakeKey {
  const input = (value || "").toLowerCase();
  if (input === "bmw") return "BMW";
  if (input === "toyota") return "Toyota";
  return "Tesla";
}

export function normalizeModel(value: string | null): ModelKey {
  return (value as ModelKey) || "Model 3";
}

export function normalizeStyle(value: string | null): StyleKey {
  if (value === "flush") return "flush";
  if (value === "oemplus") return "oemplus";
  return "aggressive";
}

export function modelSlug(model: ModelKey) {
  return model.toLowerCase().replace(/\s+/g, "-");
}

export function getModelsForMake(make: MakeKey): ModelKey[] {
  if (make === "BMW") return ["M3", "M4"];
  if (make === "Toyota") return ["GR86"];
  return ["Model 3", "Model Y", "Model S", "Model X"];
}

export function getDefaultModelForMake(make: MakeKey): ModelKey {
  return getModelsForMake(make)[0];
}

export function getTrims(model: ModelKey): string[] {
  return fitmentData[model].map((t) => t.trim);
}

export function getTrimData(model: ModelKey, trim: string): TrimData {
  return fitmentData[model].find((t) => t.trim === trim)!;
}
