export type MakeKey = "Tesla" | "BMW" | "Toyota" | "Porsche" | "Honda";
export type StyleKey = "oemplus" | "flush" | "aggressive";
export type ModelKey =
  | "Model 3"
  | "Model Y"
  | "Model S"
  | "Model X"
  | "M3"
  | "M4"
  | "GR86"
  | "GR Corolla"
  | "Supra"
  | "Civic"
  | "S2000";

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
  { label: "Honda", active: true },
  { label: "Porsche", active: false },
];

export const fitmentData: Record<ModelKey, TrimData[]> = {
  "Model 3": [
    {
      trim: "Performance",
      baseline: { front: "20x9 +34", rear: "20x9 +34", tire: "235/35R20", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean daily setup", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+7mm", "+7mm", "-1mm", "-1mm", "+0.3%", 4, 9, "Low", "Clean, OEM+ daily fitment with minimal compromise..", low, "19x9 +35"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+18mm", "+18mm", "-8mm", "-8mm", "+0.5%", 7, 8, "Low / Moderate", "Balanced flush stance with strong daily usability.", mod, "20x9 +30"),
        aggressive: p("Aggressive Setup", "Wide Stance", "20x9 +26", "20x10.5 +38", "245/35R20", "285/30R20", "+22mm", "+28mm", "-6mm", "-10mm", "+0.8%", 8, 7, "Moderate", "Aggressive fitment with a wide stance. Requires proper setup.", mod, "19x9.5 +25"),
      },
    },
    {
      trim: "Long Range AWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "Clean OEM+ LR setup.", low, "19x9 +35"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "Nice flush daily.", mod, "20x9 +30"),
        aggressive: p("Aggressive Setup", "Wide Stance", "20x9 +25", "20x10.5 +38", "245/35R20", "285/30R20", "+26mm", "+34mm", "-6mm", "-11mm", "+0.8%", 8, 7, "Moderate", "Aggressive LR stance.", mod, "19x9.5 +25"),
      },
    },
    {
      trim: "RWD",
      baseline: { front: "18x8.5 +40", rear: "18x8.5 +40", tire: "235/45R18", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "Perfect OEM+ RWD.", low, "19x9 +35"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "Clean flush RWD.", mod, "20x9 +30"),
        aggressive: p("Aggressive Setup", "Wide Stance", "20x9 +25", "20x10 +35", "245/35R20", "275/30R20", "+26mm", "+31mm", "-6mm", "-8mm", "+0.5%", 8, 7, "Moderate", "Aggressive RWD fitment.", mod, "19x9.5 +25"),
      },
    },
  ],

  "Model Y": [
    {
      trim: "Long Range",
      baseline: { front: "19x9.5 +45", rear: "19x9.5 +45", tire: "255/45R19", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean daily setup", "20x9.5 +40", "20x9.5 +40", "255/40R20", "255/40R20", "+5mm", "+5mm", "-5mm", "-5mm", "-0.1%", 4, 9, "Low", "Clean OEM+ option.", low, "20x10 +40"),
        flush: p("Flush Setup", "Balanced Stance", "20x10 +35", "20x10 +35", "275/40R20", "275/40R20", "+16mm", "+16mm", "-10mm", "-10mm", "+0.7%", 7, 8, "Low / Moderate", "Strong flush setup.", mod, "21x9.5 +40"),
        aggressive: p("Aggressive Setup", "Wide Stance", "21x10 +32", "21x11 +38", "275/35R21", "295/35R21", "+20mm", "+24mm", "-5mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive SUV fitment.", mod, "20x10 +30"),
      },
    },
    {
      trim: "Performance",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +45", tire: "255/35R21 / 275/35R21", boltPattern: "5x114.3", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock", "21x9.5 +38", "21x10.5 +42", "255/35R21", "275/35R21", "+2mm", "+3mm", "-2mm", "-3mm", "0%", 4, 9, "Low", "Minimal compromise.", low, "20x10 +38"),
        flush: p("Flush Setup", "Wide Stance", "21x10 +35", "21x11 +40", "265/35R21", "295/35R21", "+8mm", "+10mm", "-4mm", "-5mm", "+0.5%", 7, 8, "Low / Moderate", "Clean performance flush.", mod, "21x10 +35"),
        aggressive: p("Aggressive Setup", "Wide stance", "21x10.5 +32", "21x11.5 +38", "275/35R21", "295/35R21", "+15mm", "+20mm", "-5mm", "-8mm", "+0.8%", 8, 7, "Moderate", "Aggressive fitment with a wide stance. Requires proper setup.", mod, "20x10 +30"),
      },
    },
  ],

  "Model S": [
    {
      trim: "Plaid",
      baseline: { front: "21x9.5 +40", rear: "21x10.5 +45", tire: "265/35R21 / 295/30R21", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Close to stock", "21x9.5 +38", "21x10.5 +42", "265/35R21", "295/30R21", "+2mm", "+3mm", "-2mm", "-3mm", "0.0%", 4, 9, "Low", "Minimal-compromise Plaid fitment.", low, "20x10 +38"),
        flush: p("Flush Setup", "Wide Stance", "21x9.5 +35", "21x10.5 +40", "275/35R21", "295/30R21", "+5mm", "+5mm", "-5mm", "-5mm", "+0.5%", 7, 8, "Low / Moderate", "Nicely filled out.", mod, "21x10 +35"),
        aggressive: p("Aggressive Setup", "Wide Stance", "21x10 +30", "21x11 +38", "275/35R21", "305/30R21", "+16mm", "+14mm", "-4mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive Plaid fitment.", mod, "20x10 +30"),
      },
    },
    {
      trim: "Long Range",
      baseline: { front: "19x8.5 +35", rear: "19x9.5 +40", tire: "245/45R19 / 265/45R19", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Subtle improvement", "20x9 +35", "20x10 +40", "245/40R20", "285/35R20", "+6mm", "+6mm", "-6mm", "-6mm", "+0.4%", 4, 9, "Low", "OEM+ Model S setup.", low, "21x9 +35"),
        flush: p("Flush Setup", "Balanced stance", "21x9 +30", "21x10.5 +35", "255/35R21", "295/30R21", "+11mm", "+18mm", "-1mm", "-8mm", "+0.2%", 7, 8, "Low / Moderate", "Filled-out Model S setup.", mod, "20x9.5 +30"),
        aggressive: p("Aggressive Setup", "More visual impact", "21x9.5 +28", "21x10.5 +30", "265/35R21", "295/30R21", "+18mm", "+23mm", "-8mm", "-3mm", "+0.7%", 8, 7, "Moderate", "Aggressive daily Model S.", mod, "20x10 +30"),
      },
    },
  ],

  "Model X": [
    {
      trim: "Plaid",
      baseline: { front: "22x9.5 +35", rear: "22x10.5 +40", tire: "265/35R22 / 285/35R22", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean SUV fitment", "22x9.5 +33", "22x10.5 +38", "265/35R22", "295/35R22", "+2mm", "+2mm", "-2mm", "-2mm", "+0.5%", 4, 9, "Low", "Minimal compromise.", low, "20x10 +35"),
        flush: p("Flush Setup", "Balanced SUV stance", "22x10 +30", "22x11 +35", "275/35R22", "305/30R22", "+11mm", "+17mm", "-1mm", "-3mm", "+0.7%", 7, 8, "Low / Moderate", "Strong flush fitment.", mod, "22x10 +32"),
        aggressive: p("Aggressive Setup", "More presence", "22x10.5 +28", "22x11.5 +30", "285/35R22", "315/30R22", "+19mm", "+23mm", "-7mm", "-5mm", "+0.9%", 8, 7, "Moderate", "Aggressive Model X fitment.", mod, "22x10 +30"),
      },
    },
    {
      trim: "Long Range",
      baseline: { front: "20x9 +35", rear: "20x10 +35", tire: "265/45R20 / 275/45R20", boltPattern: "5x120", centerBore: "64.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Slightly sharper SUV fitment", "20x9.5 +35", "20x10.5 +35", "265/45R20", "285/40R20", "+6mm", "+6mm", "-6mm", "-6mm", "+0.2%", 4, 9, "Low", "OEM+ Model X setup.", low, "22x9.5 +35"),
        flush: p("Flush Setup", "Balanced premium SUV stance", "22x9.5 +30", "22x10.5 +32", "265/35R22", "285/35R22", "+11mm", "+16mm", "-1mm", "-3mm", "+0.6%", 7, 8, "Low / Moderate", "Strong flush stance.", mod, "20x10 +30"),
        aggressive: p("Aggressive Setup", "Bigger visual impact", "22x10 +28", "22x11 +30", "275/35R22", "305/30R22", "+17mm", "+20mm", "-7mm", "-7mm", "+0.8%", 8, 7, "Moderate", "Aggressive Model X fitment.", mod, "22x10 +30"),
      },
    },
  ],

  "M3": [
    {
      trim: "G80 M3 (RWD)",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "Factory fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory-plus setup.", low, "19x10 ET20"),
        flush: p("Flush Street", "Clean stance", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Balanced flush setup.", mod, "20x10 ET18"),
        aggressive: p("Aggressive Performance", "Wide stance", "20x10 ET18", "20x11 ET32", "285/30R20", "305/30R20", "+8mm", "+18mm", "-4mm", "-2mm", "+0.3%", 8, 7, "Moderate", "Aggressive but realistic G80/G82 stance. No excessive poke, no camber required.", mod, "20x10 ET20"),
      },
    },
    {
      trim: "G80 M3 Competition xDrive",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "AWD-safe setup", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Safe AWD setup.", low, "20x10 ET20"),
        flush: p("Flush Street", "Balanced AWD stance", "20x10 ET18", "20x11 ET18", "285/30R20", "305/30R20", "+8mm", "+8mm", "-2mm", "-2mm", "+0.3%", 7, 8, "Low / Moderate", "Clean flush AWD.", mod, "20x10 ET20"),
        aggressive: p("Aggressive Performance", "Wide AWD stance", "20x10 ET18", "20x11 ET32", "285/30R20", "305/30R20", "+8mm", "+18mm", "-4mm", "-2mm", "+0.3%", 8, 7, "Moderate", "Aggressive AWD stance.", mod, "20x10 ET18"),
      },
    },
  ],

  "M4": [
    {
      trim: "G82 M4",
      baseline: { front: "19x9.5 ET20", rear: "20x10.5 ET20", tire: "275/35R19 / 285/30R20", boltPattern: "5x112", centerBore: "66.6" },
      presets: {
        oemplus: p("OEM+ Daily", "Factory fitment", "19x9.5 ET20", "20x10.5 ET20", "275/35R19", "285/30R20", "+0mm", "+0mm", "OEM", "OEM", "OEM", 6, 9, "Low", "Factory setup.", low, "19x10 ET20"),
        flush: p("Flush Street", "Clean stance", "20x10 ET15", "20x11 ET15", "285/30R20", "305/30R20", "+11mm", "+11mm", "-1mm", "-1mm", "+0.3%", 8, 8, "Low / Moderate", "Clean flush.", mod, "20x10 ET18"),
        aggressive: p("Aggressive Performance", "Wide stance", "20x10 ET18", "20x11 ET32", "285/30R20", "305/30R20", "+8mm", "+18mm", "-4mm", "-2mm", "+0.3%", 9, 7, "Moderate", "Aggressive fitment with a wide stance. Requires proper setup.", mod, "20x10 ET15"),
      },
    },
  ],

  "GR86": [
    {
      trim: "Base / Premium",
      baseline: { front: "17x7.5 +48", rear: "17x7.5 +48", tire: "215/45R17", boltPattern: "5x100", centerBore: "56.1" },
      presets: {
        oemplus: p("OEM+ Setup", "Clean daily upgrade", "18x8 +40", "18x8 +40", "225/40R18", "225/40R18", "+8mm", "+8mm", "-3mm", "-3mm", "+0.2%", 4, 9, "Low", "Perfect OEM+.", low, "18x8.5 +40"),
        flush: p("Flush Setup", "Balanced stance", "18x9 +38", "18x9 +38", "245/35R18", "245/35R18", "+18mm", "+18mm", "-6mm", "-6mm", "+0.3%", 7, 8, "Low", "Ideal flush.", mod, "17x9 +38"),
        aggressive: p("Aggressive Setup", "Controlled wide stance", "18x9.5 +38", "18x9.5 +38", "255/35R18", "255/35R18", "+22mm", "+22mm", "-5mm", "-5mm", "+0.5%", 8, 7, "Moderate", "Controlled aggressive GR86 fitment with a wide square stance while staying clean and usable.", mod, "18x9.5 +40"),
      },
    },
  ],
  "GR Corolla": [
  {
    trim: "Core / Premium / Circuit",
    baseline: {
      front: "18x8.5 +30",
      rear: "18x8.5 +30",
      tire: "235/40R18",
      boltPattern: "5x114.3",
      centerBore: "60.1",
    },
    presets: {
      oemplus: p(
        "OEM+ Setup",
        "Clean daily upgrade",
        "18x8.5 +28",
        "18x8.5 +28",
        "245/40R18",
        "245/40R18",
        "+4mm",
        "+4mm",
        "-2mm",
        "-2mm",
        "+0.3%",
        4,
        9,
        "Low",
        "Perfect OEM+ GR Corolla setup.",
        low,
        "18x9 +30"
      ),
      flush: p(
        "Flush Setup",
        "Balanced stance",
        "18x9.5 +30",
        "18x9.5 +30",
        "255/35R18",
        "255/35R18",
        "+18mm",
        "+18mm",
        "-6mm",
        "-6mm",
        "+0.2%",
        7,
        8,
        "Low / Moderate",
        "Strong flush fitment.",
        mod,
        "18x9 +28"
      ),
      aggressive: p(
        "Aggressive Setup",
        "Wide stance",
        "18x9.5 +22",
        "18x9.5 +22",
        "265/35R18",
        "265/35R18",
        "+26mm",
        "+26mm",
        "-10mm",
        "-10mm",
        "+0.5%",
        8,
        7,
        "Moderate",
        "Aggressive GR Corolla fitment.",
        mod,
        "18x9.5 +25"
      ),
    },
  },
],

