import type { ModelKey, StyleKey } from "./fitment";

export type GalleryBuild = {
  label: string;
  imageUrl: string;
  imageStatus: "verified" | "pending";
  sourceType?: "official" | "wheelBrand" | "community";
  sourceName: string;
  sourceUrl: string;
  wheel: string;
  tire: string;
  suspension: string;
  note: string;
  verificationNote: string;
  tags: string[];
  match: "Exact Match" | "Verified Spec Match" | "Pending Verified Photo";
};

const verifiedModelSPlaidAggressive =
  "https://strassewheels.com/wp-content/uploads/2022/10/Tesla-Model-S-Plaid-StrasseWheels-Mike08274-copy-7.jpg";

function pending(
  label: string,
  wheel: string,
  tire: string,
  note: string,
  tags: string[]
): GalleryBuild {
  return {
    label,
    imageUrl: "",
    imageStatus: "pending",
    sourceType: "community",
    sourceName: "Verified image pending",
    sourceUrl: "",
    wheel,
    tire,
    suspension: "Use fitment notes",
    note,
    verificationNote:
      "Photo hidden until a source image with matching specs is verified.",
    tags,
    match: "Pending Verified Photo",
  };
}

export const galleryExamples: Record<ModelKey, Record<StyleKey, GalleryBuild[]>> = {
  "Model 3": {
    oemplus: [pending("Model 3 OEM+ Verified Photo Pending", "19x8.5 +35", "245/40R19", "", ["Model 3"])],
    flush: [pending("Model 3 Flush Verified Photo Pending", "19x9.5 +30", "265/35R19", "", ["Model 3"])],
    aggressive: [pending("Model 3 Aggressive Pending", "20x9 +25 / 20x10.5 +38", "245/35R20 / 285/30R20", "", ["Model 3"])],
  },

  "Model Y": {
    oemplus: [pending("Model Y OEM+ Pending", "20x9.5 +40", "255/40R20", "", ["Model Y"])],
    flush: [pending("Model Y Flush Pending", "20x10 +35", "275/40R20", "", ["Model Y"])],
    aggressive: [pending("Model Y Aggressive Pending", "21x9.5 +30", "275/35R21", "", ["Model Y"])],
  },

  "Model S": {
    oemplus: [pending("Model S OEM+ Pending", "", "", "", ["Model S"])],
    flush: [pending("Model S Flush Pending", "", "", "", ["Model S"])],
    aggressive: [
      {
        label: "Model S Plaid Aggressive",
        imageUrl: verifiedModelSPlaidAggressive,
        imageStatus: "verified",
        sourceType: "wheelBrand",
        sourceName: "Strasse Wheels",
        sourceUrl: "https://strassewheels.com",
        wheel: "21x10 +30 / 21x11 +38",
        tire: "275/35R21 / 305/30R21",
        suspension: "Street",
        note: "Aggressive Plaid stance.",
        verificationNote: "Verified aggressive Model S reference.",
        tags: ["Model S", "Aggressive"],
        match: "Verified Spec Match",
      },
    ],
  },

  "Model X": {
    oemplus: [pending("Model X OEM+ Pending", "", "", "", ["Model X"])],
    flush: [pending("Model X Flush Pending", "", "", "", ["Model X"])],
    aggressive: [pending("Model X Aggressive Pending", "", "", "", ["Model X"])],
  },

  "M3": {
    oemplus: [pending("M3 OEM+ Pending", "", "", "", ["M3"])],
    flush: [pending("M3 Flush Pending", "", "", "", ["M3"])],
    aggressive: [pending("M3 Aggressive Pending", "", "", "", ["M3"])],
  },

  "M4": {
    oemplus: [pending("M4 OEM+ Pending", "", "", "", ["M4"])],
    flush: [pending("M4 Flush Pending", "", "", "", ["M4"])],
    aggressive: [pending("M4 Aggressive Pending", "", "", "", ["M4"])],
  },

  // ✅ FIX: ADD GR86
  "GR86": {
    oemplus: [
      pending(
        "GR86 OEM+ Verified Photo Pending",
        "18x8 +40",
        "225/40R18",
        "Clean OEM+ GR86 setup",
        ["GR86", "OEM+"]
      ),
    ],
    flush: [
      pending(
        "GR86 Flush Verified Photo Pending",
        "18x9 +38",
        "245/35R18",
        "Flush GR86 stance",
        ["GR86", "Flush"]
      ),
    ],
    aggressive: [
      pending(
        "GR86 Aggressive Verified Photo Pending",
        "18x9.5 +35",
        "255/35R18",
        "Aggressive GR86 stance",
        ["GR86", "Aggressive"]
      ),
    ],
  },
};
