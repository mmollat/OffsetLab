"use client";

import { useEffect, useMemo, useState } from "react";
import { StyleKey } from "../data/fitment";
import { getVehicleModels, VehicleModel } from "../lib/getVehicleModels";
import { supabase } from "../lib/supabase";

const styleLabels: Record<StyleKey, string> = {
  oemplus: "OEM+",
  flush: "Flush",
  aggressive: "Aggressive",
};

type GalleryBuild = {
  id: string;
  label: string;
  imageUrl: string;
  sourceName: string;
  sourceUrl?: string;
  wheel: string;
  tire: string;
  note?: string;
  tags: string[];
  match: string;
  make: string;
  model: string;
  style: StyleKey;
};

type SubmissionRow = {
  id: string | number;
  make: string | null;
  model: string | null;
  trim: string | null;
  fitment_style: string | null;
  front_wheel: string | null;
  rear_wheel: string | null;
  front_tire: string | null;
  rear_tire: string | null;
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

function mapSubmission(row: SubmissionRow): GalleryBuild {
  const make = String(row.make || "").trim();
  const model = String(row.model || "").trim();
  const trim = String(row.trim || "").trim();
  const handle = String(row.instagram_handle || "").replace(/^@/, "").trim();

  return {
    id: String(row.id),
    label: `${model}${trim ? ` ${trim}` : ""}`,
    imageUrl: String(row.image_url || ""),
    sourceName: handle ? `@${handle}` : "Offset Lab Community",
    sourceUrl: handle ? `https://instagram.com/${handle}` : undefined,
    wheel: combineFitment(row.front_wheel, row.rear_wheel),
    tire: combineFitment(row.front_tire, row.rear_tire),
    note: String(row.notes || "").trim() || undefined,
    tags: [make, model, trim].filter(Boolean),
    match: "Verified Community Build",
    make,
    model,
    style: normalizeStyle(String(row.fitment_style || "")),
  };
}

function BuildCard({ build }: { build: GalleryBuild }) {
  return (
    <article className="group overflow-hidden rounded-[1.6rem] border border-white/10 bg-[#090a0d] text-white shadow-2xl shadow-black/30">
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
          <span className="rounded-full border border-red-500/40 bg-red-500/10 px-3 py-1 text-[10px] font-bold uppercase tracking-[0.2em] text-red-300">
            Community Build
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
          <span className="shrink-0">Verified Build</span>
        </div>
      </div>
    </article>
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

  useEffect(() => {
    let cancelled = false;

    async function loadGallery() {
      const [models, submissions] = await Promise.all([
        getVehicleModels(),
        supabase
          .from("build_submissions")
          .select(
            "id, make, model, trim, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, image_url, notes, instagram_handle"
          )
          .eq("status", "approved"),
      ]);

      if (cancelled) return;

      setVehicleModels(models);

      if (submissions.data) {
        setAllBuilds(
          (submissions.data as SubmissionRow[])
            .filter((row) => Boolean(row.image_url))
            .map(mapSubmission)
            .reverse()
        );
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
              Explore verified wheel and tire setups from real community builds.
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
                  ? `${filteredBuilds.length} verified ${
                      filteredBuilds.length === 1 ? "build" : "builds"
                    } found`
                  : "Real cars, real specifications, approved by Offset Lab."}
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
                <BuildCard key={build.id} build={build} />
              ))}
            </div>
          ) : (
            <div className="mt-8 rounded-[1.6rem] border border-white/10 bg-white/[0.025] px-6 py-14 text-center">
              <p className="text-2xl font-black">No verified builds yet.</p>
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
    </main>
  );
}
