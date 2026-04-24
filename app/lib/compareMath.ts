/*
  Offset Lab Compare Math v1

  Purpose:
  Calculate wheel position difference between OEM and selected setup.

  Formula concept:
  - Wheel width converted inches → mm
  - Half width change affects both inner and outer position
  - Offset change moves wheel in/out

  Positive outerChange = new wheel pokes outward more
  Positive innerClearanceChange = more inner clearance
  Negative innerClearanceChange = less inner clearance
*/

export type WheelSpec = {
  width: number;   // inches, example 9.5
  offset: number;  // mm, example 30
};

export type CompareResult = {
  widthChangeMm: number;
  outerChangeMm: number;
  innerClearanceChangeMm: number;
  trackChangeMm: number;
};

const INCH_TO_MM = 25.4;

export function compareWheelFitment(
  oem: WheelSpec,
  selected: WheelSpec
): CompareResult {
  const oemWidthMm = oem.width * INCH_TO_MM;
  const selectedWidthMm = selected.width * INCH_TO_MM;

  const widthChangeMm = selectedWidthMm - oemWidthMm;
  const halfWidthChangeMm = widthChangeMm / 2;
  const offsetChangeMm = selected.offset - oem.offset;

  // Lower offset pushes wheel outward.
  const outerChangeMm = halfWidthChangeMm - offsetChangeMm;

  // Positive means more inner clearance, negative means less.
  const innerClearanceChangeMm = -(halfWidthChangeMm + offsetChangeMm);

  // Per axle track width change is outer change per side x2.
  const trackChangeMm = outerChangeMm * 2;

  return {
    widthChangeMm: Math.round(widthChangeMm),
    outerChangeMm: Math.round(outerChangeMm),
    innerClearanceChangeMm: Math.round(innerClearanceChangeMm),
    trackChangeMm: Math.round(trackChangeMm),
  };
}

export function parseWheelSpec(spec: string): WheelSpec | null {
  /*
    Supports examples:
    - 20x9 +25
    - 20x10.5 +38
    - 19x9.5 ET20
    - 20x10 ET15
  */

  const widthMatch = spec.match(/x\s*(\d+(?:\.\d+)?)/i);
  const offsetMatch = spec.match(/(?:ET|\+)\s*(-?\d+)/i);

  if (!widthMatch || !offsetMatch) return null;

  return {
    width: Number(widthMatch[1]),
    offset: Number(offsetMatch[1]),
  };
}
