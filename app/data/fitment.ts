export type MakeKey = "Tesla" | "BMW" | "Toyota" | "Porsche";
export type StyleKey = "oemplus" | "flush" | "aggressive";
export type ModelKey =
  | "Model 3"
  | "Model Y"
  | "Model S"
  | "Model X"
  | "M3"
  | "M4";

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

export const makes: { label: MakeKey; active: boolean }[] = [
  { label: "Tesla", active: true },
  { label: "BMW", active: true },
  { label: "Toyota", active: false },
  { label: "Porsche", active: false },
];

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

export const fitmentData: Record<ModelKey, TrimData[]> = {
  "Model 3": [
    {
      trim: "Performance",
      baseline: { front: "20x9 +34", rear: "20x9 +34", tire: "235/35R20", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade with near-stock drivability", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+7mm", "+7mm", "-1mm", "-1mm", "+0.3%", 4, 9, "Low", "Clean OEM+ fitment with minimal compromise. Great for a daily-driven Model 3 Performance.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Daily Setup", "Balanced stance with strong daily usability", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+18mm", "+18mm", "-8mm", "-8mm", "+0.5%", 7, 8, "Low / Moderate", "Strong daily fitment that fills the car out properly without going overboard.", ["Watch front clearance on lower ride heights"], "20x9 +30 / 245-255/35R20"),
        aggressive: p("Aggressive Daily Setup", "Wider stance with tighter fitment", "20x9 +25", "20x10.5 +38", "245/35R20", "285/30R20", "+22mm", "+28mm", "-6mm", "-10mm", "+0.8%", 8, 7, "Moderate", "Strong aggressive stance with manageable clearance. Ideal for coilovers or mild drop.", ["Front clearance tighter at full lock", "Lowered setups may require slight camber awareness"], "19x9.5 +25 square / 275/35R19"),
      },
    },
    {
      trim: "Long Range AWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock, cleaner and sharper", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "OEM+ setup that tightens up the look without creating unnecessary tradeoffs.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Daily Setup", "Balanced, properly filled out fitment", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "A strong flush setup for the Long Range that still works as a daily.", ["Lowered cars should monitor front clearance"], "20x9 +30 / 255/35R20"),
        aggressive: p("Aggressive Daily Setup", "Sharper stance, tighter clearances", "20x9 +25", "20x10.5 +38", "245/35R20", "285/30R20", "+26mm", "+34mm", "-6mm", "-11mm", "+0.8%", 8, 7, "Moderate", "Aggressive enthusiast fitment with strong visual impact and manageable risk.", mod, "19x9.5 +25 square / 275/35R19"),
      },
    },
    {
      trim: "RWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade with near-stock drivability", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "Clean OEM+ fitment with minimal compromise for a daily-driven Model 3 RWD.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Daily Setup", "Balanced stance with strong daily usability", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "Fills the car out properly while staying daily-friendly on most stock-height cars.", ["Watch front clearance on lower ride heights"], "20x9 +30 / 245-255/35R20"),
        aggressive: p("Aggressive Daily Setup", "Wider stance with tighter fitment", "20x9 +25", "20x10 +35", "245/35R20", "275/30R20", "+26mm", "+31mm", "-6mm", "-8mm", "+0.5%", 8, 7, "Moderate", "Strong aggressive stance for a Model 3 RWD with manageable compromise.", mod, "19x9.5 +25 square / 275/35R19"),
      },
    },
  ],
  "Model Y": [
    {
      trim: "Performance",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +48", tire: "255/35R21 / 275/35R21", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock, cleaner and easier to live with", "20x9.5 +40", "20x10.5 +45", "265/40R20", "285/40R20", "+0mm", "+3mm", "-0mm", "-3mm", "+0.5%", 4, 9, "Low", "Great OEM+ move for a Performance Y if you want a cleaner, more practical setup.", low, "21x9.5 +38 / 265/35R21"),
        flush: p("Flush Daily Setup", "Balanced stance for daily use", "21x9.5 +35", "21x10.5 +42", "265/35R21", "295/35R21", "+5mm", "+6mm", "-5mm", "-6mm", "+0.9%", 7, 8, "Low / Moderate", "Flush fitment with more authority while keeping daily usability intact.", ["Wider rear tire adds bulk quickly"], "20x10 +35 square / 275/40R20"),
        aggressive: p("Aggressive Daily Setup", "Sharper fitment with more stance", "21x9.5 +30", "21x10.5 +38", "275/35R21", "295/35R21", "+10mm", "+10mm", "-10mm", "-10mm", "+1.0%", 8, 7, "Moderate", "Aggressive Performance Y fitment that hits visually without going full stance car.", ["Front tire width gets tighter", "Best with careful ride-height setup"], "20x10 +30 / 275/40R20"),
      },
    },
    {
      trim: "Long Range AWD",
      baseline: { front: "19x9.5 +45", rear: "19x9.5 +45", tire: "255/45R19", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Subtle improvement over stock fitment", "20x9.5 +40", "20x9.5 +40", "255/40R20", "255/40R20", "+5mm", "+5mm", "-5mm", "-5mm", "-0.1%", 4, 9, "Low", "Clean OEM+ option for the Model Y with minimal compromise.", low, "20x10 +40 / 265/40R20"),
        flush: p("Flush Daily Setup", "Filled-out daily-friendly fitment", "20x10 +35", "20x10 +35", "275/40R20", "275/40R20", "+16mm", "+16mm", "-10mm", "-10mm", "+0.7%", 7, 8, "Low / Moderate", "A strong flush setup that looks right on the Model Y without pushing too far.", ["Tighter on lowered Ys"], "21x9.5 +40 / 265/35R21"),
        aggressive: p("Aggressive Daily Setup", "Wider, more planted stance", "21x9.5 +30", "21x10.5 +40", "265/35R21", "295/35R21", "+20mm", "+24mm", "-5mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive SUV fitment with strong visual presence and good daily usability if dialed in.", ["Rear width gets serious fast", "Watch liner clearance on low ride heights"], "20x10 +30 square / 275/40R20"),
      },
    },
  ],
  "Model S": [
    {
      trim: "Plaid",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +45", tire: "265/35R21 / 295/30R21", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock with a cleaner edge", "21x9.5 +38", "21x10.5 +42", "265/35R21", "295/30R21", "+2mm", "+3mm", "-2mm", "-3mm", "0.0%", 4, 9, "Low", "Minimal-compromise Plaid fitment that just tightens the stance a touch.", low, "20x10 +38 / 275/35R20"),
        flush: p("Flush Daily Setup", "Sharper flush setup for Plaid owners", "21x9.5 +35", "21x10.5 +40", "275/35R21", "295/30R21", "+5mm", "+5mm", "-5mm", "-5mm", "+0.5%", 7, 8, "Low / Moderate", "Nicely filled out without overdoing it for a high-performance sedan.", ["Front tire width gets more serious"], "21x10 +35 square / 275/35R21"),
        aggressive: p("Aggressive Daily Setup", "Sharper stance, tighter envelope", "21x10 +30", "21x11 +38", "275/35R21", "305/30R21", "+16mm", "+14mm", "-4mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive Plaid fitment with stronger visual muscle and still realistic daily usability.", ["Rear width needs attention", "Not the setup for conservative owners"], "20x10 +30 / 285/35R20"),
      },
    },
    {
      trim: "Long Range",
      baseline: { front: "19x8.5 +35", rear: "19x9.5 +40", tire: "245/45R19 / 265/45R19", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Subtle OEM-adjacent improvement", "20x9 +35", "20x10 +40", "245/40R20", "285/35R20", "+6mm", "+6mm", "-6mm", "-6mm", "+0.4%", 4, 9, "Low", "OEM+ option that keeps the Model S elegant while sharpening the stance.", low, "21x9 +35 / 255/35R21"),
        flush: p("Flush Daily Setup", "Balanced luxury-performance stance", "21x9 +30", "21x10.5 +35", "255/35R21", "295/30R21", "+11mm", "+18mm", "-1mm", "-8mm", "+0.2%", 7, 8, "Low / Moderate", "A properly filled-out Model S setup with strong visual balance.", ["Rear width adds inner tightness"], "20x9.5 +30 / 265/35R20"),
        aggressive: p("Aggressive Daily Setup", "More visual impact with tighter fitment", "21x9.5 +28", "21x10.5 +30", "265/35R21", "295/30R21", "+18mm", "+23mm", "-8mm", "-3mm", "+0.7%", 8, 7, "Moderate", "Aggressive daily fitment for Model S owners who want more presence without full compromise.", mod, "20x10 +30 / 275/35R20"),
      },
    },
  ],
  "Model X": [
    {
      trim: "Plaid",
      baseline: { front: "22x9.5 +35", rear: "22x10.5 +40", tire: "265/35R22 / 285/35R22", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Tight, clean Plaid SUV fitment", "22x9.5 +33", "22x10.5 +38", "265/35R22", "295/35R22", "+2mm", "+2mm", "-2mm", "-2mm", "+0.5%", 4, 9, "Low", "Minimal compromise OEM+ move for owners who want just a touch more stance.", low, "20x10 +35 / 275/40R20"),
        flush: p("Flush Daily Setup", "Balanced daily fitment for a heavy performance SUV", "22x10 +30", "22x11 +35", "275/35R22", "305/30R22", "+11mm", "+17mm", "-1mm", "-3mm", "+0.7%", 7, 8, "Low / Moderate", "Strong flush fitment for the Plaid X with a premium, planted look.", ["Wide rear setup adds seriousness fast"], "22x10 +32 square / 285/35R22"),
        aggressive: p("Aggressive Daily Setup", "More stance, more presence, tighter package", "22x10.5 +28", "22x11.5 +30", "285/35R22", "315/30R22", "+19mm", "+23mm", "-7mm", "-5mm", "+0.9%", 8, 7, "Moderate", "Aggressive Plaid X fitment with strong visual impact and real presence.", ["Front width is not conservative", "Best with careful suspension setup"], "22x10 +30 / 285/35R22"),
      },
    },
    {
      trim: "Long Range",
      baseline: { front: "20x9 +35", rear: "20x10 +35", tire: "265/45R20 / 275/45R20", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Slightly sharper SUV fitment", "20x9.5 +35", "20x10.5 +35", "265/45R20", "285/40R20", "+6mm", "+6mm", "-6mm", "-6mm", "+0.2%", 4, 9, "Low", "OEM+ Model X setup that keeps things practical while tightening the look.", low, "22x9.5 +35 / 265/35R22"),
        flush: p("Flush Daily Setup", "Balanced premium SUV stance", "22x9.5 +30", "22x10.5 +32", "265/35R22", "285/35R22", "+11mm", "+16mm", "-1mm", "-3mm", "+0.6%", 7, 8, "Low / Moderate", "A strong flush stance that works well on the Model X platform.", ["Rear gets tighter on low ride heights"], "20x10 +30 square / 275/40R20"),
        aggressive: p("Aggressive Daily Setup", "Bigger visual impact, tighter clearances", "22x10 +28", "22x11 +30", "275/35R22", "305/30R22", "+17mm", "+20mm", "-7mm", "-7mm", "+0.8%", 8, 7, "Moderate", "Aggressive Model X fitment that looks right when done with intention.", mod, "22x10 +30 / 285/35R22"),
      },
    },
  ],
  "M3": [
    {
      trim: "G80 M3",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "Factory-engineered performance fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus G80 fitment. Strong from the factory, daily-friendly, and low risk.", ["Very low rub risk", "Best choice for simple daily fitment"], "19x10 ET20 / 20x11 ET20 with 275/35R19 / 295/30R20"),
        flush: p("Flush Street", "Most popular clean street upgrade for G8X", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Ideal street fitment for G80/G82/G83. Fills the arches properly while keeping the car usable.", ["Lowered cars should monitor front liner clearance"], "20x10 ET18 / 20x11 ET18 with 285/30R20 / 305/30R20"),
        aggressive: p("Aggressive Performance", "Maxed-out street stance with stronger presence", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Aggressive G8X fitment with a wide, planted look. Best with proper ride height and alignment.", ["May require slight camber depending on ride height", "Not the conservative option"], "20x10 ET15 / 20x11 ET12 with 285/30R20 / 305/30R20"),
      },
    },
  ],
  "M4": [
    {
      trim: "G82 M4",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "Factory-engineered performance fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus G82 fitment. Clean, proven, and daily-friendly.", ["Very low rub risk", "Best choice for simple daily fitment"], "19x10 ET20 / 20x11 ET20 with 275/35R19 / 295/30R20"),
        flush: p("Flush Street", "Most popular clean street upgrade for G8X", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Clean flush G82 fitment with strong visual impact and realistic daily usability.", ["Lowered cars should monitor front liner clearance"], "20x10 ET18 / 20x11 ET18 with 285/30R20 / 305/30R20"),
        aggressive: p("Aggressive Performance", "Maxed-out street stance with stronger presence", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Aggressive M4 fitment with wide stance and strong wheel presence.", ["May require slight camber depending on ride height", "Not the conservative option"], "20x10 ET15 / 20x11 ET12 with 285/30R20 / 305/30R20"),
      },
    },
    {
      trim: "G83 M4 Convertible",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "Factory-engineered performance fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus G83 fitment. Clean, refined, and low-risk.", ["Very low rub risk", "Good for daily driving"], "19x10 ET20 / 20x11 ET20 with 275/35R19 / 295/30R20"),
        flush: p("Flush Street", "Clean street stance for the convertible G8X", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Strong G83 street fitment with clean flush stance and daily usability.", ["Lowered cars should monitor clearance"], "20x10 ET18 / 20x11 ET18 with 285/30R20 / 305/30R20"),
        aggressive: p("Aggressive Performance", "Maxed-out street stance with stronger presence", "20x10 ET12", "20x11 ET12", "285/30R20", "305/30R20", "+14mm", "+14mm", "+2mm", "+2mm", "+0.3%", 9, 7, "Moderate", "Aggressive convertible G8X fitment with strong visual presence.", ["May require slight camber depending on ride height", "Best with dialed suspension"], "20x10 ET15 / 20x11 ET12 with 285/30R20 / 305/30R20"),
      },
    },
  ],
};

export const makeModelOptions: Record<MakeKey, ModelKey[]> = {
  Tesla: ["Model 3", "Model Y", "Model S", "Model X"],
  BMW: ["M3", "M4"],
  Toyota: [],
  Porsche: [],
};

export const modelOptions = Object.keys(fitmentData) as ModelKey[];

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

export function normalizeModel(value: string | null, make: MakeKey = "Tesla"): ModelKey {
  const input = (value || "").toLowerCase().replace(/[-_]/g, " ").trim();

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
