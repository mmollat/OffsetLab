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
        front: "20x8.5 +35",
        rear: "20x8.5 +35",
        tire: "235/35R20",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Clean daily setup", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+7mm", "+7mm", "-1mm", "-1mm", "+0.3%", 4, 9, "Low", "Clean OEM+ fitment with minimal compromise.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+18mm", "+18mm", "-8mm", "-8mm", "+0.5%", 7, 8, "Low / Moderate", "Strong daily fitment that fills the car out properly.", ["Watch front clearance on lower ride heights"], "20x9 +30 / 245-255/35R20"),
        aggressive: p("Aggressive Setup", "Wider stance", "20x9 +26", "20x10.5 +38", "245/35R20", "285/30R20", "+22mm", "+28mm", "-6mm", "-10mm", "+0.8%", 8, 7, "Moderate", "Strong aggressive stance with manageable clearance.", ["Front clearance tighter at full lock", "Lowered setups may require camber awareness"], "19x9.5 +25 square / 275/35R19"),
      },
    },
  ],

  "Model Y": [
    {
      trim: "Long Range",
      baseline: {
        front: "19x9.5 +45",
        rear: "19x9.5 +45",
        tire: "255/45R19",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Clean daily setup", "20x9.5 +40", "20x9.5 +40", "255/40R20", "255/40R20", "+5mm", "+5mm", "-5mm", "-5mm", "-0.1%", 4, 9, "Low", "Clean OEM+ option for the Model Y.", low, "20x10 +40 / 265/40R20"),
        flush: p("Flush Setup", "Filled-out stance", "20x10 +35", "20x10 +35", "275/40R20", "275/40R20", "+16mm", "+16mm", "-10mm", "-10mm", "+0.7%", 7, 8, "Low / Moderate", "A strong flush setup that looks right on the Model Y.", ["Tighter on lowered Ys"], "21x9.5 +40 / 265/35R21"),
        aggressive: p("Aggressive Setup", "Wider stance", "21x9.5 +30", "21x10.5 +40", "265/35R21", "295/35R21", "+20mm", "+24mm", "-5mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive SUV fitment with strong visual presence.", ["Rear width gets serious fast", "Watch liner clearance on low ride heights"], "20x10 +30 square / 275/40R20"),
      },
    },
  ],

  "Model S": [
    {
      trim: "Plaid",
      baseline: {
        front: "21x9.5 +40",
        rear: "21x10.5 +45",
        tire: "265/35R21 / 295/30R21",
        boltPattern: "5x120",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock", "21x9.5 +38", "21x10.5 +42", "265/35R21", "295/30R21", "+2mm", "+3mm", "-2mm", "-3mm", "0.0%", 4, 9, "Low", "Minimal-compromise Plaid fitment.", low, "20x10 +38 / 275/35R20"),
        flush: p("Flush Setup", "Sharper stance", "21x9.5 +35", "21x10.5 +40", "275/35R21", "295/30R21", "+5mm", "+5mm", "-5mm", "-5mm", "+0.5%", 7, 8, "Low / Moderate", "Nicely filled out without overdoing it.", ["Front tire width gets more serious"], "21x10 +35 square / 275/35R21"),
        aggressive: p("Aggressive Setup", "Sharper stance", "21x10 +30", "21x11 +38", "275/35R21", "305/30R21", "+16mm", "+14mm", "-4mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive Plaid fitment with stronger visual muscle.", ["Rear width needs attention"], "20x10 +30 / 285/35R20"),
      },
    },
  ],

  "Model X": [
    {
      trim: "Plaid",
      baseline: {
        front: "22x9.5 +35",
        rear: "22x10.5 +40",
        tire: "265/35R22 / 285/35R22",
        boltPattern: "5x120",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Clean SUV fitment", "22x9.5 +33", "22x10.5 +38", "265/35R22", "295/35R22", "+2mm", "+2mm", "-2mm", "-2mm", "+0.5%", 4, 9, "Low", "Minimal compromise OEM+ move.", low, "20x10 +35 / 275/40R20"),
        flush: p("Flush Setup", "Balanced SUV stance", "22x10 +30", "22x11 +35", "275/35R22", "305/30R22", "+11mm", "+17mm", "-1mm", "-3mm", "+0.7%", 7, 8, "Low / Moderate", "Strong flush fitment for the Plaid X.", ["Wide rear setup adds seriousness fast"], "22x10 +32 square / 285/35R22"),
        aggressive: p("Aggressive Setup", "More presence", "22x10.5 +28", "22x11.5 +30", "285/35R22", "315/30R22", "+19mm", "+23mm", "-7mm", "-5mm", "+0.9%", 8, 7, "Moderate", "Aggressive Plaid X fitment with strong visual impact.", ["Best with careful suspension setup"], "22x10 +30 / 285/35R22"),
      },
    },
  ],

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
        oemplus: p("OEM+ Daily", "Factory-engineered performance fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus G80 fitment.", low, "19x10 ET20 / 20x11 ET20"),
        flush: p("Flush Street", "Clean street upgrade", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Ideal street fitment for G80.", ["Lowered cars should monitor front liner clearance"], "20x10 ET18 / 20x11 ET18"),
        aggressive: p("Aggressive Performance", "Maxed-out street stance", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Aggressive G80 fitment with a wide, planted look.", ["May require slight camber"], "20x10 ET15 / 20x11 ET12"),
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
        oemplus: p("OEM+ Daily", "Factory-engineered performance fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus G82 fitment.", low, "19x10 ET20 / 20x11 ET20"),
        flush: p("Flush Street", "Clean street stance", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Clean flush G82 fitment.", ["Lowered cars should monitor clearance"], "20x10 ET18 / 20x11 ET18"),
        aggressive: p("Aggressive Performance", "Maxed-out street stance", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Aggressive M4 fitment with wide stance.", ["May require slight camber"], "20x10 ET15 / 20x11 ET12"),
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
        oemplus: p("OEM+ Setup", "Clean daily upgrade", "18x8 +40", "18x8 +40", "225/40R18", "225/40R18", "+8mm", "+8mm", "-3mm", "-3mm", "+0.2%", 4, 9, "Low", "Perfect OEM+ GR86 fitment.", low, "18x8.5 +40 / 235/40R18"),
        flush: p("Flush Setup", "Balanced stance", "18x9 +38", "18x9 +38", "245/35R18", "245/35R18", "+18mm", "+18mm", "-6mm", "-6mm", "+0.3%", 7, 8, "Low", "Ideal flush GR86 setup.", ["Watch front clearance if lowered"], "17x9 +38"),
        aggressive: p("Aggressive Setup", "Wider stance", "18x9.5 +35", "18x9.5 +35", "255/35R18", "255/35R18", "+25mm", "+25mm", "-8mm", "-8mm", "+0.5%", 8, 7, "Moderate", "Aggressive GR86 fitment.", ["May need camber"], "18x10 +35"),
      },
    },
  ],
};

