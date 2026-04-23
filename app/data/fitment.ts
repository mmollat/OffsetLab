export type MakeKey = "Tesla" | "BMW" | "Toyota" | "Porsche";
export type StyleKey = "oemplus" | "flush" | "aggressive";
export type ModelKey = "Model 3" | "Model Y" | "Model S" | "Model X";

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

const baseWarnings = {
  low: ["Very low rub risk", "Good daily setup"],
  moderate: ["Ride height matters", "Check clearance if lowered"],
};

export const makes: { label: MakeKey; active: boolean }[] = [
  { label: "Tesla", active: true },
  { label: "BMW", active: false },
  { label: "Toyota", active: false },
  { label: "Porsche", active: false },
];

export const fitmentData: Record<ModelKey, TrimData[]> = {
  "Model 3": [
    {
      trim: "RWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Clean upgrade with near-stock drivability", front: "19x8.5 +35", rear: "19x8.5 +35", frontTire: "245/40R19", rearTire: "245/40R19", pokeFront: "+11mm", pokeRear: "+11mm", innerFront: "-1mm", innerRear: "-1mm", diameter: "+0.8%", aggression: 4, daily: 9, risk: "Low", verdict: "Clean OEM+ fitment with minimal compromise for a daily-driven Model 3 RWD.", warnings: baseWarnings.low, alternate: "19x9 +35 / 255/40R19" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced stance with strong daily usability", front: "19x9.5 +30", rear: "19x9.5 +30", frontTire: "265/35R19", rearTire: "265/35R19", pokeFront: "+22mm", pokeRear: "+22mm", innerFront: "-10mm", innerRear: "-10mm", diameter: "+0.2%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "Fills the car out properly while staying daily-friendly on most stock-height cars.", warnings: ["Watch front clearance on lower ride heights"], alternate: "20x9 +30 / 245-255/35R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Wider stance with tighter fitment", front: "20x9 +25", rear: "20x10 +35", frontTire: "245/35R20", rearTire: "275/30R20", pokeFront: "+26mm", pokeRear: "+31mm", innerFront: "-6mm", innerRear: "-8mm", diameter: "+0.5%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Strong aggressive stance for a Model 3 RWD with manageable compromise.", warnings: ["Front clearance tighter at full lock", "Best with proper ride-height management"], alternate: "19x9.5 +25 square / 275/35R19" },
      },
    },
    {
      trim: "Long Range AWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Close to stock, cleaner and sharper", front: "19x8.5 +35", rear: "19x8.5 +35", frontTire: "245/40R19", rearTire: "245/40R19", pokeFront: "+11mm", pokeRear: "+11mm", innerFront: "-1mm", innerRear: "-1mm", diameter: "+0.8%", aggression: 4, daily: 9, risk: "Low", verdict: "OEM+ setup that tightens up the look without creating unnecessary tradeoffs.", warnings: baseWarnings.low, alternate: "19x9 +35 / 255/40R19" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced, properly filled out fitment", front: "19x9.5 +30", rear: "19x9.5 +30", frontTire: "265/35R19", rearTire: "265/35R19", pokeFront: "+22mm", pokeRear: "+22mm", innerFront: "-10mm", innerRear: "-10mm", diameter: "+0.2%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "A strong flush setup for the Long Range that still works as a daily.", warnings: ["Lowered cars should monitor front clearance"], alternate: "20x9 +30 / 255/35R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Sharper stance, tighter clearances", front: "20x9 +25", rear: "20x10.5 +38", frontTire: "245/35R20", rearTire: "285/30R20", pokeFront: "+26mm", pokeRear: "+34mm", innerFront: "-6mm", innerRear: "-11mm", diameter: "+0.8%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive enthusiast fitment with strong visual impact and manageable risk.", warnings: ["Ride height matters", "Rear fitment tighter on lowered setups"], alternate: "19x9.5 +25 square / 275/35R19" },
      },
    },
    {
      trim: "Performance",
      baseline: { front: "20x9 +34", rear: "20x9 +34", tire: "235/35R20", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Clean upgrade with near-stock drivability", front: "19x8.5 +35", rear: "19x8.5 +35", frontTire: "245/40R19", rearTire: "245/40R19", pokeFront: "+7mm", pokeRear: "+7mm", innerFront: "-1mm", innerRear: "-1mm", diameter: "+0.3%", aggression: 4, daily: 9, risk: "Low", verdict: "Clean OEM+ fitment with minimal compromise. Great for a daily-driven Model 3 Performance.", warnings: baseWarnings.low, alternate: "19x9 +35 / 255/40R19" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced stance with strong daily usability", front: "19x9.5 +30", rear: "19x9.5 +30", frontTire: "265/35R19", rearTire: "265/35R19", pokeFront: "+18mm", pokeRear: "+18mm", innerFront: "-8mm", innerRear: "-8mm", diameter: "+0.5%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "Strong daily fitment that fills the car out properly without going overboard.", warnings: ["Watch front clearance on lower ride heights"], alternate: "20x9 +30 / 245-255/35R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Wider stance with tighter fitment", front: "20x9 +25", rear: "20x10.5 +38", frontTire: "245/35R20", rearTire: "285/30R20", pokeFront: "+22mm", pokeRear: "+28mm", innerFront: "-6mm", innerRear: "-10mm", diameter: "+0.8%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Strong aggressive stance with manageable clearance. Ideal for coilovers or mild drop.", warnings: ["Front clearance tighter at full lock", "Lowered setups may require slight camber awareness"], alternate: "19x9.5 +25 square / 275/35R19" },
      },
    },
  ],
  "Model Y": [
    {
      trim: "Long Range AWD",
      baseline: { front: "19x9.5 +45", rear: "19x9.5 +45", tire: "255/45R19", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Subtle improvement over stock fitment", front: "20x9.5 +40", rear: "20x9.5 +40", frontTire: "255/40R20", rearTire: "255/40R20", pokeFront: "+5mm", pokeRear: "+5mm", innerFront: "-5mm", innerRear: "-5mm", diameter: "-0.1%", aggression: 4, daily: 9, risk: "Low", verdict: "Clean OEM+ option for the Model Y with minimal compromise.", warnings: baseWarnings.low, alternate: "20x10 +40 / 265/40R20" },
        flush: { title: "Flush Daily Setup", subtitle: "Filled-out daily-friendly fitment", front: "20x10 +35", rear: "20x10 +35", frontTire: "275/40R20", rearTire: "275/40R20", pokeFront: "+16mm", pokeRear: "+16mm", innerFront: "-10mm", innerRear: "-10mm", diameter: "+0.7%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "A strong flush setup that looks right on the Model Y without pushing too far.", warnings: ["Tighter on lowered Ys"], alternate: "21x9.5 +40 / 265/35R21" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Wider, more planted stance", front: "21x9.5 +30", rear: "21x10.5 +40", frontTire: "265/35R21", rearTire: "295/35R21", pokeFront: "+20mm", pokeRear: "+24mm", innerFront: "-5mm", innerRear: "-8mm", diameter: "+0.9%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive SUV fitment with strong visual presence and good daily usability if dialed in.", warnings: ["Rear width gets serious fast", "Watch liner clearance on low ride heights"], alternate: "20x10 +30 square / 275/40R20" },
      },
    },
    {
      trim: "Performance",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +48", tire: "255/35R21 / 275/35R21", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Close to stock, cleaner and easier to live with", front: "20x9.5 +40", rear: "20x10.5 +45", frontTire: "265/40R20", rearTire: "285/40R20", pokeFront: "+0mm", pokeRear: "+3mm", innerFront: "-0mm", innerRear: "-3mm", diameter: "+0.5%", aggression: 4, daily: 9, risk: "Low", verdict: "Great OEM+ move for a Performance Y if you want a cleaner, more practical setup.", warnings: baseWarnings.low, alternate: "21x9.5 +38 / 265/35R21" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced stance for daily use", front: "21x9.5 +35", rear: "21x10.5 +42", frontTire: "265/35R21", rearTire: "295/35R21", pokeFront: "+5mm", pokeRear: "+6mm", innerFront: "-5mm", innerRear: "-6mm", diameter: "+0.9%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "Flush fitment with more authority while keeping daily usability intact.", warnings: ["Wider rear tire adds bulk quickly"], alternate: "20x10 +35 square / 275/40R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Sharper fitment with more stance", front: "21x9.5 +30", rear: "21x10.5 +38", frontTire: "275/35R21", rearTire: "295/35R21", pokeFront: "+10mm", pokeRear: "+10mm", innerFront: "-10mm", innerRear: "-10mm", diameter: "+1.0%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive Performance Y fitment that hits visually without going full stance car.", warnings: ["Front tire width gets tighter", "Best with careful ride-height setup"], alternate: "20x10 +30 / 275/40R20" },
      },
    },
  ],
  "Model S": [
    {
      trim: "Long Range",
      baseline: { front: "19x8.5 +35", rear: "19x9.5 +40", tire: "245/45R19 / 265/45R19", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Subtle OEM-adjacent improvement", front: "20x9 +35", rear: "20x10 +40", frontTire: "245/40R20", rearTire: "285/35R20", pokeFront: "+6mm", pokeRear: "+6mm", innerFront: "-6mm", innerRear: "-6mm", diameter: "+0.4%", aggression: 4, daily: 9, risk: "Low", verdict: "OEM+ option that keeps the Model S elegant while sharpening the stance.", warnings: baseWarnings.low, alternate: "21x9 +35 / 255/35R21" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced luxury-performance stance", front: "21x9 +30", rear: "21x10.5 +35", frontTire: "255/35R21", rearTire: "295/30R21", pokeFront: "+11mm", pokeRear: "+18mm", innerFront: "-1mm", innerRear: "-8mm", diameter: "+0.2%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "A properly filled-out Model S setup with strong visual balance.", warnings: ["Rear width adds inner tightness"], alternate: "20x9.5 +30 / 265/35R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "More visual impact with tighter fitment", front: "21x9.5 +28", rear: "21x10.5 +30", frontTire: "265/35R21", rearTire: "295/30R21", pokeFront: "+18mm", pokeRear: "+23mm", innerFront: "-8mm", innerRear: "-3mm", diameter: "+0.7%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive daily fitment for Model S owners who want more presence without full compromise.", warnings: ["Front width pushes harder", "Best when suspension is dialed in"], alternate: "20x10 +30 / 275/35R20" },
      },
    },
    {
      trim: "Plaid",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +45", tire: "265/35R21 / 295/30R21", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Close to stock with a cleaner edge", front: "21x9.5 +38", rear: "21x10.5 +42", frontTire: "265/35R21", rearTire: "295/30R21", pokeFront: "+2mm", pokeRear: "+3mm", innerFront: "-2mm", innerRear: "-3mm", diameter: "0.0%", aggression: 4, daily: 9, risk: "Low", verdict: "Minimal-compromise Plaid fitment that just tightens the stance a touch.", warnings: baseWarnings.low, alternate: "20x10 +38 / 275/35R20" },
        flush: { title: "Flush Daily Setup", subtitle: "Sharper flush setup for Plaid owners", front: "21x9.5 +35", rear: "21x10.5 +40", frontTire: "275/35R21", rearTire: "295/30R21", pokeFront: "+5mm", pokeRear: "+5mm", innerFront: "-5mm", innerRear: "-5mm", diameter: "+0.5%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "Nicely filled out without overdoing it for a high-performance sedan.", warnings: ["Front tire width gets more serious"], alternate: "21x10 +35 square / 275/35R21" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Sharper stance, tighter envelope", front: "21x10 +30", rear: "21x11 +38", frontTire: "275/35R21", rearTire: "305/30R21", pokeFront: "+16mm", pokeRear: "+14mm", innerFront: "-4mm", innerRear: "-8mm", diameter: "+0.9%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive Plaid fitment with stronger visual muscle and still realistic daily usability.", warnings: ["Rear width needs attention", "Not the setup for conservative owners"], alternate: "20x10 +30 / 285/35R20" },
      },
    },
  ],
  "Model X": [
    {
      trim: "Long Range",
      baseline: { front: "20x9 +35", rear: "20x10 +35", tire: "265/45R20 / 275/45R20", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Slightly sharper SUV fitment", front: "20x9.5 +35", rear: "20x10.5 +35", frontTire: "265/45R20", rearTire: "285/40R20", pokeFront: "+6mm", pokeRear: "+6mm", innerFront: "-6mm", innerRear: "-6mm", diameter: "+0.2%", aggression: 4, daily: 9, risk: "Low", verdict: "OEM+ Model X setup that keeps things practical while tightening the look.", warnings: baseWarnings.low, alternate: "22x9.5 +35 / 265/35R22" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced premium SUV stance", front: "22x9.5 +30", rear: "22x10.5 +32", frontTire: "265/35R22", rearTire: "285/35R22", pokeFront: "+11mm", pokeRear: "+16mm", innerFront: "-1mm", innerRear: "-3mm", diameter: "+0.6%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "A strong flush stance that works well on the Model X platform.", warnings: ["Rear gets tighter on low ride heights"], alternate: "20x10 +30 square / 275/40R20" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "Bigger visual impact, tighter clearances", front: "22x10 +28", rear: "22x11 +30", frontTire: "275/35R22", rearTire: "305/30R22", pokeFront: "+17mm", pokeRear: "+20mm", innerFront: "-7mm", innerRear: "-7mm", diameter: "+0.8%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive Model X fitment that looks right when done with intention.", warnings: ["Front width pushes fitment harder", "Best with proper alignment"], alternate: "22x10 +30 / 285/35R22" },
      },
    },
    {
      trim: "Plaid",
      baseline: { front: "22x9.5 +35", rear: "22x10.5 +40", tire: "265/35R22 / 285/35R22", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: { title: "OEM+ Setup", subtitle: "Tight, clean Plaid SUV fitment", front: "22x9.5 +33", rear: "22x10.5 +38", frontTire: "265/35R22", rearTire: "295/35R22", pokeFront: "+2mm", pokeRear: "+2mm", innerFront: "-2mm", innerRear: "-2mm", diameter: "+0.5%", aggression: 4, daily: 9, risk: "Low", verdict: "Minimal compromise OEM+ move for owners who want just a touch more stance.", warnings: baseWarnings.low, alternate: "20x10 +35 / 275/40R20" },
        flush: { title: "Flush Daily Setup", subtitle: "Balanced daily fitment for a heavy performance SUV", front: "22x10 +30", rear: "22x11 +35", frontTire: "275/35R22", rearTire: "305/30R22", pokeFront: "+11mm", pokeRear: "+17mm", innerFront: "-1mm", innerRear: "-3mm", diameter: "+0.7%", aggression: 7, daily: 8, risk: "Low / Moderate", verdict: "Strong flush fitment for the Plaid X with a premium, planted look.", warnings: ["Wide rear setup adds seriousness fast"], alternate: "22x10 +32 square / 285/35R22" },
        aggressive: { title: "Aggressive Daily Setup", subtitle: "More stance, more presence, tighter package", front: "22x10.5 +28", rear: "22x11.5 +30", frontTire: "285/35R22", rearTire: "315/30R22", pokeFront: "+19mm", pokeRear: "+23mm", innerFront: "-7mm", innerRear: "-5mm", diameter: "+0.9%", aggression: 8, daily: 7, risk: "Moderate", verdict: "Aggressive Plaid X fitment with strong visual impact and real presence.", warnings: ["Front width is not conservative", "Best with careful suspension setup"], alternate: "22x10 +30 / 285/35R22" },
      },
    },
  ],
};

export const modelOptions = Object.keys(fitmentData) as ModelKey[];

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
  const input = (value || "").toLowerCase().replace(/[-_]/g, " ").trim();
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
