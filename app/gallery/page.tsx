"use client";

import { useEffect, useMemo, useState } from "react";
import { StyleKey } from "../data/fitment";
import { galleryExamples } from "../data/gallery";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { supabase } from "../lib/supabase";

const styleLabels: Record<StyleKey, string> = {
  oemplus: "OEM+",
  flush: "Flush",
  aggressive: "Aggressive",
};

type GalleryBuild = {
  id: string;
  year?: string;
  label: string;
  imageUrl: string;
  sourceType: "community" | "reference";
  sourceName: string;
  sourceUrl?: string;
  wheel: string;
  tire: string;
  note?: string;
  tags: string[];
  match: string;
  make: string;
  model: string;
  trim?: string;
  frontWheel: string;
  rearWheel: string;
  frontTire: string;
  rearTire: string;
  suspension?: string;
  style: StyleKey;
};

type SubmissionRow = {
  id: string | number;
  year: string | number | null;
  make: string | null;
  model: string | null;
  trim: string | null;
  fitment_style: string | null;
  front_wheel: string | null;
  rear_wheel: string | null;
  front_tire: string | null;
  rear_tire: string | null;
  suspension: string | null;
  image_url: string | null;
  notes: string | null;
  instagram_handle: string | null;
};

function normalizeStyle(style: string): StyleKey {
  const value = style.toLowerCase();

  if (value.includes("oem")) return "oemplus";
  if (value.includes("flush")) return "flush";
  return "aggressive";
}

function combineFitment(front: string | null, rear: string | null) {
  const frontValue = String(front || "").trim();
  const rearValue = String(rear || "").trim();

  if (!frontValue && !rearValue) return "Not provided";
  if (!rearValue || rearValue === frontValue) return frontValue;
  if (!frontValue) return rearValue;
  return `${frontValue} / ${rearValue}`;
}

function normalizeTireSpec(value: string | null) {
  const spec = String(value || "").trim().toUpperCase().replace(/\s+/g, "");
  const match = spec.match(/^(\d{3})\/(\d{2})\/?R?(\d{2})$/);
  return match ? `${match[1]}/${match[2]}R${match[3]}` : spec || "Not provided";
}

function normalizeWheelSpec(value: string | null) {
  return String(value || "")
    .trim()
    .replace(/\s+/g, " ")
    .replace(/\s*\+\s*(-?\d+)\s*$/, " +$1") || "Not provided";
}

function mapSubmission(row: SubmissionRow): GalleryBuild {
  const make = String(row.make || "").trim();
  const model = String(row.model || "").trim();
  const trim = String(row.trim || "").trim();
  const handle = String(row.instagram_handle || "").replace(/^@/, "").trim();

  return {
    id: String(row.id),
    year: String(row.year || "").trim() || undefined,
    label: `${model}${trim ? ` ${trim}` : ""}`,
    imageUrl: String(row.image_url || ""),
    sourceType: "community",
    sourceName: handle ? `@${handle}` : "Offset Lab Community",
    sourceUrl: handle ? `https://instagram.com/${handle}` : undefined,
    wheel: combineFitment(
      normalizeWheelSpec(row.front_wheel),
      normalizeWheelSpec(row.rear_wheel)
    ),
    tire: combineFitment(
      normalizeTireSpec(row.front_tire),
      normalizeTireSpec(row.rear_tire)
    ),
    note: String(row.notes || "").trim() || undefined,
    tags: [make, model, trim].filter(Boolean),
    match: "Verified Community Build",
    make,
    model,
    trim,
    frontWheel: normalizeWheelSpec(row.front_wheel),
    rearWheel: normalizeWheelSpec(row.rear_wheel),
    frontTire: normalizeTireSpec(row.front_tire),
    rearTire: normalizeTireSpec(row.rear_tire),
    suspension: String(row.suspension || "").trim() || undefined,
    style: normalizeStyle(String(row.fitment_style || "")),
  };
}

