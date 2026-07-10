import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { modelSlug } from "../../../data/fitment";
import {
  getFitmentSeoPage,
  getFitmentSeoPages,
} from "../../../lib/getFitmentSeoPages";

const siteUrl = "https://offset-lab.com";

export const revalidate = 86400;

type PageParams = {
  params: {
    make: string;
    model: string;
  };
};

function getPrimaryPreset(page: Awaited<ReturnType<typeof getFitmentSeoPage>>) {
  return page?.trims[0]?.presets.find((preset) => preset.style === "flush") ?? page?.trims[0]?.presets[0] ?? null;
}

export async function generateStaticParams() {
  const pages = await getFitmentSeoPages();

  return pages.map((page) => ({
    make: page.makeSlug,
    model: page.modelSlug,
  }));
}

export async function generateMetadata({ params }: PageParams): Promise<Metadata> {
  const page = await getFitmentSeoPage(params.make, params.model);

  if (!page) {
    return {
      title: "Fitment Guide",
    };
  }

  const primaryPreset = getPrimaryPreset(page);
  const title = `${page.makeName} ${page.modelName} Fitment Guide`;
  const description = primaryPreset
    ? `${page.makeName} ${page.modelName} wheel and tire fitment recommendations, including ${primaryPreset.label.toLowerCase()} setup guidance and tire sizing from Offset Lab.`
    : `Wheel and tire fitment recommendations for ${page.makeName} ${page.modelName}.`;

  return {
    title,
    description,
    alternates: {
      canonical: page.urlPath,
    },
    openGraph: {
      title,
      description,
      url: page.urlPath,
      siteName: "Offset Lab",
      type: "article",
    },
  };
}

