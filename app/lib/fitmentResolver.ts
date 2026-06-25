import {
  ConfigurationKey,
  DrivingGoalKey,
  MakeKey,
  ModelKey,
  Preset,
  StyleKey,
} from "../data/fitment";

export type { ConfigurationKey, DrivingGoalKey };

type SquareOverride = {
  front: string;
  rear: string;
  frontTire: string;
  rearTire: string;
  note?: string;
};

type GoalOverrideMap = Partial<Record<ModelKey, Partial<Record<StyleKey, SquareOverride>>>>;

const squareOverrides: GoalOverrideMap = {
  "Model 3": {
    oemplus: {
      front: "20x8.5 +35",
      rear: "20x8.5 +35",
      frontTire: "235/35R20",
      rearTire: "235/35R20",
      note: "Factory-style square Tesla Model 3 setup.",
    },
    flush: {
      front: "19x9.5 +30",
      rear: "19x9.5 +30",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Square flush alternative for better rotation and balanced handling.",
    },
    aggressive: {
      front: "19x9.5 +22",
      rear: "19x9.5 +22",
      frontTire: "265/35R19",
      rearTire: "265/35R19",
      note: "Aggressive square Tesla setup with improved balance, rotation capability, and cleaner real-world street fitment.",
    },
  },
  "Model Y": {
    oemplus: {
      front: "21x9.5 +40",
      rear: "21x9.5 +40",
      frontTire: "255/35R21",
      rearTire: "255/35R21",
      note: "Factory-style square Tesla Model Y setup.",
    },
    flush: {
      front: "20x9.5 +35",
      rear: "20x9.5 +35",
      frontTire: "265/40R20",
      rearTire: "265/40R20",
      note: "Square flush alternative for better rotation and balanced handling.",
    },
    aggressive: {
      front: "21x9.5 +30",
      rear: "21x9.5 +30",
      frontTire: "275/35R21",
      rearTire: "275/35R21",
      note: "Square aggressive Tesla setup prioritizing balance and rotation over rear stagger.",
    },
  },
  "Model S": {
    flush: {
      front: "21x9.5 +35",
      rear: "21x9.5 +35",
      frontTire: "265/35R21",
      rearTire: "265/35R21",
      note: "Square alternative for owners prioritizing rotation and balance over rear stagger.",
    },
    aggressive: {
      front: "21x10 +30",
      rear: "21x10 +30",
      frontTire: "275/35R21",
      rearTire: "275/35R21",
      note: "Square aggressive alternative for more balanced handling and tire rotation.",
    },
  },
  "Model X": {
    flush: {
      front: "22x10 +30",
      rear: "22x10 +30",
      frontTire: "275/35R22",
      rearTire: "275/35R22",
      note: "Square alternative for owners prioritizing rotation and balanced fitment.",
    },
    aggressive: {
      front: "22x10.5 +28",
      rear: "22x10.5 +28",
      frontTire: "285/35R22",
      rearTire: "285/35R22",
      note: "Square aggressive alternative for more balanced handling and tire rotation.",
    },
  },
  M3: {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW M3 OEM+ square setup with factory-like balance and easy rotation.",
    },
    flush: {
      front: "20x10 ET15",
      rear: "20x10 ET15",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M3 square street setup. Popular for track-minded owners who still want a strong visual stance.",
    },
    aggressive: {
      front: "20x10 ET12",
      rear: "20x10 ET12",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M3 aggressive square setup prioritizing front-end bite, rotation, and balance.",
    },
  },
  M4: {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW M4 OEM+ square setup with factory-like balance and easy rotation.",
    },
    flush: {
      front: "20x10 ET15",
      rear: "20x10 ET15",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M4 square street setup. Popular for track-minded owners who still want a strong visual stance.",
    },
    aggressive: {
      front: "20x10 ET12",
      rear: "20x10 ET12",
      frontTire: "285/30R20",
      rearTire: "285/30R20",
      note: "BMW M4 aggressive square setup prioritizing front-end bite, rotation, and balance.",
    },
  },
};

