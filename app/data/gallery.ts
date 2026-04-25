import type { ModelKey, StyleKey } from "./fitment";

export type GalleryBuild = {
  label: string;
  imageUrl: string;
  imageStatus: "verified" | "pending";
  sourceType?: "official" | "wheelBrand" | "community"; // ✅ NEW
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
    sourceType: "community", // ✅ default
    sourceName: "Verified image pending",
    sourceUrl: "",
    wheel,
    tire,
    suspension: "Use fitment notes",
    note,
    verificationNote:
      "Photo hidden until a source image with matching specs is verified. This prevents showing an incorrect visual reference.",
    tags,
    match: "Pending Verified Photo",
  };
}

export const galleryExamples: Record<ModelKey, Record<StyleKey, GalleryBuild[]>> = {
  "Model 3": {
    oemplus: [pending("Model 3 OEM+ Verified Photo Pending", "19x8.5 +35", "245/40R19", "OEM+ Model 3 should use a square, conservative setup only. No wide rear or deep concave staggered photos.", ["Model 3", "OEM+", "Square", "Strict Match"])],
    flush: [pending("Model 3 Flush Verified Photo Pending", "19x9.5 +30", "265/35R19", "Flush Model 3 should show a filled-out square setup without extreme poke.", ["Model 3", "Flush", "Square", "Strict Match"])],
    aggressive: [pending("Model 3 Aggressive Verified Photo Pending", "20x9 +25 / 20x10.5 +38", "245/35R20 / 285/30R20", "Aggressive Model 3 can use staggered/wide rear visuals only when specs are confirmed.", ["Model 3", "Aggressive", "Staggered", "Strict Match"])],
  },

  "Model Y": {
    oemplus: [pending("Model Y OEM+ Verified Photo Pending", "20x9.5 +40", "255/40R20", "OEM+ Model Y should stay subtle and daily-friendly.", ["Model Y", "OEM+", "Strict Match"])],
    flush: [pending("Model Y Flush Verified Photo Pending", "20x10 +35", "275/40R20", "Flush Model Y should show a filled-out stance without looking overbuilt.", ["Model Y", "Flush", "Strict Match"])],
    aggressive: [pending("Model Y Aggressive Verified Photo Pending", "21x9.5 +30 / 21x10.5 +38", "275/35R21 / 295/35R21", "Aggressive Model Y should show stronger SUV presence and wider fitment.", ["Model Y", "Aggressive", "Strict Match"])],
  },

  "Model S": {
    oemplus: [pending("Model S OEM+ Verified Photo Pending", "21x9.5 +38 / 21x10.5 +42", "265/35R21 / 295/30R21", "OEM+ Model S Plaid should show a tight but not extreme stance.", ["Model S", "OEM+", "Plaid", "Strict Match"])],
    flush: [pending("Model S Flush Verified Photo Pending", "21x9.5 +35 / 21x10.5 +40", "275/35R21 / 295/30R21", "Flush Model S should show a clean filled-out stance without wide 305+ rear exaggeration.", ["Model S", "Flush", "Plaid", "Strict Match"])],
    aggressive: [{
      label: "Model S Plaid Aggressive",
      imageUrl: verifiedModelSPlaidAggressive,
      imageStatus: "verified",
      sourceType: "wheelBrand", // ✅ KEY ADD
      sourceName: "Strasse Wheels",
      sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/",
      wheel: "21x10 +30 / 21x11 +38",
      tire: "275/35R21 / 305/30R21",
      suspension: "Street stance",
      note: "Strict aggressive Plaid reference. Wide staggered stance with strong rear presence.",
      verificationNote: "Used only for the aggressive Model S category because the visual stance and wheel sizing are aligned with the recommended wide staggered setup.",
      tags: ["Model S", "Plaid", "Aggressive", "Wide Rear"],
      match: "Verified Spec Match",
    }],
  },

  "Model X": {
    oemplus: [pending("Model X OEM+ Verified Photo Pending", "22x9.5 +33 / 22x10.5 +38", "265/35R22 / 295/35R22", "OEM+ Model X should show a clean premium SUV stance.", ["Model X", "OEM+", "Strict Match"])],
    flush: [pending("Model X Flush Verified Photo Pending", "22x10 +30 / 22x11 +35", "275/35R22 / 305/30R22", "Flush Model X should look planted without going oversized/show-only.", ["Model X", "Flush", "Strict Match"])],
    aggressive: [pending("Model X Aggressive Verified Photo Pending", "22x10.5 +28 / 22x11.5 +30", "285/35R22 / 315/30R22", "Aggressive Model X needs a verified wide SUV photo before display.", ["Model X", "Aggressive", "Strict Match"])],
  },

  "M3": {
    oemplus: [pending("BMW M3 OEM+ Verified Photo Pending", "See selected trim baseline", "See selected trim baseline", "OEM+ BMW M3 should stay close to factory proportions.", ["BMW", "M3", "OEM+", "Strict Match"])],
    flush: [pending("BMW M3 Flush Verified Photo Pending", "See selected trim recommendation", "See selected trim recommendation", "Flush BMW M3 should show a strong filled-out stance.", ["BMW", "M3", "Flush", "Strict Match"])],
    aggressive: [pending("BMW M3 Aggressive Verified Photo Pending", "See selected trim recommendation", "See selected trim recommendation", "Aggressive BMW M3 should only show wide, planted fitment.", ["BMW", "M3", "Aggressive", "Strict Match"])],
  },

  "M4": {
    oemplus: [pending("G82/G83 M4 OEM+ Verified Photo Pending", "19x9.5 ET20 / 20x10.5 ET20", "275/35R19 / 285/30R20", "BMW M4 OEM+ should stay close to factory proportions.", ["BMW", "M4", "OEM+", "Strict Match"])],
    flush: [pending("G82/G83 M4 Flush Verified Photo Pending", "20x10 ET15 / 20x11 ET15", "285/30R20 / 305/30R20", "BMW M4 flush should show a strong stance.", ["BMW", "M4", "Flush", "Strict Match"])],
    aggressive: [pending("G82/G83 M4 Aggressive Verified Photo Pending", "20x10 ET12 / 20x11 ET12", "285/30R20 / 305/30R20", "BMW M4 aggressive should only show wide fitment.", ["BMW", "M4", "Aggressive", "Strict Match"])],
  },
};