export const makeModelOptions: Record<MakeKey, ModelKey[]> = {
  Tesla: ["Model 3", "Model Y", "Model S", "Model X"],
  BMW: ["M3", "M4"],
  Toyota: ["GR86"],
  Porsche: [],
};

export const modelOptions = Object.keys(fitmentData) as ModelKey[];

export function getModelsForMake(make: MakeKey): ModelKey[] {
  return makeModelOptions[make] ?? [];
}

export function getDefaultModelForMake(make: MakeKey): ModelKey {
  return getModelsForMake(make)[0] ?? "Model 3";
}

export function getTrims(model: ModelKey): string[] {
  return fitmentData[model].map((entry) => entry.trim);
}

export function getTrimData(model: ModelKey, trim: string): TrimData {
  return fitmentData[model].find((entry) => entry.trim === trim) ?? fitmentData[model][0];
}

export function modelSlug(model: ModelKey): string {
  return model.toLowerCase().replace(/\s+/g, "-");
}

export function normalizeModel(value: string | null, make: MakeKey = "Tesla"): ModelKey {
  const input = (value || "").toLowerCase().replace(/[-_]/g, " ").trim();

  if (make === "Toyota") {
    if (input.includes("gr86")) return "GR86";
    return "GR86";
  }

  if (make === "BMW") {
    if (input === "m4") return "M4";
    return "M3";
  }

  if (input === "model y" || input === "modely") return "Model Y";
  if (input === "model s" || input === "models") return "Model S";
  if (input === "model x" || input === "modelx") return "Model X";
  return "Model 3";
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
  if (input === "porsche") return "Porsche";
  return "Tesla";
}
