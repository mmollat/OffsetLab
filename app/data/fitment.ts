// (keeping your existing types and helpers exactly the same)

const low = ["Very low rub risk", "Good daily setup"];
const mod = ["Ride height matters", "Check clearance if lowered"];

// ----------------------------
// FITMENT DATA
// ----------------------------

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
        oemplus: p("OEM+ Setup", "Clean daily setup", "20x8.5 +35", "20x8.5 +35", "235/35R20", "235/35R20", "+7mm", "+7mm", "-1mm", "-1mm", "+0.3%", 4, 9, "Low", "Clean OEM+ fitment with minimal compromise.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+18mm", "+18mm", "-8mm", "-8mm", "+0.5%", 7, 8, "Low / Moderate", "Strong daily fitment that fills the car out properly.", ["Watch front clearance on lower ride heights"], "20x9 +30 / 245-255/35R20"),
        aggressive: p("Aggressive Setup", "Wider stance", "20x9 +26", "20x10.5 +38", "245/35R20", "285/30R20", "+22mm", "+28mm", "-6mm", "-10mm", "+0.8%", 8, 7, "Moderate", "Strong aggressive stance with manageable clearance.", ["Front clearance tighter at full lock", "Lowered setups may require camber awareness"], "19x9.5 +25 square / 275/35R19"),
      },
    },

    // ✅ ADDED BACK
    {
      trim: "Long Range AWD",
      baseline: {
        front: "18x8.5 +40",
        rear: "18x8.5 +40",
        tire: "235/45R18",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "Clean OEM+ LR setup.", low, "19x9 +35 / 255/40R19"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "Nice flush daily.", mod, "20x9 +30 / 255/35R20"),
        aggressive: p("Aggressive Setup", "Wider stance", "20x9 +25", "20x10.5 +38", "245/35R20", "285/30R20", "+26mm", "+34mm", "-6mm", "-11mm", "+0.8%", 8, 7, "Moderate", "Aggressive LR stance.", mod, "19x9.5 +25 square / 275/35R19"),
      },
    },

    // ✅ ADDED BACK
    {
      trim: "RWD",
      baseline: {
        front: "18x8.5 +40",
        rear: "18x8.5 +40",
        tire: "235/45R18",
        boltPattern: "5x114.3",
        centerBore: "64.1",
      },
      presets: {
        oemplus: p("OEM+ Setup", "Clean upgrade", "19x8.5 +35", "19x8.5 +35", "245/40R19", "245/40R19", "+11mm", "+11mm", "-1mm", "-1mm", "+0.8%", 4, 9, "Low", "Perfect OEM+ RWD.", low, "19x9 +35"),
        flush: p("Flush Setup", "Balanced stance", "19x9.5 +30", "19x9.5 +30", "265/35R19", "265/35R19", "+22mm", "+22mm", "-10mm", "-10mm", "+0.2%", 7, 8, "Low / Moderate", "Clean flush RWD.", mod, "20x9 +30"),
        aggressive: p("Aggressive Setup", "Wider stance", "20x9 +25", "20x10 +35", "245/35R20", "275/30R20", "+26mm", "+31mm", "-6mm", "-8mm", "+0.5%", 8, 7, "Moderate", "Aggressive RWD fitment.", mod, "19x9.5 +25"),
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
        oemplus: p("OEM+ Setup", "Clean daily setup", "20x9.5 +40", "20x9.5 +40", "255/40R20", "255/40R20", "+5mm", "+5mm", "-5mm", "-5mm", "-0.1%", 4, 9, "Low", "Clean OEM+ option for the Model Y.", low, "20x10 +40"),
        flush: p("Flush Setup", "Filled-out stance", "20x10 +35", "20x10 +35", "275/40R20", "275/40R20", "+16mm", "+16mm", "-10mm", "-10mm", "+0.7%", 7, 8, "Low / Moderate", "Strong flush setup.", mod, "21x9.5 +40"),
        aggressive: p("Aggressive Setup", "Wider stance", "21x9.5 +30", "21x10.5 +40", "265/35R21", "295/35R21", "+20mm", "+24mm", "-5mm", "-8mm", "+0.9%", 8, 7, "Moderate", "Aggressive SUV fitment.", mod, "20x10 +30"),
      },
    },

    // ✅ ADDED BACK
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
        oemplus: p("OEM+ Setup", "Close to stock", "21x9.5 +38", "21x10.5 +42", "255/35R21", "275/35R21", "+2mm", "+3mm", "-2mm", "-3mm", "0%", 4, 9, "Low", "Minimal compromise.", low, "20x10 +38"),
        flush: p("Flush Setup", "Sharper stance", "21x10 +35", "21x11 +40", "265/35R21", "295/35R21", "+8mm", "+10mm", "-4mm", "-5mm", "+0.5%", 7, 8, "Low / Moderate", "Clean performance flush.", mod, "21x10 +35"),
        aggressive: p("Aggressive Setup", "Wide stance", "21x10.5 +30", "21x11.5 +35", "275/35R21", "305/30R21", "+15mm", "+20mm", "-5mm", "-8mm", "+0.8%", 8, 7, "Moderate", "Aggressive performance stance.", mod, "20x10 +30"),
      },
    },
  ],

  // everything else stays exactly the same (M3, M4, GR86, etc)
};
