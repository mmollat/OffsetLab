import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import {
  getVerifiedTorqueSeoPage,
  getVerifiedTorqueSeoPages,
  VerifiedTorqueSeoSpec,
} from "../../../lib/getVerifiedTorqueSeoPages";

const siteUrl = "https://offset-lab.com";

export const revalidate = 86400;

type PageParams = {
  params: {
    make: string;
    model: string;
  };
};

function formatTorque(spec: VerifiedTorqueSeoSpec) {
  if (spec.torqueFtLb === null && spec.torqueNm === null) return "Torque pending";

  const ftLb = spec.torqueFtLb !== null ? `${spec.torqueFtLb} ft-lb` : null;
  const nm = spec.torqueNm !== null ? `${spec.torqueNm} Nm` : null;
  const angle =
    spec.angleDegrees !== null ? ` + ${spec.angleDegrees} degrees` : "";

  return [ftLb, nm].filter(Boolean).join(" / ") + angle;
}

function formatCheckedDate(value: string | null) {
  if (!value) return null;

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;

  return new Intl.DateTimeFormat("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  }).format(date);
}

function isSafeSourceUrl(value: string | null) {
  if (!value) return false;

  try {
    const url = new URL(value);
    return url.protocol === "https:" || url.protocol === "http:";
  } catch {
    return false;
  }
}

export async function generateStaticParams() {
  const pages = await getVerifiedTorqueSeoPages();

  return pages.map((page) => ({
    make: page.makeSlug,
    model: page.generationSlug,
  }));
}

export async function generateMetadata({ params }: PageParams): Promise<Metadata> {
  const page = await getVerifiedTorqueSeoPage(params.make, params.model);

  if (!page) {
    return {
      title: "Torque Specs",
    };
  }

  const primarySpec = page.specs.find((spec) => spec.categorySlug === "wheels") ?? page.specs[0];
  const title = `${page.makeName} ${page.generationName} Torque Specs`;
  const description = primarySpec
    ? `${page.makeName} ${page.generationName} ${primarySpec.fastener} torque: ${formatTorque(
        primarySpec
      )}. Verified source details and safety notes from Offset Lab.`
    : `Verified torque specs for ${page.makeName} ${page.generationName}.`;

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

export default async function TorqueSeoPage({ params }: PageParams) {
  const page = await getVerifiedTorqueSeoPage(params.make, params.model);

  if (!page) notFound();

  const primarySpec = page.specs.find((spec) => spec.categorySlug === "wheels") ?? page.specs[0];
  const title = `${page.makeName} ${page.generationName} Torque Specs`;
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: title,
    description: primarySpec
      ? `${primarySpec.fastener} torque is ${formatTorque(primarySpec)}.`
      : `Verified torque specs for ${page.makeName} ${page.generationName}.`,
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

      <section className="border-b border-white/10 px-5 py-16 md:px-8 md:py-20">
        <div className="mx-auto max-w-5xl">
          <Link
            href="/torque"
            className="text-xs font-bold uppercase tracking-[0.22em] text-red-400 transition hover:text-red-300"
          >
            Torque Hub
          </Link>
          <h1 className="mt-5 text-4xl font-black leading-[0.96] tracking-[-0.04em] sm:text-6xl">
            {title}
          </h1>
          <p className="mt-6 max-w-3xl text-base leading-7 text-white/60 md:text-lg">
            Verified torque references for {page.makeName} {page.generationName},
            including source links, safety notes, and ft-lb / Nm conversions.
          </p>

          {primarySpec ? (
            <div className="mt-10 rounded-[1.5rem] border border-red-500/25 bg-red-500/[0.08] p-6">
              <p className="text-xs font-black uppercase tracking-[0.22em] text-red-300">
                Primary spec
              </p>
              <h2 className="mt-3 text-2xl font-black tracking-tight">
                {primarySpec.fastener}
              </h2>
              <p className="mt-4 text-5xl font-black tracking-[-0.04em]">
                {primarySpec.torqueFtLb ?? "-"}
                <span className="ml-2 text-base font-bold tracking-normal text-white/45">
                  ft-lb
                </span>
              </p>
              {primarySpec.torqueNm !== null ? (
                <p className="mt-2 text-sm font-semibold text-white/50">
                  {primarySpec.torqueNm} Nm
                </p>
              ) : null}
            </div>
          ) : null}
        </div>
      </section>

      <section className="px-5 py-14 md:px-8 md:py-18">
        <div className="mx-auto max-w-5xl">
          <div className="mb-6 rounded-[1.25rem] border border-amber-400/20 bg-amber-400/[0.06] p-5">
            <p className="text-xs font-black uppercase tracking-[0.18em] text-amber-200">
              Safety note
            </p>
            <p className="mt-2 text-sm leading-6 text-amber-50/65">
              Confirm safety-critical fastener values against the exact model-year
              service manual. Use a calibrated torque wrench, the correct tightening
              sequence, and vehicle-specific hardware.
            </p>
          </div>

          <div className="grid gap-4">
            {page.specs.map((spec) => {
              const checkedDate = formatCheckedDate(spec.sourceCheckedAt);
              const sourceUrlAvailable = isSafeSourceUrl(spec.sourceUrl);

              return (
                <article
                  key={spec.id}
                  className="rounded-[1.5rem] border border-white/10 bg-[#0a0b0e] p-6 shadow-2xl shadow-black/20"
                >
                  <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                    <div>
                      <p className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/35">
                        {spec.categoryName} / {spec.component}
                      </p>
                      <h2 className="mt-2 text-2xl font-black tracking-tight">
                        {spec.fastener}
                      </h2>
                    </div>
                    <span className="w-fit rounded-full border border-emerald-500/30 bg-emerald-500/10 px-3 py-1 text-[10px] font-bold uppercase tracking-[0.12em] text-emerald-300">
                      Verified
                    </span>
                  </div>

                  <div className="mt-6 border-y border-white/10 py-5">
                    <p className="text-4xl font-black tracking-[-0.04em]">
                      {spec.torqueFtLb ?? "-"}
                      <span className="ml-2 text-base font-bold tracking-normal text-white/40">
                        ft-lb
                      </span>
                    </p>
                    {spec.torqueNm !== null ? (
                      <p className="mt-2 text-sm font-semibold text-white/40">
                        {spec.torqueNm} Nm
                      </p>
                    ) : null}
                    {spec.angleDegrees !== null ? (
                      <p className="mt-2 text-sm font-bold text-red-400">
                        + {spec.angleDegrees} degree angle torque
                      </p>
                    ) : null}
                  </div>

                  {spec.notes ? (
                    <p className="mt-5 text-sm leading-6 text-white/50">{spec.notes}</p>
                  ) : null}

                  {spec.warning ? (
                    <div className="mt-5 rounded-xl border border-red-500/20 bg-red-500/10 p-4 text-sm leading-6 text-red-200">
                      {spec.warning}
                    </div>
                  ) : null}

                  <div className="mt-6 border-t border-white/10 pt-5">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <p className="text-[10px] font-bold uppercase tracking-[0.2em] text-white/30">
                        Source
                      </p>
                      {checkedDate ? (
                        <p className="text-[10px] font-semibold text-white/30">
                          Checked {checkedDate}
                        </p>
                      ) : null}
                    </div>
                    <p className="mt-2 text-sm font-semibold text-white/72">
                      {spec.sourceName}
                    </p>
                    {spec.sourceNote ? (
                      <p className="mt-2 text-xs leading-5 text-white/38">
                        {spec.sourceNote}
                      </p>
                    ) : null}
                    {sourceUrlAvailable ? (
                      <a
                        href={spec.sourceUrl!}
                        target="_blank"
                        rel="noreferrer"
                        className="mt-4 inline-flex items-center gap-2 text-xs font-bold text-red-400 transition hover:text-red-300"
                      >
                        Open source <span aria-hidden="true">-&gt;</span>
                      </a>
                    ) : null}
                  </div>
                </article>
              );
            })}
          </div>

          <div className="mt-10 flex flex-col gap-3 sm:flex-row">
            <Link
              href="/torque"
              className="inline-flex min-h-12 items-center justify-center rounded-md bg-red-600 px-6 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:bg-red-500"
            >
              Open Torque Hub
            </Link>
            <Link
              href="/fitment"
              className="inline-flex min-h-12 items-center justify-center rounded-md border border-white/20 px-6 text-sm font-black uppercase tracking-[0.12em] text-white/80 transition hover:border-white/40 hover:text-white"
            >
              Find Fitment
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}