function getReferenceBuilds(vehicleModels: VehicleModel[]): GalleryBuild[] {
  return Object.entries(galleryExamples).flatMap(([model, styles]) => {
    const normalizedModel = model.toLowerCase();
    const vehicle = vehicleModels.find(
      (item) =>
        item.model === model ||
        String(item.display_name || "")
          .toLowerCase()
          .includes(normalizedModel)
    );
    if (!vehicle) return [];

    return (Object.entries(styles) as [
      StyleKey,
      (typeof styles)[StyleKey]
    ][]).flatMap(([style, builds]) =>
      builds.flatMap((build, index) => {
        if (build.imageStatus !== "verified" || !build.imageUrl) return [];

        return [
          {
            id: `reference-${model}-${style}-${index}`,
            label: build.label,
            imageUrl: build.imageUrl,
            sourceType: "reference" as const,
            sourceName: build.sourceName,
            sourceUrl:
              build.sourceUrl && build.sourceUrl !== "#"
                ? build.sourceUrl
                : undefined,
            wheel: build.wheel,
            tire: build.tire,
            note: build.note,
            tags: build.tags,
            match: build.match,
            make: vehicle.make,
            model: vehicle.model,
            trim: "",
            frontWheel: build.wheel.split(" / ")[0] || build.wheel,
            rearWheel: build.wheel.split(" / ")[1] || build.wheel,
            frontTire: build.tire.split(" / ")[0] || build.tire,
            rearTire: build.tire.split(" / ")[1] || build.tire,
            suspension: build.suspension,
            style,
          },
        ];
      })
    );
  });
}

function BuildCard({
  build,
  onOpen,
}: {
  build: GalleryBuild;
  onOpen: (build: GalleryBuild) => void;
}) {
  const isReference = build.sourceType === "reference";

  return (
    <article className="group overflow-hidden rounded-[1.6rem] border border-white/10 bg-[#090a0d] text-white shadow-2xl shadow-black/30 transition hover:-translate-y-1 hover:border-white/20">
      <div className="aspect-[4/3] overflow-hidden bg-white/[0.03]">
        <img
          src={build.imageUrl}
          alt={build.label}
          className="h-full w-full object-cover transition duration-700 group-hover:scale-[1.035]"
          loading="lazy"
        />
      </div>

      <div className="p-5">
        <div className="mb-4 flex flex-wrap gap-2">
          <span
            className={`rounded-full border px-3 py-1 text-[10px] font-bold uppercase tracking-[0.2em] ${
              isReference
                ? "border-sky-400/40 bg-sky-400/10 text-sky-300"
                : "border-red-500/40 bg-red-500/10 text-red-300"
            }`}
          >
            {isReference ? "Visual Reference" : "Community Build"}
          </span>
          <span className="rounded-full border border-white/10 bg-white/[0.04] px-3 py-1 text-[10px] font-bold uppercase tracking-[0.2em] text-white/55">
            {styleLabels[build.style]}
          </span>
        </div>

        <h2 className="text-xl font-black tracking-tight">{build.label}</h2>

        <dl className="mt-5 grid grid-cols-2 gap-4 border-y border-white/10 py-4">
          <div>
            <dt className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/35">
              Wheels
            </dt>
            <dd className="mt-1.5 text-sm leading-5 text-white/80">{build.wheel}</dd>
          </div>
          <div>
            <dt className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/35">
              Tires
            </dt>
            <dd className="mt-1.5 text-sm leading-5 text-white/80">{build.tire}</dd>
          </div>
        </dl>

        {build.note ? (
          <p className="mt-4 line-clamp-2 text-sm leading-6 text-white/50">
            {build.note}
          </p>
        ) : null}

        {isReference ? (
          <p className="mt-4 rounded-xl border border-sky-400/15 bg-sky-400/[0.06] px-3 py-2 text-xs leading-5 text-sky-100/60">
            Curated for visual guidance. Exact photographed specifications may
            vary from the setup shown.
          </p>
        ) : null}

        <div className="mt-5 flex items-center justify-between gap-4 text-xs text-white/40">
          {build.sourceUrl ? (
            <a
              href={build.sourceUrl}
              target="_blank"
              rel="noreferrer"
              className="truncate transition hover:text-white"
            >
              {build.sourceName}
            </a>
          ) : (
            <span className="truncate">{build.sourceName}</span>
          )}
          <span className="shrink-0">
            {isReference ? "Source Attribution" : "Approved Submission"}
          </span>
        </div>

        <button
          type="button"
          onClick={() => onOpen(build)}
          className="mt-5 flex w-full items-center justify-between rounded-xl border border-white/10 bg-white/[0.035] px-4 py-3 text-left text-[10px] font-black uppercase tracking-[0.16em] text-white/65 transition hover:border-red-500/40 hover:bg-red-500/[0.07] hover:text-red-300"
        >
          View Build Details
          <span className="text-red-400">-&gt;</span>
        </button>
      </div>
    </article>
  );
}

