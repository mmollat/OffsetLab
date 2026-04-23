import type { ModelKey, StyleKey } from "./fitment";

export type GalleryBuild = {
  label: string;
  imageUrl: string;
  sourceName: string;
  sourceUrl: string;
  wheel: string;
  tire: string;
  suspension: string;
  note: string;
  tags: string[];
  match: "Exact Match" | "Close Visual Match" | "Reference";
};

/*
  v6.1 gallery rule:
  - Each model + style gets its own visual reference.
  - No more reusing the same image for OEM+ / Flush / Aggressive within the same model.
  - Images are externally linked only and credited.
  - If a host blocks hotlinking, replace only the imageUrl while keeping sourceUrl/sourceName.
*/

const img = {
  model3Oem: "https://agluxurywheels.com/img/gallery/tesla-model-3-agluxury-wheels-agl-vanquish-matte-highland-bronze-1.jpg",
  model3Flush: "https://cdn.shopify.com/s/files/1/0261/0065/9016/files/tesla-model-3-vossen-hf-5-wheels.jpg?v=1614303934",
  model3Aggressive: "https://cdn.shopify.com/s/files/1/0526/5322/8206/files/tesla-model-3-bc-forged-wheels.jpg?v=1720019127",

  modelYOem: "https://images.fitmentindustries.com/web-compressed/1689624-1-2020-y-tesla-standard-range-stock-air-suspension-xxr-571-bronze.jpg",
  modelYFlush: "https://images.fitmentindustries.com/thumb/2957778-1-2022-y-tesla-performance-stock-stock-rohana-rfx11-silver.jpg",
  modelYAggressive: "https://tsportline.com/cdn/shop/products/tesla-model-y-20-inch-overland-adventure-wheels.jpg?v=1712873127",

  modelSOem: "https://cdn.shopify.com/s/files/1/0526/5322/8206/files/IMG_4560.jpg?v=1720019127",
  modelSFlush: "https://i0.wp.com/strassewheels.com/wp-content/uploads/2022/10/Tesla-Model-S-Plaid-StrasseWheels-Mike08274-copy-3.jpg?resize=720%2C480&ssl=1",
  modelSAggressive: "https://strassewheels.com/wp-content/uploads/2022/10/Tesla-Model-S-Plaid-StrasseWheels-Mike08274-copy-7.jpg",

  modelXOem: "https://tsportline.com/cdn/shop/products/tesla-forged-aftermarket-wheels-mx117-t3117-ts117-ty117-web-1_4b0b2458-cf60-4acf-98b4-31080a798bd9_1200x.jpg?v=1721154248",
  modelXFlush: "https://tsportline.com/cdn/shop/products/tesla-model-x-22-inch-tss-flow-forged-wheels.jpg?v=1709927178",
  modelXAggressive: "https://tsportline.com/cdn/shop/products/tesla-model-x-22-inch-mx117-forged-wheels.jpg?v=1721154248",
};

