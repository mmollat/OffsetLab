export type StyleKey = 'OEM+' | 'Flush' | 'Aggressive';
export type SuspensionKey = 'Stock' | 'Lowering Springs' | 'Coilovers';

export type VehicleBaseline = {
  id: string;
  yearRange: string;
  make: 'Tesla';
  model: 'Model 3';
  trim: 'RWD' | 'Long Range AWD' | 'Performance';
  boltPattern: string;
  centerBoreMm: number;
  threadSpec: string;
  torqueLbFt: number;
  stockFrontWidthIn: number;
  stockFrontDiameterIn: number;
  stockFrontOffset: number;
  stockRearWidthIn: number;
  stockRearDiameterIn: number;
  stockRearOffset: number;
  stockFrontTire: string;
  stockRearTire: string;
};

export type PresetRecommendation = {
  vehicleId: string;
  style: StyleKey;
  suspension: SuspensionKey[];
  setupType: string;
  frontWidthIn: number;
  frontDiameterIn: number;
  frontOffset: number;
  rearWidthIn: number;
  rearDiameterIn: number;
  rearOffset: number;
  frontTire: string;
  rearTire: string;
  note: string;
  alternate?: boolean;
};

export const baselines: VehicleBaseline[] = [
  {
    id: 'model3-rwd-2021-2023',
    yearRange: '2021-2023',
    make: 'Tesla',
    model: 'Model 3',
    trim: 'RWD',
    boltPattern: '5x114.3',
    centerBoreMm: 64.1,
    threadSpec: '14x1.50',
    torqueLbFt: 129,
    stockFrontWidthIn: 18,
    stockFrontDiameterIn: 18,
    stockFrontOffset: 40,
    stockRearWidthIn: 18,
    stockRearDiameterIn: 18,
    stockRearOffset: 40,
    stockFrontTire: '235/45R18',
    stockRearTire: '235/45R18',
  },
  {
    id: 'model3-lr-2021-2023',
    yearRange: '2021-2023',
    make: 'Tesla',
    model: 'Model 3',
    trim: 'Long Range AWD',
    boltPattern: '5x114.3',
    centerBoreMm: 64.1,
    threadSpec: '14x1.50',
    torqueLbFt: 129,
    stockFrontWidthIn: 18,
    stockFrontDiameterIn: 18,
    stockFrontOffset: 40,
    stockRearWidthIn: 18,
    stockRearDiameterIn: 18,
    stockRearOffset: 40,
    stockFrontTire: '235/45R18',
    stockRearTire: '235/45R18',
  },
  {
    id: 'model3-perf-2021-2023',
    yearRange: '2021-2023',
    make: 'Tesla',
    model: 'Model 3',
    trim: 'Performance',
    boltPattern: '5x114.3',
    centerBoreMm: 64.1,
    threadSpec: '14x1.50',
    torqueLbFt: 129,
    stockFrontWidthIn: 9,
    stockFrontDiameterIn: 20,
    stockFrontOffset: 34,
    stockRearWidthIn: 9,
    stockRearDiameterIn: 20,
    stockRearOffset: 34,
    stockFrontTire: '235/35R20',
    stockRearTire: '235/35R20',
  },
];