const trackOverrides: GoalOverrideMap = {
  "Model 3": {
    oemplus: {
      front: "19x9.5 +30",
      rear: "19x9.5 +30",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Most track-focused Model 3 drivers run square setups for balance and tire rotation.",
    },
    flush: {
      front: "19x9.5 +25",
      rear: "19x9.5 +25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased square Model 3 setup with strong balance and repeatability.",
    },
    aggressive: {
      front: "18x10 +25",
      rear: "18x10 +25",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive track-focused Model 3 square setup prioritizing grip, rotation, and consistency.",
    },
  },
  "Model Y": {
    oemplus: {
      front: "19x9.5 +35",
      rear: "19x9.5 +35",
      frontTire: "275/40R19",
      rearTire: "275/40R19",
      note: "Most track-focused Model Y setups stay square for consistency and tire rotation.",
    },
    flush: {
      front: "19x9.5 +35",
      rear: "19x9.5 +35",
      frontTire: "275/40R19",
      rearTire: "275/40R19",
      note: "Track-biased Model Y square setup focused on consistency and balance.",
    },
    aggressive: {
      front: "20x10 +30",
      rear: "20x10 +30",
      frontTire: "285/35R20",
      rearTire: "285/35R20",
      note: "Aggressive square Model Y track setup emphasizing front-end support and repeatability.",
    },
  },
  M3: {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW track setups prioritize rotation and consistency over staggered grip.",
    },
    flush: {
      front: "19x10 ET25",
      rear: "19x10 ET25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased BMW M3 square setup with neutral handling and rotation flexibility.",
    },
    aggressive: {
      front: "18x10.5 ET20",
      rear: "18x10.5 ET20",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive BMW M3 square track setup for maximum front-end bite and consistency.",
    },
  },
  M4: {
    oemplus: {
      front: "19x9.5 ET20",
      rear: "19x9.5 ET20",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "BMW track setups prioritize rotation and consistency over staggered grip.",
    },
    flush: {
      front: "19x10 ET25",
      rear: "19x10 ET25",
      frontTire: "275/35R19",
      rearTire: "275/35R19",
      note: "Track-biased BMW M4 square setup with neutral handling and rotation flexibility.",
    },
    aggressive: {
      front: "18x10.5 ET20",
      rear: "18x10.5 ET20",
      frontTire: "295/35R18",
      rearTire: "295/35R18",
      note: "Aggressive BMW M4 square track setup for maximum front-end bite and consistency.",
    },
  },
};

export function getRecommendedConfiguration(
  model: ModelKey,
  goal: DrivingGoalKey = "street"
): ConfigurationKey {
  if (goal === "track") return "square";
  if (model === "Model 3" || model === "Model Y" || model === "Civic") return "square";
  return "staggered";
}

export function getConfigurationHint(
  model: ModelKey,
  configuration: ConfigurationKey,
  goal: DrivingGoalKey
) {
  const recommended = getRecommendedConfiguration(model, goal);

  if (goal === "track") {
    if (configuration === "square") return "Track-preferred • Rotation-friendly • Balanced handling";
    return "Track-optional • More rear traction • Can increase understeer";
  }

  if (configuration === "square") {
    if (recommended === "square") return "Factory default • Rotation-friendly • Balanced handling";
    return "Rotation-friendly • Balanced handling • Popular for track use";
  }

  if (recommended === "staggered") return "Factory default • More rear traction • Stronger stance";
  return "Optional for this platform • More rear traction • Stronger stance";
}

export function getGoalMessage(make: MakeKey) {
  if (make === "BMW") return "Track setups prioritize rotation and consistency over staggered grip.";
  if (make === "Tesla") return "Most track drivers run square setups for balance and tire rotation.";
  return "Track setups prioritize performance, balance, and repeatability.";
}

export function resolveDisplayedFitment({
  preset,
  model,
  make,
  style,
  goal,
  configuration,
}: {
  preset: Preset | undefined;
  model: ModelKey | null;
  make: MakeKey | null;
  style: StyleKey;
  goal: DrivingGoalKey;
  configuration: ConfigurationKey;
}): Preset | null {
  if (!preset || !model || !make) return null;
  if (configuration !== "square") return preset;

  const variant = preset.variants?.find(
    (item) => item.goal === goal && item.configuration === configuration
  );
  const override = variant ?? (goal === "track" ? trackOverrides : squareOverrides)[model]?.[style];
  const squareWheel = override?.front ?? preset.front;
  const squareRearWheel = override?.rear ?? squareWheel;
  const squareTire = override?.frontTire ?? preset.frontTire;
  const squareRearTire = override?.rearTire ?? squareTire;
  const note =
    override?.note ??
    "Square setup selected: same wheel and tire sizing front and rear for simpler rotation and a more balanced configuration.";
  const goalPrefix = goal === "track" ? "Track Setup" : "Square Setup";
  const goalSubtitle = goal === "track" ? "Performance-focused square configuration" : "Same size front and rear";

  return {
    ...preset,
    title: `${preset.title} • ${goalPrefix}`,
    subtitle: `${preset.subtitle} • ${goalSubtitle}`,
    front: squareWheel,
    rear: squareRearWheel,
    frontTire: squareTire,
    rearTire: squareRearTire,
    pokeRear: preset.pokeFront,
    innerRear: preset.innerFront,
    verdict: `${preset.verdict} ${note}${goal === "track" ? ` ${getGoalMessage(make)}` : ""}`,
    warnings: Array.from(
      new Set([
        ...preset.warnings,
        goal === "track"
          ? "Track mode uses performance-biased square presets where available."
          : "Square setup selected with platform-aware same-size front/rear specs.",
      ])
    ),
    alternate: preset.alternate,
  };
}