export default async function FitmentSeoPage({ params }: PageParams) {
  const page = await getFitmentSeoPage(params.make, params.model);

  if (!page) notFound();

  const primaryPreset = getPrimaryPreset(page);
  const primaryTrim = page.trims[0];
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: `${page.makeName} ${page.modelName} Fitment Guide`,
    description: primaryPreset
      ? `${primaryPreset.label} fitment recommendation: ${primaryPreset.front} front and ${primaryPreset.rear} rear.`
      : `Fitment recommendations for ${page.makeName} ${page.modelName}.`,
    mainEntityOfPage: `${siteUrl}${page.urlPath}`,
    publisher: {
      "@type": "Organization",
      name: "Offset Lab",
      url: siteUrl,
    },
  };

  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <section className="relative isolate overflow-hidden border-b border-white/10 px-5 py-16 md:px-8 md:py-20">
        <div
          className="absolute inset-0 -z-30 bg-cover bg-[72%_center] md:bg-center"
          style={{ backgroundImage: "url('/fitment-hero.png')" }}
        />
        <div className="absolute inset-0 -z-20 bg-gradient-to-r from-black via-black/90 to-black/25" />
        <div className="absolute inset-0 -z-10 bg-gradient-to-t from-[#050609] via-transparent to-black/30" />

        <div className="mx-auto max-w-5xl">
          <Link
            href="/fitment"
            className="text-xs font-bold uppercase tracking-[0.22em] text-red-400 transition hover:text-red-300"
          >
            Fitment
          </Link>
          <h1 className="mt-5 text-4xl font-black leading-[0.96] tracking-[-0.04em] sm:text-6xl">
            {page.makeName} {page.modelName} Fitment Guide
          </h1>
          <p className="mt-6 max-w-3xl text-base leading-7 text-white/65 md:text-lg">
            Wheel, tire, and stance recommendations for {page.makeName} {page.modelName},
            built from Offset Lab fitment presets and factory baseline data.
          </p>

          {primaryPreset && primaryTrim ? (
            <div className="mt-10 rounded-[1.5rem] border border-red-500/25 bg-red-500/[0.08] p-6">
              <p className="text-xs font-black uppercase tracking-[0.22em] text-red-300">
                Popular setup
              </p>
              <h2 className="mt-3 text-2xl font-black tracking-tight">
                {primaryPreset.label} fitment
              </h2>
              <div className="mt-5 grid gap-4 md:grid-cols-2">
                <SpecBlock label="Front" wheel={primaryPreset.front} tire={primaryPreset.frontTire} />
                <SpecBlock label="Rear" wheel={primaryPreset.rear} tire={primaryPreset.rearTire} />
              </div>
              <p className="mt-5 text-sm leading-6 text-white/55">
                Factory baseline for {primaryTrim.trim}: {primaryTrim.baselineFront}
                {primaryTrim.baselineRear !== primaryTrim.baselineFront ? ` / ${primaryTrim.baselineRear}` : ""} on {primaryTrim.baselineTire}.
              </p>
            </div>
          ) : null}
        </div>
      </section>

      <section className="px-5 py-14 md:px-8 md:py-18">
        <div className="mx-auto max-w-5xl">
          <div className="mb-7 flex flex-col justify-between gap-4 border-b border-white/10 pb-6 md:flex-row md:items-end">
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.24em] text-red-400/75">
                Recommendations
              </p>
              <h2 className="mt-3 text-3xl font-black tracking-tight">
                Trims and setup styles
              </h2>
            </div>
            <Link
              href={{
                pathname: "/fitment",
                query: {
                  make: page.makeName.toLowerCase(),
                  model: modelSlug(page.modelKey),
                },
              }}
              className="w-fit rounded-md bg-red-600 px-5 py-3 text-xs font-black uppercase tracking-[0.12em] transition hover:bg-red-500"
            >
              Open fitment tool
            </Link>
          </div>

          <div className="grid gap-5">
            {page.trims.map((trim) => (
              <article
                key={trim.trim}
                className="rounded-[1.4rem] border border-white/10 bg-[#0a0b0e] p-6 shadow-2xl shadow-black/20"
              >
                <div className="flex flex-col gap-3 md:flex-row md:items-start md:justify-between">
                  <div>
                    <p className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/35">
                      Trim
                    </p>
                    <h3 className="mt-2 text-2xl font-black tracking-tight">{trim.trim}</h3>
                  </div>
                  <div className="text-sm leading-6 text-white/45 md:text-right">
                    <p>Factory: {trim.baselineFront}{trim.baselineRear !== trim.baselineFront ? ` / ${trim.baselineRear}` : ""}</p>
                    <p>{trim.baselineTire}</p>
                    <p>{trim.boltPattern || "Bolt pattern pending"} · {trim.centerBore || "Center bore pending"}</p>
                  </div>
                </div>

                <div className="mt-6 grid gap-4 md:grid-cols-3">
                  {trim.presets.map((preset) => (
                    <div
                      key={`${trim.trim}-${preset.style}`}
                      className="border-t border-white/10 pt-5"
                    >
                      <p className="text-[10px] font-black uppercase tracking-[0.18em] text-red-300">
                        {preset.label}
                      </p>
                      <p className="mt-4 text-sm font-bold text-white/80">Front: {preset.front}</p>
                      <p className="mt-1 text-sm font-bold text-white/80">Rear: {preset.rear}</p>
                      <p className="mt-3 text-xs leading-5 text-white/45">
                        Tires: {preset.frontTire}
                        {preset.rearTire !== preset.frontTire ? ` / ${preset.rearTire}` : ""}
                      </p>
                      <p className="mt-3 text-xs leading-5 text-white/40">{preset.risk}</p>
                    </div>
                  ))}
                </div>
              </article>
            ))}
          </div>

          <div className="mt-8 rounded-[1.25rem] border border-amber-400/20 bg-amber-400/[0.06] p-5">
            <p className="text-xs font-black uppercase tracking-[0.18em] text-amber-200">
              Fitment note
            </p>
            <p className="mt-2 text-sm leading-6 text-amber-50/65">
              Final fitment depends on tire model, alignment, suspension height, brake clearance,
              body tolerance, and intended use. Test fit before committing to permanent changes.
            </p>
          </div>
        </div>
      </section>
    </main>
  );
}

function SpecBlock({ label, wheel, tire }: { label: string; wheel: string; tire: string }) {
  return (
    <div className="border-l border-white/15 pl-4">
      <p className="text-[10px] font-black uppercase tracking-[0.18em] text-white/35">
        {label}
      </p>
      <p className="mt-2 text-2xl font-black tracking-[-0.03em]">{wheel}</p>
      <p className="mt-1 text-sm font-semibold text-white/45">{tire}</p>
    </div>
  );
}
