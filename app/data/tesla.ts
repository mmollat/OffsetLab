export const teslaModels = ["Model 3", "Model Y"] as const;
export const models = teslaModels;

export type TeslaModelKey = (typeof teslaModels)[number];
export type StyleKey = "oemplus" | "flush" | "aggressive";

export const trims: Record<TeslaModelKey, string[]> = {
  "Model 3": ["Performance", "Long Range"],
  "Model Y": ["Performance", "Long Range"],
};

type Preset = {
  title: string;
  subtitle: string;
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  pokeFront: string;
  innerFront: string;
  diameter: string;
  verdict: string;
  risk: string;
  confidence: string;
};

type TrimData = {
  baseline: {
    front: string;
    rear: string;
    tire: string;
  };
  presets: Record<StyleKey, Preset>;
};

const teslaData: Record<TeslaModelKey, Record<string, TrimData>> = {
  "Model 3": {
    Performance: {
      baseline: {
        front: "20x9 +34",
        rear: "20x9 +34",
        tire: "235/35R20",
      },
      presets: {
        oemplus: {
          title: "OEM+ Daily",
          subtitle: "Close to stock feel with a cleaner stance.",
          front: "19x8.5 +35",
          rear: "19x8.5 +35",
          frontTire: "245/40R19",
          rearTire: "245/40R19",
          pokeFront: "+4 mm",
          innerFront: "-1 mm",
          diameter: "+0.6%",
          verdict: "Very safe daily setup with minimal compromise.",
          risk: "Low",
          confidence: "High",
        },
        flush: {
          title: "Flush Daily",
          subtitle: "Balanced stance with good daily drivability.",
          front: "19x9.5 +30",
          rear: "19x9.5 +30",
          frontTire: "265/35R19",
          rearTire: "265/35R19",
          pokeFront: "+16 mm",
          innerFront: "-10 mm",
          diameter: "+0.2%",
          verdict: "Popular enthusiast fitment that looks right without going too wild.",
          risk: "Moderate",
          confidence: "High",
        },
        aggressive: {
          title: "Aggressive Daily",
          subtitle: "More visual impact with tighter clearances.",
          front: "20x9 +25",
          rear: "20x10.5 +38",
          frontTire: "245/35R20",
          rearTire: "285/30R20",
          pokeFront: "+9 mm",
          innerFront: "-9 mm",
          diameter: "-0.2%",
          verdict: "Looks strong, but this is where suspension setup and tolerance matter more.",
          risk: "Moderate",
          confidence: "Medium",
        },
      },
    },
    "Long Range": {
      baseline: {
        front: "18x8.5 +40",
        rear: "18x8.5 +40",
        tire: "235/45R18",
      },
      presets: {
        oemplus: {
          title: "OEM+ Daily",
          subtitle: "Near-stock behavior with a cleaner wheel setup.",
          front: "19x8.5 +35",
          rear: "19x8.5 +35",
          frontTire: "245/40R19",
          rearTire: "245/40R19",
          pokeFront: "+11 mm",
          innerFront: "-1 mm",
          diameter: "+0.6%",
          verdict: "Easy recommendation for daily use.",
          risk: "Low",
          confidence: "High",
        },
        flush: {
          title: "Flush Daily",
          subtitle: "Filled-out stance, still daily-friendly.",
          front: "19x9.5 +30",
          rear: "19x9.5 +30",
          frontTire: "265/35R19",
          rearTire: "265/35R19",
          pokeFront: "+23 mm",
          innerFront: "-10 mm",
          diameter: "+0.2%",
          verdict: "Strong all-around fitment for owners who want more presence.",
          risk: "Moderate",
          confidence: "High",
        },
        aggressive: {
          title: "Aggressive Daily",
          subtitle: "Tighter, more assertive fitment.",
          front: "19x9.5 +25",
          rear: "19x10.5 +35",
          frontTire: "265/35R19",
          rearTire: "285/35R19",
          pokeFront: "+28 mm",
          innerFront: "-15 mm",
          diameter: "+1.8%",
          verdict: "Needs more care, but gives a much stronger stance.",
          risk: "High",
          confidence: "Medium",
        },
      },
    },
  },
  "Model Y": {
    Performance: {
      baseline: {
        front: "21x9.5 +40",
        rear: "21x10.5 +48",
        tire: "255/35R21 • 275/35R21",
      },
      presets: {
        oemplus: {
          title: "OEM+ Daily",
          subtitle: "Close to factory proportions with subtle cleanup.",
          front: "20x9.5 +40",
          rear: "20x10.5 +45",
          frontTire: "255/40R20",
          rearTire: "275/40R20",
          pokeFront: "+0 mm",
          innerFront: "+0 mm",
          diameter: "+0.4%",
          verdict: "Closest to OEM behavior.",
          risk: "Low",
          confidence: "Medium",
        },
        flush: {
          title: "Flush Daily",
          subtitle: "More planted without looking overdone.",
          front: "20x9.5 +35",
          rear: "20x10.5 +40",
          frontTire: "255/40R20",
          rearTire: "275/40R20",
          pokeFront: "+5 mm",
          innerFront: "-5 mm",
          diameter: "+0.4%",
          verdict: "Cleaner stance with modest tradeoffs.",
          risk: "Moderate",
          confidence: "Medium",
        },
        aggressive: {
          title: "Aggressive Daily",
          subtitle: "Bolder visual stance with tighter margins.",
          front: "21x9.5 +30",
          rear: "21x10.5 +35",
          frontTire: "265/35R21",
          rearTire: "285/35R21",
          pokeFront: "+10 mm",
          innerFront: "-10 mm",
          diameter: "+0.8%",
          verdict: "Looks stronger, but less forgiving.",
          risk: "High",
          confidence: "Low",
        },
      },
    },
    "Long Range": {
      baseline: {
        front: "19x9.5 +45",
        rear: "19x9.5 +45",
        tire: "255/45R19",
      },
      presets: {
        oemplus: {
          title: "OEM+ Daily",
          subtitle: "Simple, conservative upgrade path.",
          front: "20x9.5 +40",
          rear: "20x9.5 +40",
          frontTire: "255/40R20",
          rearTire: "255/40R20",
          pokeFront: "+5 mm",
          innerFront: "-5 mm",
          diameter: "+0.1%",
          verdict: "Easy daily option.",
          risk: "Low",
          confidence: "Medium",
        },
        flush: {
          title: "Flush Daily",
          subtitle: "Better stance with reasonable margins.",
          front: "20x9.5 +35",
          rear: "20x9.5 +35",
          frontTire: "265/40R20",
          rearTire: "265/40R20",
          pokeFront: "+10 mm",
          innerFront: "-10 mm",
          diameter: "+0.7%",
          verdict: "Solid enthusiast setup for appearance.",
          risk: "Moderate",
          confidence: "Medium",
        },
        aggressive: {
          title: "Aggressive Daily",
          subtitle: "More presence, tighter fitment.",
          front: "20x10 +30",
          rear: "20x10.5 +35",
          frontTire: "275/40R20",
          rearTire: "285/40R20",
          pokeFront: "+18 mm",
          innerFront: "-14 mm",
          diameter: "+1.2%",
          verdict: "Looks great when dialed in, but less forgiving.",
          risk: "High",
          confidence: "Low",
        },
      },
    },
  },
};

export function getTrims(model: TeslaModelKey) {
  return trims[model] ?? [];
}

export function getTrimData(model: TeslaModelKey, trim: string): TrimData {
  const modelData = teslaData[model];
  const trimData = modelData?.[trim];

  if (!trimData) {
    const fallbackTrim = getTrims(model)[0];
    return modelData[fallbackTrim];
  }

  return trimData;
}
