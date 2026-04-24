import type { ModelKey, StyleKey } from "./fitment";

export type GalleryBuild = {
  label: string;
  imageUrl: string;
  sourceName: string;
  sourceUrl: string;
  wheel: string;
  tire: string;
  note: string;
  match: string;
  verified: boolean;
};

export const galleryExamples: Partial<Record<ModelKey, Partial<Record<StyleKey, GalleryBuild[]>>>> = {
  "Model S": {
    aggressive: [
      {
        label: "Model S Plaid Aggressive",
        imageUrl:
          "https://strassewheels.com/wp-content/uploads/2022/10/Tesla-Model-S-Plaid-StrasseWheels-Mike08274-copy-7.jpg",
        sourceName: "Strasse Wheels",
        sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/",
        wheel: "21x10 +30 / 21x11 +38",
        tire: "275/35R21 / 305/30R21",
        note: "Strong rear stance matching aggressive Plaid setups.",
        match: "Close Visual Match",
        verified: true,
      },
    ],
    flush: [],
    oemplus: [],
  },
};
