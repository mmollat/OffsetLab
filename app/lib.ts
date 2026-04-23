import { baselines, presets, type StyleKey, type SuspensionKey, type VehicleBaseline } from '@/app/data/model3';

export type TireSpec = {
  width: number;
  aspectRatio: number;
  wheelDiameterIn: number;
};

export type CalculatedFitment = {
  baseline: VehicleBaseline;
  setupName: string;
  front: SideMetrics;
  rear: SideMetrics;
  visualAggression: number;
  drivability: number;
  riskLevel: 'Low' | 'Moderate' | 'High' | 'Very High';
  confidence: 'High' | 'Medium';
  bestFor: string;
  verdict: string;
  warnings: string[];
  note: string;
  alternate?: boolean;
};

export type SideMetrics = {
  wheel: string;
  tire: string;
  pokeMm: number;
  innerClearanceMm: number;
  diameterChangePct: number;
};

const INCH_TO_MM = 25.4;

export function parseTire(tire: string): TireSpec {
  const match = tire.match(/(\d{3})\/(\d{2})R(\d{2})/i);
  if (!match) {
    throw new Error(`Invalid tire format: ${tire}`);
  }

  return {
    width: Number(match[1]),
    aspectRatio: Number(match[2]),
    wheelDiameterIn: Number(match[3]),
  };
}

export function tireDiameterMm(tire: string): number {
  const spec = parseTire(tire);
  const sidewall = spec.width * (spec.aspectRatio / 100);
  return sidewall * 2 + spec.wheelDiameterIn * INCH_TO_MM;
}

export function widthInToMm(width: number): number {
  return width * INCH_TO_MM;
}

export function pokeChangeMm(oldWidthIn: number, oldOffset: number, newWidthIn: number, newOffset: number): number {
  const oldWidth = widthInToMm(oldWidthIn);
  const newWidth = widthInToMm(newWidthIn);
  return ((newWidth - oldWidth) / 2) + (oldOffset - newOffset);
}

export function innerClearanceChangeMm(oldWidthIn: number, oldOffset: number, newWidthIn: number, newOffset: number): number {
  const oldWidth = widthInToMm(oldWidthIn);
  const newWidth = widthInToMm(newWidthIn);
  return ((newWidth - oldWidth) / 2) - (oldOffset - newOffset);
}

function riskFrom(frontPoke: number, rearPoke: number, frontInner: number, rearInner: number, frontDiameterPct: number, rearDiameterPct: number): CalculatedFitment['riskLevel'] {
  const maxPoke = Math.max(frontPoke, rearPoke);
  const maxInnerLoss = Math.max(frontInner, rearInner);
  const maxDiameter = Math.max(Math.abs(frontDiameterPct), Math.abs(rearDiameterPct));
  const score = (maxPoke >= 25 ? 2 : maxPoke >= 15 ? 1 : 0)
    + (maxInnerLoss >= 12 ? 2 : maxInnerLoss >= 6 ? 1 : 0)
    + (maxDiameter >= 1.5 ? 2 : maxDiameter >= 1 ? 1 : 0);

  if (score >= 5) return 'Very High';
  if (score >= 3) return 'High';
  if (score >= 1) return 'Moderate';
  return 'Low';
}

function aggressionScore(frontPoke: number, rearPoke: number): number {
  const avg = (frontPoke + rearPoke) / 2;
  return Math.max(1, Math.min(10, Math.round(avg / 4)));
}

function drivabilityScore(risk: CalculatedFitment['riskLevel']): number {
  switch (risk) {
    case 'Low': return 9;
    case 'Moderate': return 7;
    case 'High': return 5;
    case 'Very High': return 3;
  }
}

function buildWarnings(frontInner: number, rearInner: number, frontDiameterPct: number, rearDiameterPct: number, style: StyleKey, suspension: SuspensionKey): string[] {
  const warnings: string[] = [];
  if (frontInner >= 6) warnings.push('Front inner clearance is tighter than stock.');
  if (rearInner >= 6) warnings.push('Rear inner clearance is tighter than stock.');
  if (Math.abs(frontDiameterPct) >= 1 || Math.abs(rearDiameterPct) >= 1) warnings.push('Tire diameter is meaningfully different from OEM.');
  if (style === 'Aggressive') warnings.push('Aggressive fitment may need more ride-height attention.');
  if (suspension === 'Coilovers') warnings.push('Lower ride heights can increase rub sensitivity at full compression.');
  return warnings;
}

export function getVehicleOptions() {
  return baselines;
}

export function getMatchingRecommendations(vehicleId: string, style: StyleKey, suspension: SuspensionKey) {
  return presets.filter((preset) => preset.vehicleId === vehicleId && preset.style === style && preset.suspension.includes(suspension));
}

