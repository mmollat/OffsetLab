import { supabase } from "./supabase";

export type VerifiedTorqueSeoSpec = {
  id: string;
  categoryName: string;
  categorySlug: string;
  component: string;
  fastener: string;
  torqueFtLb: number | null;
  torqueNm: number | null;
  angleDegrees: number | null;
  notes: string | null;
  warning: string | null;
  sourceName: string | null;
  sourceUrl: string | null;
  sourceNote: string | null;
  sourceCheckedAt: string | null;
};

export type VerifiedTorqueSeoPage = {
  key: string;
  makeSlug: string;
  makeName: string;
  modelSlug: string;
  modelName: string;
  generationSlug: string;
  generationName: string;
  urlPath: string;
  specs: VerifiedTorqueSeoSpec[];
};

type TorqueSpecSeoRow = {
  id: string;
  component: string;
  fastener: string;
  torque_ft_lb: number | null;
  torque_nm: number | null;
  angle_degrees: number | null;
  notes: string | null;
  warning: string | null;
  source_name: string | null;
  source_url: string | null;
  source_note: string | null;
  source_checked_at: string | null;
  torque_categories: {
    name: string;
    slug: string;
    sort_order: number | null;
  };
  torque_vehicle_generations: {
    name: string;
    slug: string;
    torque_vehicle_models: {
      name: string;
      slug: string;
      torque_vehicle_makes: {
        name: string;
        slug: string;
      };
    };
  };
};

function formatUrlPath(makeSlug: string, generationSlug: string) {
  return `/torque/${makeSlug}/${generationSlug}`;
}

export async function getVerifiedTorqueSeoPages(): Promise<VerifiedTorqueSeoPage[]> {
  const { data, error } = await supabase
    .from("torque_specs")
    .select(
      `
      id,
      component,
      fastener,
      torque_ft_lb,
      torque_nm,
      angle_degrees,
      notes,
      warning,
      source_name,
      source_url,
      source_note,
      source_checked_at,
      torque_categories!inner(name, slug, sort_order),
      torque_vehicle_generations!inner(
        name,
        slug,
        torque_vehicle_models!inner(
          name,
          slug,
          torque_vehicle_makes!inner(name, slug)
        )
      )
    `
    )
    .eq("source_status", "verified")
    .not("source_name", "is", null)
    .order("component", { ascending: true })
    .order("fastener", { ascending: true });

  if (error || !data) {
    console.error("Error loading verified torque SEO pages:", error);
    return [];
  }

  const pages = new Map<string, VerifiedTorqueSeoPage>();

  (data as unknown as TorqueSpecSeoRow[]).forEach((row) => {
    const generation = row.torque_vehicle_generations;
    const model = generation.torque_vehicle_models;
    const make = model.torque_vehicle_makes;
    const key = `${make.slug}/${generation.slug}`;
    const urlPath = formatUrlPath(make.slug, generation.slug);
    const page =
      pages.get(key) ??
      {
        key,
        makeSlug: make.slug,
        makeName: make.name,
        modelSlug: model.slug,
        modelName: model.name,
        generationSlug: generation.slug,
        generationName: generation.name,
        urlPath,
        specs: [],
      };

    page.specs.push({
      id: row.id,
      categoryName: row.torque_categories.name,
      categorySlug: row.torque_categories.slug,
      component: row.component,
      fastener: row.fastener,
      torqueFtLb: row.torque_ft_lb,
      torqueNm: row.torque_nm,
      angleDegrees: row.angle_degrees,
      notes: row.notes,
      warning: row.warning,
      sourceName: row.source_name,
      sourceUrl: row.source_url,
      sourceNote: row.source_note,
      sourceCheckedAt: row.source_checked_at,
    });

    pages.set(key, page);
  });

  return Array.from(pages.values()).sort((a, b) =>
    `${a.makeName} ${a.generationName}`.localeCompare(`${b.makeName} ${b.generationName}`)
  );
}

export async function getVerifiedTorqueSeoPage(
  makeSlug: string,
  generationSlug: string
) {
  const pages = await getVerifiedTorqueSeoPages();

  return (
    pages.find(
      (page) => page.makeSlug === makeSlug && page.generationSlug === generationSlug
    ) ?? null
  );
}
