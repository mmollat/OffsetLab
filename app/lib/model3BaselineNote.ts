/** The legacy Model 3 Performance default is newer. Scope its reference
 * explicitly rather than presenting the newer staggered package as universal.
 * Tesla US manuals, verified 2026-11-16:
 * https://www.tesla.com/ownersmanual/model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html
 * https://www.tesla.com/ownersmanual/2017_2023_model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html
 */
export function model3BaselineNote(make: string, model: string, trim: string, front: string, rear: string) {
  if (make !== "Tesla" || model !== "Model 3" || trim !== "Performance" ||
      front !== "20x9 +34" || rear !== "20x10 +45") return undefined;
  return "2024+ Model 3 Performance 20-inch baseline (US): 235/35R20 front, 275/30R20 rear. The 2017–2023 US manual lists a square 20x9 +34 with 235/35R20 on both axles. Existing links default to the newer baseline. Choose the stock baseline year group in Fitment or Compare to compare an older car.";
}