export function calculateRecommendation(vehicleId: string, style: StyleKey, suspension: SuspensionKey): CalculatedFitment | null {
  const baseline = baselines.find((item) => item.id === vehicleId);
  if (!baseline) return null;

  const [chosen] = getMatchingRecommendations(vehicleId, style, suspension);
  if (!chosen) return null;

  const frontPoke = pokeChangeMm(baseline.stockFrontWidthIn, baseline.stockFrontOffset, chosen.frontWidthIn, chosen.frontOffset);
  const rearPoke = pokeChangeMm(baseline.stockRearWidthIn, baseline.stockRearOffset, chosen.rearWidthIn, chosen.rearOffset);
  const frontInner = innerClearanceChangeMm(baseline.stockFrontWidthIn, baseline.stockFrontOffset, chosen.frontWidthIn, chosen.frontOffset);
  const rearInner = innerClearanceChangeMm(baseline.stockRearWidthIn, baseline.stockRearOffset, chosen.rearWidthIn, chosen.rearOffset);
  const frontDiameterPct = ((tireDiameterMm(chosen.frontTire) - tireDiameterMm(baseline.stockFrontTire)) / tireDiameterMm(baseline.stockFrontTire)) * 100;
  const rearDiameterPct = ((tireDiameterMm(chosen.rearTire) - tireDiameterMm(baseline.stockRearTire)) / tireDiameterMm(baseline.stockRearTire)) * 100;
  const riskLevel = riskFrom(frontPoke, rearPoke, frontInner, rearInner, frontDiameterPct, rearDiameterPct);
  const visualAggression = aggressionScore(frontPoke, rearPoke);
  const drivability = drivabilityScore(riskLevel);
  const warnings = buildWarnings(frontInner, rearInner, frontDiameterPct, rearDiameterPct, style, suspension);

  return {
    baseline,
    setupName: chosen.setupType,
    front: {
      wheel: `${chosen.frontDiameterIn}x${chosen.frontWidthIn} +${chosen.frontOffset}`,
      tire: chosen.frontTire,
      pokeMm: Number(frontPoke.toFixed(1)),
      innerClearanceMm: Number(frontInner.toFixed(1)),
      diameterChangePct: Number(frontDiameterPct.toFixed(2)),
    },
    rear: {
      wheel: `${chosen.rearDiameterIn}x${chosen.rearWidthIn} +${chosen.rearOffset}`,
      tire: chosen.rearTire,
      pokeMm: Number(rearPoke.toFixed(1)),
      innerClearanceMm: Number(rearInner.toFixed(1)),
      diameterChangePct: Number(rearDiameterPct.toFixed(2)),
    },
    visualAggression,
    drivability,
    riskLevel,
    confidence: chosen.alternate ? 'Medium' : 'High',
    bestFor: style === 'OEM+' ? 'Daily' : style === 'Flush' ? 'Daily / Show' : 'Daily / Enthusiast',
    verdict: style === 'Aggressive'
      ? 'Strong aggressive stance with manageable compromise when ride height is dialed in.'
      : style === 'Flush'
        ? 'Balanced stance with good drivability and clean fender fill.'
        : 'Close-to-stock behavior with a cleaner overall look.',
    warnings,
    note: chosen.note,
    alternate: chosen.alternate,
  };
}

export function calculateCustomFitment(params: {
  vehicleId: string;
  frontWidthIn: number;
  frontDiameterIn: number;
  frontOffset: number;
  rearWidthIn: number;
  rearDiameterIn: number;
  rearOffset: number;
  frontTire: string;
  rearTire: string;
}) {
  const baseline = baselines.find((item) => item.id === params.vehicleId);
  if (!baseline) return null;

  const frontPoke = pokeChangeMm(baseline.stockFrontWidthIn, baseline.stockFrontOffset, params.frontWidthIn, params.frontOffset);
  const rearPoke = pokeChangeMm(baseline.stockRearWidthIn, baseline.stockRearOffset, params.rearWidthIn, params.rearOffset);
  const frontInner = innerClearanceChangeMm(baseline.stockFrontWidthIn, baseline.stockFrontOffset, params.frontWidthIn, params.frontOffset);
  const rearInner = innerClearanceChangeMm(baseline.stockRearWidthIn, baseline.stockRearOffset, params.rearWidthIn, params.rearOffset);
  const frontDiameterPct = ((tireDiameterMm(params.frontTire) - tireDiameterMm(baseline.stockFrontTire)) / tireDiameterMm(baseline.stockFrontTire)) * 100;
  const rearDiameterPct = ((tireDiameterMm(params.rearTire) - tireDiameterMm(baseline.stockRearTire)) / tireDiameterMm(baseline.stockRearTire)) * 100;
  const riskLevel = riskFrom(frontPoke, rearPoke, frontInner, rearInner, frontDiameterPct, rearDiameterPct);

  return {
    baseline,
    front: {
      wheel: `${params.frontDiameterIn}x${params.frontWidthIn} +${params.frontOffset}`,
      tire: params.frontTire,
      pokeMm: Number(frontPoke.toFixed(1)),
      innerClearanceMm: Number(frontInner.toFixed(1)),
      diameterChangePct: Number(frontDiameterPct.toFixed(2)),
    },
    rear: {
      wheel: `${params.rearDiameterIn}x${params.rearWidthIn} +${params.rearOffset}`,
      tire: params.rearTire,
      pokeMm: Number(rearPoke.toFixed(1)),
      innerClearanceMm: Number(rearInner.toFixed(1)),
      diameterChangePct: Number(rearDiameterPct.toFixed(2)),
    },
    riskLevel,
  };
}
