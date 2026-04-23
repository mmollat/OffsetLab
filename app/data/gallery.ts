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

const model3Image = "https://agluxurywheels.com/img/gallery/tesla-model-3-agluxury-wheels-agl-vanquish-matte-highland-bronze-1.jpg";
const modelYFlush = "https://images.fitmentindustries.com/web-compressed/1689624-1-2020-y-tesla-standard-range-stock-air-suspension-xxr-571-bronze.jpg";
const modelYAggressive = "https://images.fitmentindustries.com/thumb/2957778-1-2022-y-tesla-performance-stock-stock-rohana-rfx11-silver.jpg";
const modelSStrasse = "https://i0.wp.com/strassewheels.com/wp-content/uploads/2022/10/Tesla-Model-S-Plaid-StrasseWheels-Mike08274-copy-3.jpg?resize=720%2C480&ssl=1";
const modelSModelPlus = "https://cdn.shopify.com/s/files/1/0526/5322/8206/files/IMG_4560.jpg?v=1720019127";
const modelXTsport = "https://tsportline.com/cdn/shop/products/tesla-forged-aftermarket-wheels-mx117-t3117-ts117-ty117-web-1_4b0b2458-cf60-4acf-98b4-31080a798bd9_1200x.jpg?v=1721154248";

export const galleryExamples: Record<ModelKey, Record<StyleKey, GalleryBuild[]>> = {
  "Model 3": {
    oemplus: [
      { label: "Model 3 OEM+ Bronze", imageUrl: model3Image, sourceName: "AG Luxury Wheels", sourceUrl: "https://agluxurywheels.com/tesla-model-3-agluxury-wheels-agl-vanquish-flow-form-gallery.html", wheel: "20x9 / 20x10.5", tire: "Performance street tire", suspension: "Street stance", note: "Clean OEM+ to flush visual reference for Model 3.", tags: ["Model 3", "OEM+", "Bronze"], match: "Close Visual Match" },
    ],
    flush: [
      { label: "Model 3 Flush Reference", imageUrl: model3Image, sourceName: "AG Luxury Wheels", sourceUrl: "https://agluxurywheels.com/tesla-model-3-agluxury-wheels-agl-vanquish-flow-form-gallery.html", wheel: "20x9 / 20x10.5", tire: "Performance street tire", suspension: "Street stance", note: "Good visual reference for a filled-out Model 3 stance.", tags: ["Model 3", "Flush"], match: "Close Visual Match" },
    ],
    aggressive: [
      { label: "Model 3 Aggressive Bronze", imageUrl: model3Image, sourceName: "AG Luxury Wheels", sourceUrl: "https://agluxurywheels.com/tesla-model-3-agluxury-wheels-agl-vanquish-flow-form-gallery.html", wheel: "20x9 / 20x10.5", tire: "Performance street tire", suspension: "Street stance", note: "Strong reference for staggered Model 3 fitment with concavity.", tags: ["Model 3", "Aggressive"], match: "Close Visual Match" },
    ],
  },
  "Model Y": {
    oemplus: [
      { label: "Model Y OEM+ / Flush", imageUrl: modelYFlush, sourceName: "Fitment Industries", sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/1689624/2020-tesla-y-xxr-571-oem-stock-goodyear-all-season", wheel: "20x9 +35", tire: "255/40R20", suspension: "OEM Stock", note: "Clean daily Model Y setup with no spacers and flush stance.", tags: ["Model Y", "OEM+", "20x9"], match: "Close Visual Match" },
    ],
    flush: [
      { label: "Model Y Flush", imageUrl: modelYFlush, sourceName: "Fitment Industries", sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/1689624/2020-tesla-y-xxr-571-oem-stock-goodyear-all-season", wheel: "20x9 +35", tire: "255/40R20", suspension: "OEM Stock", note: "Real Model Y example showing a clean flush daily fitment.", tags: ["Model Y", "Flush"], match: "Close Visual Match" },
      { label: "Model Y Wide Flush", imageUrl: modelYAggressive, sourceName: "Fitment Industries", sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/2957778/2022-tesla-y-rohana-rfx11-stock-suspension-michelin-pilot-sport-a-s-4", wheel: "20x10 +40", tire: "285/35R20", suspension: "Stock", note: "Wider Model Y setup with strong stance and practical ride height.", tags: ["Model Y", "20x10", "285"], match: "Close Visual Match" },
    ],
    aggressive: [
      { label: "Model Y Aggressive Wide", imageUrl: modelYAggressive, sourceName: "Fitment Industries", sourceUrl: "https://www.fitmentindustries.com/wheel-offset-gallery/2957778/2022-tesla-y-rohana-rfx11-stock-suspension-michelin-pilot-sport-a-s-4", wheel: "20x10 +40", tire: "285/35R20", suspension: "Stock", note: "Wide Model Y reference with strong visual presence.", tags: ["Model Y", "Aggressive", "285"], match: "Close Visual Match" },
    ],
  },
  "Model S": {
    oemplus: [
      { label: "Model S Plaid Clean 21", imageUrl: modelSStrasse, sourceName: "Strasse Wheels", sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/", wheel: "21x10 / 21x11.5", tire: "Performance street tire", suspension: "Street stance", note: "Premium Model S Plaid reference with wide staggered fitment.", tags: ["Model S", "Plaid", "21"], match: "Reference" },
    ],
    flush: [
      { label: "Model S Plaid Wide Flush", imageUrl: modelSStrasse, sourceName: "Strasse Wheels", sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/", wheel: "21x10 / 21x11.5", tire: "Performance street tire", suspension: "Street stance", note: "Wide Plaid visual reference with a clean, premium stance.", tags: ["Model S", "Flush", "Wide"], match: "Close Visual Match" },
    ],
    aggressive: [
      { label: "Model S Plaid Aggressive", imageUrl: modelSStrasse, sourceName: "Strasse Wheels", sourceUrl: "https://strassewheels.com/case/tesla-model-s-plaid/", wheel: "21x10 / 21x11.5", tire: "Performance street tire", suspension: "Street stance", note: "Strong visual reference for 21x10 / 21x11 aggressive Plaid stance.", tags: ["Model S", "Aggressive", "Plaid"], match: "Close Visual Match" },
      { label: "Model S Plaid BC Forged", imageUrl: modelSModelPlus, sourceName: "MODEL+", sourceUrl: "https://modelplusstudio.com/blogs/journal/2023-model-s-plaid-showcase-21-bc-forged-hca191s-aggressive-fitment-n2itive-suspension", wheel: "21x9.5 / 21x10.5", tire: "265/35R21 / 295/30R21", suspension: "N2itive suspension", note: "Aggressive Model S Plaid reference with forged wheels and lowered stance.", tags: ["Model S", "Plaid", "Aggressive"], match: "Close Visual Match" },
    ],
  },
  "Model X": {
    oemplus: [
      { label: "Model X OEM+ 22", imageUrl: modelXTsport, sourceName: "T Sportline", sourceUrl: "https://tsportline.com/products/mx117-tesla-model-x-wheel-set-of-4", wheel: "22x9.5 / 22x10.5", tire: "Performance SUV tire", suspension: "Street stance", note: "Clean Model X reference with premium 22-inch wheel presence.", tags: ["Model X", "OEM+"], match: "Reference" },
    ],
    flush: [
      { label: "Model X Flush 22", imageUrl: modelXTsport, sourceName: "T Sportline", sourceUrl: "https://tsportline.com/products/mx117-tesla-model-x-wheel-set-of-4", wheel: "22x9.5 / 22x10.5", tire: "Performance SUV tire", suspension: "Street stance", note: "Good visual reference for a filled-out Model X stance.", tags: ["Model X", "Flush"], match: "Close Visual Match" },
    ],
    aggressive: [
      { label: "Model X Aggressive 22", imageUrl: modelXTsport, sourceName: "T Sportline", sourceUrl: "https://tsportline.com/products/mx117-tesla-model-x-wheel-set-of-4", wheel: "22x9.5 / 22x10.5", tire: "Performance SUV tire", suspension: "Street stance", note: "Strong Model X visual reference with 22-inch wheel impact.", tags: ["Model X", "Aggressive"], match: "Close Visual Match" },
    ],
  },
};
