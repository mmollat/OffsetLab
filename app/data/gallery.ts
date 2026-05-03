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
  match: "Exact Match" | "Close Match" | "Visual Reference";
};

const verifiedModelSPlaidAggressive =
  "/gallery/models.png";
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
      "Used as a visual reference. Specs may vary slightly from the recommended setup, but the overall look and stance are similar.",
    tags,
    match: "Visual Reference",
  };
}

export const galleryExamples: Record<ModelKey, Record<StyleKey, GalleryBuild[]>> = {
  "Model 3": {
    oemplus: [
  {
    label: "Model 3 OEM+ Reference",
    imageUrl: "/gallery/model3-oemplus.png",
    imageStatus: "verified",
    sourceType: "community",
    sourceName: "Offset Lab",
    sourceUrl: "#",
    wheel: "19x8.5 +35",
    tire: "245/40R19",
    suspension: "Stock / Mild drop",
    note: "Clean OEM+ Model 3 stance with factory-plus proportions.",
    verificationNote:
      "Used as OEM+ reference. Matches square setup with conservative sizing and daily drivability.",
    tags: ["Model 3", "OEM+"],
    match: "Close Match",
  },
],
    flush: [
      pending(
        "Model 3 Flush Verified Photo Pending",
        "19x9.5 +30",
        "265/35R19",
        "Flush Model 3 should show a filled-out square setup without extreme poke.",
        ["Model 3", "Flush", "Square", "Strict Match"]
      ),
    ],
    aggressive: [
      pending(
        "Model 3 Aggressive Verified Photo Pending",
        "20x9 +25 / 20x10.5 +38",
        "245/35R20 / 285/30R20",
        "Aggressive Model 3 can use staggered/wide rear visuals only when specs are confirmed.",
        ["Model 3", "Aggressive", "Staggered", "Strict Match"]
      ),
    ],
  },

  "Model Y": {
    oemplus: [
      pending(
        "Model Y OEM+ Verified Photo Pending",
        "20x9.5 +40",
        "255/40R20",
        "OEM+ Model Y should stay subtle and daily-friendly.",
        ["Model Y", "OEM+", "Strict Match"]
      ),
    ],
    flush: [
      pending(
        "Model Y Flush Verified Photo Pending",
        "20x10 +35",
        "275/40R20",
        "Flush Model Y should show a filled-out stance without looking overbuilt.",
        ["Model Y", "Flush", "Strict Match"]
      ),
    ],
    aggressive: [
      pending(
        "Model Y Aggressive Verified Photo Pending",
        "21x9.5 +30 / 21x10.5 +38",
        "275/35R21 / 295/35R21",
        "Aggressive Model Y should show stronger SUV presence and wider fitment.",
        ["Model Y", "Aggressive", "Strict Match"]
      ),
    ],
  },

  "Model S": {
    oemplus: [
      pending(
        "Model S OEM+ Verified Photo Pending",
        "21x9.5 +38 / 21x10.5 +42",
        "265/35R21 / 295/30R21",
        "OEM+ Model S Plaid should show a tight but not extreme stance.",
        ["Model S", "OEM+", "Plaid", "Strict Match"]
      ),
    ],
    flush: [
      pending(
        "Model S Flush Verified Photo Pending",
        "21x9.5 +35 / 21x10.5 +40",
        "275/35R21 / 295/30R21",
        "Flush Model S should show a clean filled-out stance without wide 305+ rear exaggeration.",
        ["Model S", "Flush", "Plaid", "Strict Match"]
      ),
    ],
    aggressive: [
      {
        label: "Model S Plaid Aggressive",
        imageUrl: verifiedModelSPlaidAggressive,
        imageStatus: "verified",
        sourceType: "wheelBrand",
        sourceName: "Strasse Wheels",
        sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/",
        wheel: "21x10 +30 / 21x11 +38",
        tire: "275/35R21 / 305/30R21",
        suspension: "Street stance",
        note: "Strict aggressive Plaid reference. Wide staggered stance with strong rear presence.",
        verificationNote:
          "Used only for the aggressive Model S category because the visual stance and wheel sizing are aligned with the recommended wide staggered setup.",
        tags: ["Model S", "Plaid", "Aggressive", "Wide Rear"],
        match: "Close Match",
      },
    ],
  },

  "Model X": {
    oemplus: [
      pending(
        "Model X OEM+ Verified Photo Pending",
        "22x9.5 +33 / 22x10.5 +38",
        "265/35R22 / 295/35R22",
        "OEM+ Model X should show a clean premium SUV stance.",
        ["Model X", "OEM+", "Strict Match"]
      ),
    ],
    flush: [
      pending(
        "Model X Flush Verified Photo Pending",
        "22x10 +30 / 22x11 +35",
        "275/35R22 / 305/30R22",
        "Flush Model X should look planted without going oversized/show-only.",
        ["Model X", "Flush", "Strict Match"]
      ),
    ],
    aggressive: [
      pending(
        "Model X Aggressive Verified Photo Pending",
        "22x10.5 +28 / 22x11.5 +30",
        "285/35R22 / 315/30R22",
        "Aggressive Model X needs a verified wide SUV photo before display.",
        ["Model X", "Aggressive", "Strict Match"]
      ),
    ],
  },

  "M3": {
    oemplus: [
      pending(
        "BMW M3 OEM+ Verified Photo Pending",
        "See selected trim baseline",
        "See selected trim baseline",
        "OEM+ BMW M3 should stay close to factory proportions.",
        ["BMW", "M3", "OEM+", "Strict Match"]
      ),
    ],
    flush: [
      pending(
        "BMW M3 Flush Verified Photo Pending",
        "See selected trim recommendation",
        "See selected trim recommendation",
        "Flush BMW M3 should show a strong filled-out stance.",
        ["BMW", "M3", "Flush", "Strict Match"]
      ),
    ],
    aggressive: [
      pending(
        "BMW M3 Aggressive Verified Photo Pending",
        "See selected trim recommendation",
        "See selected trim recommendation",
        "Aggressive BMW M3 should only show wide, planted fitment when correctly verified.",
        ["BMW", "M3", "Aggressive", "Strict Match"]
      ),
    ],
  },

  "M4": {
    oemplus: [
      pending(
        "G82/G83 M4 OEM+ Verified Photo Pending",
        "19x9.5 ET20 / 20x10.5 ET20",
        "275/35R19 / 285/30R20",
        "BMW M4 OEM+ should stay close to factory proportions.",
        ["BMW", "M4", "OEM+", "Strict Match"]
      ),
    ],
    flush: [
      pending(
        "G82/G83 M4 Flush Verified Photo Pending",
        "20x10 ET15 / 20x11 ET15",
        "285/30R20 / 305/30R20",
        "BMW M4 flush should show a strong stance.",
        ["BMW", "M4", "Flush", "Strict Match"]
      ),
    ],
    aggressive: [
      pending(
        "G82/G83 M4 Aggressive Verified Photo Pending",
        "20x10 ET12 / 20x11 ET12",
        "285/30R20 / 305/30R20",
        "BMW M4 aggressive should only show wide fitment.",
        ["BMW", "M4", "Aggressive", "Strict Match"]
      ),
    ],
  },

  "GR86": {
    oemplus: [
      {
        label: "GR86 OEM+ Reference",
        imageUrl:
          "https://images.squarespace-cdn.com/content/v1/5b4188367c9327e167175023/1643743604449-Z95VZT4AYHGGZN1BVVAQ/IMG_0759.JPG",
        imageStatus: "verified",
        sourceType: "wheelBrand",
        sourceName: "System Motorsports",
        sourceUrl:
          "https://www.systemmotorsports.blog/blog/2022/2/1/wheel-fitment-on-the-2022-toyota-gr86-subaru-brz",
        wheel: "18x8.5 +40",
        tire: "235/40R18",
        suspension: "Street stance",
        note: "Clean GR86 reference with mild, daily-friendly fitment.",
        verificationNote:
          "Used as an OEM+ visual reference for a clean GR86 stance. Exact wheel size may vary slightly from the preset.",
        tags: ["GR86", "OEM+", "Square"],
        match: "Close Match",
      },
    ],

    flush: [
      {
        label: "GR86 Flush Reference",
        imageUrl:
          "https://images.squarespace-cdn.com/content/v1/5b4188367c9327e167175023/1665774525173-QNSPR10N021H1O40X8NS/IMG_5487.jpg",
        imageStatus: "verified",
        sourceType: "wheelBrand",
        sourceName: "System Motorsports",
        sourceUrl:
          "https://www.systemmotorsports.blog/blog/2022/2/1/wheel-fitment-on-the-2022-toyota-gr86-subaru-brz",
        wheel: "18x9.5 +40",
        tire: "255/35R18",
        suspension: "Coilovers",
        note: "Strong square GR86 stance with clean fitment and clear wheel visibility.",
        verificationNote:
          "System Motorsports documents 2022+ GR86 setups using 18x9.5 +40 with 255/35R18 tires.",
        tags: ["GR86", "Flush", "Square"],
        match: "Close Match",
      },
    ],

    aggressive: [
      {
        label: "GR86 Aggressive Reference",
        imageUrl:
          "https://images.squarespace-cdn.com/content/v1/5b4188367c9327e167175023/1662067240206-FDE7RF4MDJXNE61E5N7J/301964339_10222748831935451_75743691837866124_n.jpeg",
        imageStatus: "verified",
        sourceType: "wheelBrand",
        sourceName: "System Motorsports",
        sourceUrl:
          "https://www.systemmotorsports.blog/blog/2022/2/1/wheel-fitment-on-the-2022-toyota-gr86-subaru-brz",
        wheel: "18x9.5 +40",
        tire: "255/35R18",
        suspension: "Coilovers",
        note: "Aggressive GR86 reference with wide square fitment and low stance.",
        verificationNote:
          "System Motorsports highlights 18x9.5 +40 / 255/35R18 as a strong GR86 fitment reference.",
        tags: ["GR86", "Aggressive", "Square"],
        match: "Close Match",
      },
    ],
  },
  "GR Corolla": {
  oemplus: [
    {
      label: "GR Corolla OEM+ Reference",
      imageUrl: "https://images.fitmentindustries.com/web-compressed/2303120-1-2023-corolla-toyota-core-stock-stock-enkei-tsr-x.jpg",
      imageStatus: "verified",
      sourceType: "community",
      sourceName: "Fitment Industries",
      sourceUrl: "https://www.fitmentindustries.com/",
      wheel: "18x8.5 +30",
      tire: "245/40R18",
      suspension: "Stock / Mild drop",
      note: "Clean OEM+ GR Corolla fitment with slightly wider tire for better stance.",
      verificationNote:
        "Used as OEM+ reference. Matches square setup with minimal poke and daily drivability.",
      tags: ["GR Corolla", "OEM+", "Square"],
      match: "Close Match",
    },
  ],

  flush: [
    {
      label: "GR Corolla Flush Reference",
      imageUrl: "https://images.fitmentindustries.com/web-compressed/2359981-1-2023-corolla-toyota-core-te37sl-ray-volk-bronze.jpg",
      imageStatus: "verified",
      sourceType: "community",
      sourceName: "Fitment Industries",
      sourceUrl: "https://www.fitmentindustries.com/",
      wheel: "18x9.5 +30",
      tire: "255/35R18",
      suspension: "Lowered",
      note: "Strong flush stance with proper tire stretch and clean fender alignment.",
      verificationNote:
        "Matches flush preset with 18x9.5 +30 and 255 tire sizing.",
      tags: ["GR Corolla", "Flush", "Square"],
      match: "Close Match",
    },
  ],

  aggressive: [
    {
      label: "GR Corolla Aggressive Reference",
      imageUrl: "https://images.fitmentindustries.com/web-compressed/2411123-1-2023-corolla-toyota-core-work-meister-s1-3p-polished.jpg",
      imageStatus: "verified",
      sourceType: "community",
      sourceName: "Fitment Industries",
      sourceUrl: "https://www.fitmentindustries.com/",
      wheel: "18x9.5 +22",
      tire: "265/35R18",
      suspension: "Coilovers",
      note: "Wide aggressive stance with visible poke and lower ride height.",
      verificationNote:
        "Represents aggressive preset with wider tire and lower offset.",
      tags: ["GR Corolla", "Aggressive", "Wide"],
      match: "Close Match",
    },
  ],
},
"Supra": {
  oemplus: [
    pending(
      "Supra OEM+ Verified Photo Pending",
      "19x9 +30 / 19x10 +38",
      "255/35R19 / 275/35R19",
      "OEM+ Supra should stay clean, proportional, and close to factory balance.",
      ["Supra", "OEM+", "Strict Match"]
    ),
  ],
  flush: [
    pending(
      "Supra Flush Verified Photo Pending",
      "19x9.5 +25 / 19x10.5 +35",
      "265/35R19 / 285/35R19",
      "Flush Supra should show a filled-out stance with proper front/rear balance.",
      ["Supra", "Flush", "Strict Match"]
    ),
  ],
  aggressive: [
    pending(
      "Supra Aggressive Verified Photo Pending",
      "19x10 +22 / 19x11 +35",
      "275/35R19 / 305/30R19",
      "Aggressive Supra should show strong rear width and an assertive stance.",
      ["Supra", "Aggressive", "Wide Rear", "Strict Match"]
    ),
  ],
},
"Civic": {
  oemplus: [
    pending(
      "Civic OEM+ Verified Photo Pending",
      "Sport/Si: 18x8.5 +45 / Type R: 18x9.5 +45",
      "Sport/Si: 235/40R18 / Type R: 265/35R18",
      "Civic Sport/Si and Type R should use separate visual judgment because CTR fitment is more aggressive.",
      ["Civic", "OEM+", "Square", "Strict Match"]
    ),
  ],
  flush: [
    pending(
      "Civic Flush Verified Photo Pending",
      "Sport/Si: 18x9.5 +35 / Type R: 18x9.5 +38",
      "Sport/Si: 255/35R18 / Type R: 275/35R18",
      "Flush Civic should match the selected trim. Type R fitment is wider and more performance-focused than Sport/Si.",
      ["Civic", "Flush", "Square", "Strict Match"]
    ),
  ],
  aggressive: [
    pending(
      "Civic Aggressive Verified Photo Pending",
      "Sport/Si: 18x10 +25 / Type R: 18x10 +35-40",
      "Sport/Si: 265/35R18 / Type R: 285/35R18",
      "Aggressive Civic visuals should be verified carefully, especially for Type R fitment.",
      ["Civic", "Aggressive", "Square", "Strict Match"]
    ),
  ],
},
"S2000": {
  oemplus: [
    pending(
      "S2000 OEM+ Verified Photo Pending",
      "17x8 +50 / 17x9 +60",
      "225/45R17 / 255/40R17",
      "OEM+ S2000 should show a clean high-offset staggered setup with factory-plus proportions.",
      ["S2000", "OEM+", "Staggered", "Strict Match"]
    ),
  ],
  flush: [
    pending(
      "S2000 Flush Verified Photo Pending",
      "17x8.5 +45 / 17x9.5 +50",
      "225/45R17 / 255/40R17",
      "Flush S2000 should show a lowered, filled-out stance without excessive poke.",
      ["S2000", "Flush", "Staggered", "Strict Match"]
    ),
  ],
  aggressive: [
    pending(
      "S2000 Aggressive Verified Photo Pending",
      "17x9 +45 / 17x10 +50",
      "245/40R17 / 255/40R17",
      "Aggressive S2000 should show wide, track-inspired fitment with verified camber and fender clearance.",
      ["S2000", "Aggressive", "Staggered", "Strict Match"]
    ),
  ],
},
  "Artura": {
    oemplus: [],
    flush: [],
    aggressive: [],
  },
  "570S": {
    oemplus: [],
    flush: [],
    aggressive: [],
  },
  "720S": {
    oemplus: [],
    flush: [],
    aggressive: [],
  },
};