function BuildDetail({
  build,
  onClose,
}: {
  build: GalleryBuild;
  onClose: () => void;
}) {
  const params = new URLSearchParams({
    make: build.make,
    model: build.model,
    trim: build.trim || "",
    style: build.style,
    front: build.frontWheel,
    rear: build.rearWheel,
    frontTire: build.frontTire,
    rearTire: build.rearTire,
  });
  const tunerHref = `/tuner?${params.toString()}`;
  const compareHref = `/compare?${params.toString()}&title=${encodeURIComponent(
    `${build.label} Gallery Setup`
  )}&verdict=${encodeURIComponent(
    `Community-submitted ${styleLabels[build.style]} setup. Verify physical clearances before installation.`
  )}`;

  return (
    <div
      className="fixed inset-0 z-[70] overflow-y-auto bg-black/85 p-3 backdrop-blur-md sm:p-6"
      role="dialog"
      aria-modal="true"
      aria-label={`${build.label} build details`}
      onMouseDown={(event) => {
        if (event.target === event.currentTarget) onClose();
      }}
    >
      <div className="mx-auto my-3 max-w-6xl overflow-hidden rounded-[1.8rem] border border-white/15 bg-[#08090c] shadow-2xl shadow-black sm:my-8">
        <div className="flex items-center justify-between border-b border-white/10 px-5 py-4 sm:px-7">
          <div className="flex items-center gap-3">
          <span className="rounded-full border border-red-500/35 bg-red-500/10 px-3 py-1 text-[9px] font-black uppercase tracking-[0.18em] text-red-300">
              Approved Community Submission
            </span>
            <span className="text-[10px] font-black uppercase tracking-[0.16em] text-white/35">
              Published after review
            </span>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="grid h-10 w-10 place-items-center rounded-full border border-white/10 text-lg text-white/55 transition hover:border-white/30 hover:text-white"
            aria-label="Close build details"
          >
            ×
          </button>
        </div>

        <div className="grid lg:grid-cols-[1.15fr_.85fr]">
          <div className="relative min-h-[360px] overflow-hidden bg-black lg:min-h-[680px]">
            <img
              src={build.imageUrl}
              alt={build.label}
              className="absolute inset-0 h-full w-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/15" />
            <div className="absolute inset-x-0 bottom-0 p-6 sm:p-8">
              <p className="text-xs font-black uppercase tracking-[0.25em] text-red-400">
                {styleLabels[build.style]} Fitment
              </p>
              <h2 className="mt-2 text-3xl font-black tracking-[-0.04em] sm:text-5xl">
                {build.year ? `${build.year} ` : ""}
                {build.label}
              </h2>
              <p className="mt-3 text-sm text-white/55">
                {build.make} · {build.sourceName}
              </p>
            </div>
          </div>

          <div className="p-5 sm:p-8">
            <p className="text-[10px] font-black uppercase tracking-[0.22em] text-white/35">
              Exact Setup
            </p>

            <div className="mt-5 space-y-3">
              <AxleSpec
                axle="Front"
                wheel={build.frontWheel}
                tire={build.frontTire}
              />
              <AxleSpec
                axle="Rear"
                wheel={build.rearWheel}
                tire={build.rearTire}
              />
            </div>

            <div className="mt-6 grid gap-px overflow-hidden rounded-xl border border-white/10 bg-white/10 sm:grid-cols-2">
              <DetailMetric label="Suspension" value={build.suspension || "Not provided"} />
              <DetailMetric label="Fitment Style" value={styleLabels[build.style]} />
            </div>

            <div className="mt-6 rounded-xl border border-white/10 bg-white/[0.025] p-5">
              <p className="text-[10px] font-black uppercase tracking-[0.18em] text-white/30">
                Owner Notes
              </p>
              <p className="mt-3 text-sm leading-6 text-white/62">
                {build.note || "No additional installation or clearance notes were provided."}
              </p>
            </div>

            <div className="mt-6 rounded-xl border border-amber-400/15 bg-amber-400/[0.045] px-4 py-3 text-xs leading-5 text-amber-100/55">
              Approved for publication by Offset Lab. Submitted specifications are displayed in a normalized format but are not independently measured. Confirm suspension, alignment, and physical clearances before purchasing.
            </div>

            <div className="mt-6 grid gap-3 sm:grid-cols-2">
              <a
                href={tunerHref}
                className="flex min-h-14 items-center justify-center rounded-xl bg-red-600 px-4 text-center text-[10px] font-black uppercase tracking-[0.15em] transition hover:bg-red-500"
              >
                Use This Setup in Tuner
              </a>
              <a
                href={compareHref}
                className="flex min-h-14 items-center justify-center rounded-xl border border-white/15 px-4 text-center text-[10px] font-black uppercase tracking-[0.15em] text-white/70 transition hover:border-white/30 hover:text-white"
              >
                Compare to Factory
              </a>
            </div>

            {build.sourceUrl ? (
              <a
                href={build.sourceUrl}
                target="_blank"
                rel="noreferrer"
                className="mt-5 inline-flex text-xs font-bold text-white/35 transition hover:text-white"
              >
                View original source -&gt;
              </a>
            ) : null}
          </div>
        </div>
      </div>
    </div>
  );
}

