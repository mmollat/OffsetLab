import { modelSlug } from "../data/fitment";
import { getFitmentData } from "./getFitmentData";
import { getVehicleModels } from "./getVehicleModels";
import { isSupabaseConfigured } from "./supabase";

export type FitmentSeoPreset = {
  style: string;
  label: string;
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  verdict: string;
  risk: string;
};

export type FitmentSeoTrim = {
  trim: string;
  baselineFront: string;
  baselineRear: string;
  baselineTire: string;
  boltPattern: string;
  centerBore: string;
  presets: FitmentSeoPreset[];
};

export type FitmentSeoPage = {
  key: string;
  makeSlug: string;
  makeName: string;
  modelSlug: string;
  modelKey: string;
  modelName: string;
  urlPath: string;
  trims: FitmentSeoTrim[];
};

const styleLabels: Record<string, string> = {
  oemplus: "OEM+",
  flush: "Flush",
  aggressive: "Aggressive",
};

function formatUrlPath(makeSlug: string, modelSlugValue: string) {
  return `/fitment/${makeSlug}/${modelSlugValue}`;
}

export async function getFitmentSeoPages(): Promise<FitmentSeoPage[]> {
  if (!isSupabaseConfigured) return [];

  const [vehicleModels, fitmentData] = await Promise.all([
    getVehicleModels(),
    getFitmentData(),
  ]);

  return vehicleModels
    .map((vehicle) => {
      const trims = fitmentData[vehicle.model] ?? [];
      const makeSlug = modelSlug(vehicle.make);
      const modelSlugValue = modelSlug(vehicle.display_name ?? vehicle.model);
      const pageTrims = trims.map((trim) => ({
        trim: trim.trim,
        baselineFront: trim.baseline.front,
        baselineRear: trim.baseline.rear,
        baselineTire: trim.baseline.tire,
        boltPattern: trim.baseline.boltPattern,
        centerBore: trim.baseline.centerBore,
        presets: Object.entries(trim.presets).map(([style, preset]) => ({
          style,
          label: styleLabels[style] ?? style,
          front: preset.front,
          rear: preset.rear,
          frontTire: preset.frontTire,
          rearTire: preset.rearTire,
          verdict: preset.verdict,
          risk: preset.risk,
        })),
      }));

      return {
        key: `${makeSlug}/${modelSlugValue}`,
        makeSlug,
        makeName: vehicle.make,
        modelSlug: modelSlugValue,
        modelKey: vehicle.model,
        modelName: vehicle.display_name ?? vehicle.model,
        urlPath: formatUrlPath(makeSlug, modelSlugValue),
        trims: pageTrims,
      };
    })
    .filter((page) => page.trims.length > 0)
    .sort((a, b) => `${a.makeName} ${a.modelName}`.localeCompare(`${b.makeName} ${b.modelName}`));
}

export async function getFitmentSeoPage(makeSlug: string, modelSlugValue: string) {
  const pages = await getFitmentSeoPages();

  return (
    pages.find((page) => page.makeSlug === makeSlug && page.modelSlug === modelSlugValue) ??
    null
  );
}