export const galleryExamples: Record<ModelKey, Record<StyleKey, GalleryBuild[]>> = {
  "Model 3": {
    oemplus: [
      {
        label: "Model 3 OEM+ Bronze",
        imageUrl: img.model3Oem,
        sourceName: "AG Luxury Wheels",
        sourceUrl: "https://agluxurywheels.com/tesla-model-3-agluxury-wheels-agl-vanquish-flow-form-gallery.html",
        wheel: "20x9 / 20x10.5",
        tire: "Performance street tire",
        suspension: "Street stance",
        note: "Clean OEM+ visual reference with a sharp but livable stance.",
        tags: ["Model 3", "OEM+", "Clean"],
        match: "Reference",
      },
    ],
    flush: [
      {
        label: "Model 3 Flush Reference",
        imageUrl: img.model3Flush,
        sourceName: "Vossen",
        sourceUrl: "https://vossenwheels.com/galleries/tesla-model-3-hf-5/",
        wheel: "20-inch flush fitment",
        tire: "Performance street tire",
        suspension: "Street stance",
        note: "Model 3 visual reference with a filled-out flush look.",
        tags: ["Model 3", "Flush", "20-inch"],
        match: "Close Visual Match",
      },
    ],
    aggressive: [
      {
        label: "Model 3 Aggressive Reference",
        imageUrl: img.model3Aggressive,
        sourceName: "MODEL+",
        sourceUrl: "https://modelplusstudio.com/blogs/journal",
        wheel: "20-inch aggressive fitment",
        tire: "Performance street tire",
        suspension: "Lowered street stance",
        note: "Aggressive visual reference with stronger wheel presence.",
        tags: ["Model 3", "Aggressive", "Lowered"],
        match: "Close Visual Match",
      },
    ],
  },

  "Model Y": {
    oemplus: [
      {
        label: "Model Y OEM+ Daily",
        imageUrl: img.modelYOem,
        sourceName: "Fitment Industries",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/1689624/2020-tesla-y-xxr-571-oem-stock-goodyear-all-season",
        wheel: "20x9 +35",
        tire: "255/40R20",
        suspension: "OEM Stock",
        note: "Clean daily Model Y setup with conservative but improved stance.",
        tags: ["Model Y", "OEM+", "20x9"],
        match: "Close Visual Match",
      },
    ],
    flush: [
      {
        label: "Model Y Flush Wide",
        imageUrl: img.modelYFlush,
        sourceName: "Fitment Industries",
        sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/2957778/2022-tesla-y-rohana-rfx11-stock-suspension-michelin-pilot-sport-a-s-4",
        wheel: "20x10 +40",
        tire: "285/35R20",
        suspension: "Stock",
        note: "Wider Model Y reference with a clean flush look.",
        tags: ["Model Y", "Flush", "285"],
        match: "Close Visual Match",
      },
    ],
    aggressive: [
      {
        label: "Model Y Aggressive SUV",
        imageUrl: img.modelYAggressive,
        sourceName: "T Sportline",
        sourceUrl: "https://tsportline.com/collections/tesla-model-y-wheels",
        wheel: "20/21-inch aggressive SUV fitment",
        tire: "Performance SUV tire",
        suspension: "Street stance",
        note: "Aggressive Model Y visual reference with more SUV presence.",
        tags: ["Model Y", "Aggressive", "SUV"],
        match: "Reference",
      },
    ],
  },

  "Model S": {
    oemplus: [
      {
        label: "Model S Plaid OEM+",
        imageUrl: img.modelSOem,
        sourceName: "MODEL+",
        sourceUrl: "https://modelplusstudio.com/blogs/journal/2023-model-s-plaid-showcase-21-bc-forged-hca191s-aggressive-fitment-n2itive-suspension",
        wheel: "21x9.5 / 21x10.5",
        tire: "265/35R21 / 295/30R21",
        suspension: "Street stance",
        note: "Clean Plaid reference with conservative-to-flush fitment.",
        tags: ["Model S", "Plaid", "OEM+"],
        match: "Reference",
      },
    ],
    flush: [
      {
        label: "Model S Plaid Flush",
        imageUrl: img.modelSFlush,
        sourceName: "Strasse Wheels",
        sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/",
        wheel: "21x10 / 21x11.5",
        tire: "Performance street tire",
        suspension: "Street stance",
        note: "Premium Plaid reference with wide, clean, filled-out stance.",
        tags: ["Model S", "Flush", "Plaid"],
        match: "Close Visual Match",
      },
    ],
    aggressive: [
      {
        label: "Model S Plaid Aggressive",
        imageUrl: img.modelSAggressive,
        sourceName: "Strasse Wheels",
        sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/",
        wheel: "21x10 / 21x11.5",
        tire: "Wide performance tire",
        suspension: "Street stance",
        note: "Best visual match for a wide aggressive Plaid setup like 21x10 / 21x11.",
        tags: ["Model S", "Aggressive", "Wide Rear"],
        match: "Close Visual Match",
      },
    ],
  },

  "Model X": {
    oemplus: [
      {
        label: "Model X OEM+ 22",
        imageUrl: img.modelXOem,
        sourceName: "T Sportline",
        sourceUrl: "https://tsportline.com/products/mx117-tesla-model-x-wheel-set-of-4",
        wheel: "22x9.5 / 22x10.5",
        tire: "Performance SUV tire",
        suspension: "Street stance",
        note: "Clean Model X reference with premium 22-inch presence.",
        tags: ["Model X", "OEM+", "22-inch"],
        match: "Reference",
      },
    ],
    flush: [
      {
        label: "Model X Flush",
        imageUrl: img.modelXFlush,
        sourceName: "T Sportline",
        sourceUrl: "https://tsportline.com/collections/tesla-model-x-wheels",
        wheel: "22-inch flush fitment",
        tire: "Performance SUV tire",
        suspension: "Street stance",
        note: "Filled-out Model X visual reference with clean SUV stance.",
        tags: ["Model X", "Flush", "SUV"],
        match: "Close Visual Match",
      },
    ],
    aggressive: [
      {
        label: "Model X Aggressive 22",
        imageUrl: img.modelXAggressive,
        sourceName: "T Sportline",
        sourceUrl: "https://tsportline.com/products/mx117-tesla-model-x-wheel-set-of-4",
        wheel: "22-inch aggressive fitment",
        tire: "Performance SUV tire",
        suspension: "Street stance",
        note: "Aggressive Model X visual reference with strong wheel impact.",
        tags: ["Model X", "Aggressive", "Wide"],
        match: "Close Visual Match",
      },
    ],
  },
};