function AxleSpec({
  axle,
  wheel,
  tire,
}: {
  axle: string;
  wheel: string;
  tire: string;
}) {
  return (
    <div className="grid grid-cols-[70px_1fr] items-center gap-4 rounded-xl border border-white/10 bg-black/30 p-4">
      <p className="text-[10px] font-black uppercase tracking-[0.17em] text-red-400">
        {axle}
      </p>
      <div className="grid gap-3 sm:grid-cols-2">
        <div>
          <p className="text-[9px] font-black uppercase tracking-[0.15em] text-white/25">Wheel</p>
          <p className="mt-1 font-black text-white/85">{wheel}</p>
        </div>
        <div>
          <p className="text-[9px] font-black uppercase tracking-[0.15em] text-white/25">Tire</p>
          <p className="mt-1 font-black text-white/85">{tire}</p>
        </div>
      </div>
    </div>
  );
}

function DetailMetric({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-[#0b0c0f] p-4">
      <p className="text-[9px] font-black uppercase tracking-[0.16em] text-white/25">{label}</p>
      <p className="mt-1 text-sm font-bold text-white/70">{value}</p>
    </div>
  );
}

export default function GalleryPage() {
  const [make, setMake] = useState("");
  const [model, setModel] = useState("");
  const [vehicleModels, setVehicleModels] = useState<VehicleModel[]>([]);
  const [allBuilds, setAllBuilds] = useState<GalleryBuild[]>([]);
  const [selectedVehicle, setSelectedVehicle] = useState<{
    make: string;
    model: string;
  } | null>(null);
  const [showAll, setShowAll] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedBuild, setSelectedBuild] = useState<GalleryBuild | null>(null);

  useEffect(() => {
    document.body.style.overflow = selectedBuild ? "hidden" : "";
    return () => {
      document.body.style.overflow = "";
    };
  }, [selectedBuild]);

  useEffect(() => {
    let cancelled = false;

    async function loadGallery() {
      const [models, submissions] = await Promise.all([
        getVehicleModels(),
        supabase
          .from("build_submissions")
          .select(
            "id, year, make, model, trim, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, suspension, image_url, notes, instagram_handle"
          )
          .eq("status", "approved"),
      ]);

      if (cancelled) return;

      setVehicleModels(models);

      if (submissions.data) {
        const communityBuilds = (submissions.data as SubmissionRow[])
          .filter((row) => Boolean(row.image_url))
          .map(mapSubmission)
          .reverse();

        setAllBuilds([...communityBuilds, ...getReferenceBuilds(models)]);
      } else {
        setAllBuilds(getReferenceBuilds(models));
      }

      setIsLoading(false);
    }

    loadGallery();

    return () => {
      cancelled = true;
    };
  }, []);

  const activeMakes = useMemo(
    () =>
      Array.from(
        new Set(
          vehicleModels
            .filter((vehicle) => vehicle.active)
            .map((vehicle) => vehicle.make)
        )
      ).sort((a, b) => a.localeCompare(b)),
    [vehicleModels]
  );

  const availableModels = useMemo(
    () =>
      vehicleModels
        .filter((vehicle) => vehicle.active && vehicle.make === make)
        .sort((a, b) =>
          String(a.display_name ?? a.model).localeCompare(
            String(b.display_name ?? b.model)
          )
        ),
    [make, vehicleModels]
  );

  const filteredBuilds = useMemo(() => {
    if (showAll) return allBuilds;
    if (!selectedVehicle) return allBuilds.slice(0, 6);

    return allBuilds.filter(
      (build) =>
        build.make === selectedVehicle.make &&
        build.model === selectedVehicle.model
    );
  }, [allBuilds, selectedVehicle, showAll]);

  const selectedModelLabel =
    vehicleModels.find(
      (vehicle) =>
        vehicle.make === selectedVehicle?.make &&
        vehicle.model === selectedVehicle?.model
    )?.display_name ?? selectedVehicle?.model;

  function browseBuilds() {
    if (!make || !model) return;
    setSelectedVehicle({ make, model });
    setShowAll(false);
    window.requestAnimationFrame(() => {
      document
        .getElementById("gallery-results")
        ?.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  }

  function viewAllBuilds() {
    setSelectedVehicle(null);
    setShowAll(true);
    window.requestAnimationFrame(() => {
      document
        .getElementById("gallery-results")
        ?.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  }

  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <section className="relative isolate min-h-[690px] overflow-hidden border-b border-white/10">
        <img
          src="/gallery/models.png"
          alt=""
          className="absolute inset-0 -z-20 h-full w-full object-cover object-[65%_center]"
        />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(90deg,rgba(2,3,5,0.98)_0%,rgba(2,3,5,0.9)_35%,rgba(2,3,5,0.2)_72%,rgba(2,3,5,0.55)_100%)]" />
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(0deg,rgba(5,6,9,1)_0%,transparent_40%,rgba(5,6,9,0.2)_100%)]" />
        <div className="absolute -left-32 top-24 -z-10 h-80 w-80 rounded-full bg-red-500/10 blur-[120px]" />

        <div className="mx-auto flex min-h-[690px] max-w-7xl flex-col justify-center px-5 py-16 md:px-8">
          <div className="max-w-2xl">
            <p className="text-xs font-bold uppercase tracking-[0.38em] text-red-400/80">
              Offset Lab Gallery
            </p>
            <h1 className="mt-5 text-5xl font-black leading-[0.92] tracking-[-0.04em] sm:text-6xl md:text-7xl">
              Find Your
              <br />
              Fitment.
            </h1>
            <p className="mt-6 max-w-lg text-base leading-7 text-white/60 md:text-lg">
              Explore approved wheel and tire setups from real community builds.
            </p>
          </div>

          <div className="mt-10 max-w-4xl rounded-[1.6rem] border border-white/15 bg-black/70 p-4 shadow-2xl shadow-black/50 backdrop-blur-xl md:p-5">
            <div className="grid gap-3 md:grid-cols-[1fr_1fr_auto] md:items-end">
              <label className="block">
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.25em] text-white/40">
                  Make
                </span>
                <select
                  value={make}
                  onChange={(event) => {
                    setMake(event.target.value);
                    setModel("");
                  }}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60"
                >
                  <option value="">Select make</option>
                  {activeMakes.map((item) => (
                    <option key={item} value={item}>
                      {item}
                    </option>
                  ))}
                </select>
              </label>

              <label className="block">
                <span className="mb-2 block text-[10px] font-bold uppercase tracking-[0.25em] text-white/40">
                  Model
                </span>
                <select
                  value={model}
                  onChange={(event) => setModel(event.target.value)}
                  disabled={!make}
                  className="h-14 w-full appearance-none rounded-xl border border-white/10 bg-[#111216] px-4 text-sm font-semibold outline-none transition focus:border-red-500/60 disabled:cursor-not-allowed disabled:opacity-45"
                >
                  <option value="">Select model</option>
                  {availableModels.map((item) => (
                    <option key={item.model} value={item.model}>
                      {item.display_name ?? item.model}
                    </option>
                  ))}
                </select>
              </label>

              <button
                type="button"
                onClick={browseBuilds}
                disabled={!make || !model}
                className="h-14 rounded-xl bg-red-500 px-7 text-xs font-black uppercase tracking-[0.18em] text-white transition hover:bg-red-400 disabled:cursor-not-allowed disabled:bg-white/10 disabled:text-white/30"
              >
                Browse Builds
              </button>
            </div>

            <button
              type="button"
              onClick={viewAllBuilds}
              className="mt-4 text-xs font-semibold text-white/45 underline decoration-white/20 underline-offset-4 transition hover:text-white"
            >
              View all builds
            </button>
          </div>
        </div>
      </section>

      <section
        id="gallery-results"
        className="scroll-mt-20 px-5 py-16 md:px-8 md:py-20"
      >
        <div className="mx-auto max-w-7xl">
          <div className="flex flex-col gap-5 border-b border-white/10 pb-8 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.32em] text-red-400/70">
                {selectedVehicle ? "Selected Vehicle" : showAll ? "The Gallery" : "Latest Additions"}
              </p>
              <h2 className="mt-3 text-3xl font-black tracking-tight md:text-5xl">
                {selectedVehicle
                  ? `${selectedVehicle.make} ${selectedModelLabel}`
                  : showAll
                  ? "All Verified Builds"
                  : "Featured Builds"}
              </h2>
              <p className="mt-3 text-sm text-white/45">
                {selectedVehicle
                  ? `${filteredBuilds.length} gallery ${
                      filteredBuilds.length === 1 ? "result" : "results"
                    } found`
                  : "Real cars and submitted specifications, approved for the Gallery by Offset Lab."}
              </p>
            </div>

            {(selectedVehicle || showAll) && (
              <button
                type="button"
                onClick={() => {
                  setSelectedVehicle(null);
                  setShowAll(false);
                }}
                className="w-fit rounded-xl border border-white/15 px-4 py-2.5 text-xs font-bold uppercase tracking-[0.16em] text-white/65 transition hover:border-white/30 hover:text-white"
              >
                Back to Featured
              </button>
            )}
          </div>

          {isLoading ? (
            <div className="mt-8 grid gap-6 md:grid-cols-2 xl:grid-cols-3">
              {[0, 1, 2].map((item) => (
                <div
                  key={item}
                  className="aspect-[3/4] animate-pulse rounded-[1.6rem] border border-white/10 bg-white/[0.04]"
                />
              ))}
            </div>
          ) : filteredBuilds.length > 0 ? (
            <div className="mt-8 grid gap-6 md:grid-cols-2 xl:grid-cols-3">
              {filteredBuilds.map((build) => (
                <BuildCard key={build.id} build={build} onOpen={setSelectedBuild} />
              ))}
            </div>
          ) : (
            <div className="mt-8 rounded-[1.6rem] border border-white/10 bg-white/[0.025] px-6 py-14 text-center">
              <p className="text-2xl font-black">No gallery references yet.</p>
              <p className="mx-auto mt-3 max-w-md text-sm leading-6 text-white/50">
                {selectedVehicle
                  ? "This vehicle is waiting for its first approved community setup. View all builds or check back as the gallery grows."
                  : "The gallery is waiting for its first approved community setup. Check back as new builds are verified."}
              </p>
              {selectedVehicle ? (
                <button
                  type="button"
                  onClick={viewAllBuilds}
                  className="mt-6 rounded-xl bg-white px-5 py-3 text-xs font-black uppercase tracking-[0.16em] text-black transition hover:bg-white/85"
                >
                  View All Builds
                </button>
              ) : null}
            </div>
          )}
        </div>
      </section>
      {selectedBuild ? (
        <BuildDetail build={selectedBuild} onClose={() => setSelectedBuild(null)} />
      ) : null}
    </main>
  );
}
