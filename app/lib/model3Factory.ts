import type { TrimData } from "../data/fitment";

export type FactoryGeneration = "2017-2023" | "2024-plus";
export const DEFAULT_FACTORY_GENERATION: FactoryGeneration = "2024-plus";
export function readFactoryGeneration(value: string | null): FactoryGeneration {
  return value === "2017-2023" ? value : DEFAULT_FACTORY_GENERATION;
}
export function hasModel3FactoryChoices(make: string | null, model: string | null, trim: string) {
  return make === "Tesla" && model === "Model 3" && trim === "Performance";
}

/** US factory 20-inch specifications, not aftermarket recommendations.
 * Source manuals: see model3BaselineNote.ts. Earlier option uses the manual's
 * 2017–2023 coverage, not a claim that Performance was sold in every year.
 */
export function model3FactoryBaseline(base: TrimData["baseline"], generation: FactoryGeneration): TrimData["baseline"] {
  const older = generation === "2017-2023";
  return {
    ...base,
    front: "20x9 +34",
    rear: older ? "20x9 +34" : "20x10 +45",
    tire: "235/35R20",
    frontTire: "235/35R20",
    rearTire: older ? "235/35R20" : "275/30R20",
    note: older
      ? "2017–2023 manual · Performance 20-inch factory reference (US): square 20x9 +34 with 235/35R20 on both axles."
      : "2024+ Performance 20-inch factory reference (US): 20x9 +34 with 235/35R20 front; 20x10 +45 with 275/30R20 rear.",
  };
}
export function model3ConfigurationHint(configuration: "square" | "staggered", generation: FactoryGeneration) {
  const factory = (generation === "2017-2023") === (configuration === "square");
  return `${factory ? "Selected generation's factory layout" : "Aftermarket layout option"} • ${configuration === "square" ? "Rotation-friendly • Balanced handling" : "More rear traction • Stronger stance"}`;
}