"Supra": [
  {
    trim: "MK5 (A90 / A91)",
    baseline: {
      front: "19x9 +32",
      rear: "19x10 +40",
      tire: "255/35R19 / 275/35R19",
      boltPattern: "5x112",
      centerBore: "66.6",
    },
    presets: {
      oemplus: p(
        "OEM+ Setup",
        "Clean daily fitment",
        "19x9 +30",
        "19x10 +38",
        "255/35R19",
        "275/35R19",
        "+2mm",
        "+2mm",
        "-2mm",
        "-2mm",
        "0%",
        4,
        9,
        "Low",
        "Clean OEM+ Supra setup.",
        low,
        "20x9 +30"
      ),
      flush: p(
        "Flush Setup",
        "Balanced stance",
        "19x9.5 +25",
        "19x10.5 +35",
        "265/35R19",
        "285/35R19",
        "+12mm",
        "+15mm",
        "-5mm",
        "-6mm",
        "+0.3%",
        7,
        8,
        "Low / Moderate",
        "Perfect flush Supra stance.",
        mod,
        "20x10 +30"
      ),
      aggressive: p(
        "Aggressive Setup",
        "Wide stance",
        "19x10 +25",
        "19x11 +35",
        "275/35R19",
        "305/30R19",
        "+18mm",
        "+25mm",
        "-6mm",
        "-10mm",
        "+0.6%",
        9,
        7,
        "Moderate",
        "Aggressive Supra fitment.",
        mod,
        "20x10.5 +25"
      ),
    },
  },
],
  "Civic": [
    {
      trim: "Sport / Si",
      baseline: {
        front: "18x8 +50",
        rear: "18x8 +50",
        tire: "235/40R18",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p(
          "OEM+ Setup",
          "Clean daily fitment",
          "18x8.5 +45",
          "18x8.5 +45",
          "235/40R18",
          "235/40R18",
          "+11mm",
          "+11mm",
          "-1mm",
          "-1mm",
          "+0.1%",
          4,
          9,
          "Low",
          "Clean Civic OEM+ setup with daily-friendly sizing and minimal fitment risk.",
          low,
          "18x8.5 +38 with 245/40R18 for a slightly fuller daily stance"
        ),
        flush: p(
          "Flush Setup",
          "Balanced street stance",
          "18x9.5 +35",
          "18x9.5 +35",
          "255/35R18",
          "255/35R18",
          "+27mm",
          "+27mm",
          "-7mm",
          "-7mm",
          "-0.4%",
          7,
          7,
          "Low / Moderate",
          "Strong Civic flush setup with a wider footprint and clean street presence.",
          mod,
          "19x9 +35 with 245/35R19 for a larger diameter street setup"
        ),
        aggressive: p(
          "Aggressive Setup",
          "Wide square stance",
          "18x10 +25",
          "18x10 +25",
          "265/35R18",
          "265/35R18",
          "+43mm",
          "+43mm",
          "-8mm",
          "-8mm",
          "+0.2%",
          9,
          5,
          "Moderate / High",
          "Aggressive Civic square setup focused on width, offset, and stance rather than wheel diameter. Best for lowered builds with alignment dialed in.",
          [
            "Likely requires camber, ride-height tuning, and possible fender clearance work.",
            "Check front inner and fender clearance carefully.",
          ],
          "19x9.5 +30 with 255/30R19 for a larger visual street setup"
        ),
      },
    },
    {
  trim: "Type R",
  baseline: {
    front: "19x9.5 +60",
    rear: "19x9.5 +60",
    tire: "265/30R19",
    boltPattern: "5x120",
    centerBore: "64.1",
  },
  presets: {
    oemplus: p(
      "OEM+ Setup",
      "Track-capable daily",
      "18x9.5 +45",
      "18x9.5 +45",
      "265/35R18",
      "265/35R18",
      "+15mm",
      "+15mm",
      "-3mm",
      "-3mm",
      "+0.6%",
      5,
      9,
      "Low",
      "OEM+ Type R setup focused on performance, grip, and proper sidewall for daily + track use.",
      low,
      "18x9.5 +38 with 275/35R18 for a slightly more aggressive stance"
    ),
    flush: p(
      "Flush Setup",
      "Balanced aggressive stance",
      "18x9.5 +38",
      "18x9.5 +38",
      "275/35R18",
      "275/35R18",
      "+22mm",
      "+22mm",
      "-6mm",
      "-6mm",
      "+0.8%",
      7,
      8,
      "Low / Moderate",
      "Well-known flush CTR setup. Fills the fenders properly without compromising usability.",
      mod,
      "18x10 +40 with 275/35R18"
    ),
    aggressive: p(
      "Aggressive Setup",
      "Max grip / stance",
      "18x10 +38/40",
      "18x10 +38/40",
      "285/35R18",
      "285/35R18",
      "+28mm",
      "+28mm",
      "-8mm",
      "-8mm",
      "+1.0%",
      9,
      6,
      "Moderate",
      "Aggressive Type R setup focused on maximum tire and visual presence. Requires proper alignment and ride height.",
      mod,
      "18x10 +40 with 275/35R18 for a slightly safer aggressive setup"
    ),
  },
},
  ],
  "S2000": [
    {
      trim: "AP1 / AP2",
      baseline: {
        front: "17x7 +55",
        rear: "17x8.5 +65",
        tire: "215/45R17 / 245/40R17",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p(
          "OEM+ Setup",
          "Clean factory-plus stance",
          "17x8 +48",
          "17x9 +55",
          "215/45R17",
          "245/40R17",
          "+13mm",
          "+16mm",
          "-7mm",
          "-3mm",
          "0%",
          5,
          9,
          "Low",
          "Clean S2000 OEM+ setup with better stance while staying daily-friendly.",
          low,
          "17x8.5 +50 / 17x9.5 +58 for a slightly fuller staggered setup"
        ),
        flush: p(
          "Flush Setup",
          "Balanced street fitment",
          "17x9 +45",
          "17x10 +50",
          "225/45R17",
          "255/40R17",
          "+23mm",
          "+28mm",
          "-9mm",
          "-7mm",
          "+0.3%",
          8,
          7,
          "Moderate",
          "Strong flush S2000 setup with a clean aggressive stance. Best with alignment dialed in.",
          mod,
          "17x9 +48 / 17x10 +55 for a safer flush setup"
        ),
        aggressive: p(
          "Aggressive Setup",
          "Wide stance / track-inspired",
          "17x9.5 +40",
          "17x10.5 +45",
          "245/40R17",
          "265/40R17",
          "+34mm",
          "+40mm",
          "-10mm",
          "-9mm",
          "+0.7%",
          9,
          5,
          "Moderate / High",
          "Aggressive S2000 fitment with serious presence. Requires camber, ride-height tuning, and fender clearance work.",
          [
            "Front camber recommended.",
            "Rear fender roll likely needed.",
            "Check inner clearance and ride height carefully.",
          ],
          "17x9 +45 / 17x10 +50 for a cleaner aggressive street setup"
        ),
      },
    },
  ],
};


export const makeModelOptions: Record<MakeKey, ModelKey[]> = {
  Tesla: ["Model 3", "Model Y", "Model S", "Model X"],
  BMW: ["M3", "M4"],
  Toyota: ["GR86", "GR Corolla", "Supra"],
  Honda: ["Civic", "S2000"],
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
    if (input.includes("corolla")) return "GR Corolla";
    if (input.includes("supra")) return "Supra";
    return "GR86";
  }

  if (make === "Honda") {
  if (input.includes("s2000") || input.includes("s2k")) return "S2000";
  return "Civic";
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
  if (input === "honda") return "Honda";
  if (input === "porsche") return "Porsche";
  return "Tesla";
}