export const presets: PresetRecommendation[] = [
  {
    vehicleId: 'model3-rwd-2021-2023',
    style: 'OEM+',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'OEM+ Daily',
    frontWidthIn: 8.5,
    frontDiameterIn: 19,
    frontOffset: 35,
    rearWidthIn: 8.5,
    rearDiameterIn: 19,
    rearOffset: 35,
    frontTire: '245/40R19',
    rearTire: '245/40R19',
    note: 'Clean upgrade with near-stock manners and low hassle.',
  },
  {
    vehicleId: 'model3-rwd-2021-2023',
    style: 'Flush',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'Flush Daily',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 30,
    rearWidthIn: 9.5,
    rearDiameterIn: 19,
    rearOffset: 30,
    frontTire: '265/35R19',
    rearTire: '265/35R19',
    note: 'Balanced stance, filled-out fenders, and very daily-friendly.',
  },
  {
    vehicleId: 'model3-rwd-2021-2023',
    style: 'Aggressive',
    suspension: ['Lowering Springs', 'Coilovers'],
    setupType: 'Aggressive Daily',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 25,
    rearWidthIn: 10.5,
    rearDiameterIn: 19,
    rearOffset: 35,
    frontTire: '265/35R19',
    rearTire: '285/35R19',
    note: 'Noticeably stronger stance. Best with ride-height awareness.',
  },
  {
    vehicleId: 'model3-lr-2021-2023',
    style: 'OEM+',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'OEM+ Daily',
    frontWidthIn: 8.5,
    frontDiameterIn: 19,
    frontOffset: 35,
    rearWidthIn: 8.5,
    rearDiameterIn: 19,
    rearOffset: 35,
    frontTire: '245/40R19',
    rearTire: '245/40R19',
    note: 'Close to stock behavior with a cleaner look.',
  },
  {
    vehicleId: 'model3-lr-2021-2023',
    style: 'Flush',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'Flush Daily',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 30,
    rearWidthIn: 9.5,
    rearDiameterIn: 19,
    rearOffset: 30,
    frontTire: '265/35R19',
    rearTire: '265/35R19',
    note: 'One of the best all-around enthusiast fitments.',
  },
  {
    vehicleId: 'model3-lr-2021-2023',
    style: 'Aggressive',
    suspension: ['Lowering Springs', 'Coilovers'],
    setupType: 'Aggressive Daily',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 25,
    rearWidthIn: 10.5,
    rearDiameterIn: 19,
    rearOffset: 35,
    frontTire: '265/35R19',
    rearTire: '285/35R19',
    note: 'More visual presence with tighter clearances up front.',
  },
  {
    vehicleId: 'model3-perf-2021-2023',
    style: 'OEM+',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'OEM+ Daily',
    frontWidthIn: 8.5,
    frontDiameterIn: 19,
    frontOffset: 35,
    rearWidthIn: 8.5,
    rearDiameterIn: 19,
    rearOffset: 35,
    frontTire: '245/40R19',
    rearTire: '245/40R19',
    note: 'Softer visual than stock 20s but easier to live with day to day.',
  },
  {
    vehicleId: 'model3-perf-2021-2023',
    style: 'Flush',
    suspension: ['Stock', 'Lowering Springs', 'Coilovers'],
    setupType: 'Flush Daily',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 30,
    rearWidthIn: 9.5,
    rearDiameterIn: 19,
    rearOffset: 30,
    frontTire: '265/35R19',
    rearTire: '265/35R19',
    note: 'Strong daily fitment with a filled-out stance and low drama.',
  },
  {
    vehicleId: 'model3-perf-2021-2023',
    style: 'Aggressive',
    suspension: ['Lowering Springs', 'Coilovers'],
    setupType: 'Aggressive Daily',
    frontWidthIn: 9,
    frontDiameterIn: 20,
    frontOffset: 25,
    rearWidthIn: 10.5,
    rearDiameterIn: 20,
    rearOffset: 38,
    frontTire: '245/35R20',
    rearTire: '285/30R20',
    note: 'Strong visual stance with manageable compromise when dialed in.',
  },
  {
    vehicleId: 'model3-perf-2021-2023',
    style: 'Aggressive',
    suspension: ['Coilovers'],
    setupType: 'Aggressive Square Alternate',
    frontWidthIn: 9.5,
    frontDiameterIn: 19,
    frontOffset: 25,
    rearWidthIn: 9.5,
    rearDiameterIn: 19,
    rearOffset: 25,
    frontTire: '275/35R19',
    rearTire: '275/35R19',
    note: 'Track-inspired square setup with more front clearance sensitivity.',
    alternate: true,
  },
];
