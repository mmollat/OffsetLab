import type { Metadata } from "next";
import Link from "next/link";
import { getFitmentSeoPages } from "../../lib/getFitmentSeoPages";

export const revalidate = 86400;

export const metadata: Metadata = {
  title: "Fitment Guides",
  description:
    "Browse Offset Lab wheel and tire fitment guides by make and model, including baseline specs and popular setup styles.",
  alternates: {
    canonical: "/fitment/guides",
  },
  openGraph: {
    title: "Offset Lab Fitment Guides",
    description:
      "Browse vehicle-specific wheel and tire fitment guides, setup styles, and baseline specs from Offset Lab.",
    url: "/fitment/guides",
    siteName: "Offset Lab",
    type: "website",
  },
};

function getPrimarySetup(page: Awaited<ReturnType<typeof getFitmentSeoPages>>[number]) {
  return (
    page.trims[0]?.presets.find((preset) => preset.style === "flush") ??
    page.trims[0]?.presets[0] ??
    null
  );
}

export default async function FitmentGuidesPage() {
  const pages = await getFitmentSeoPages();

  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <section className="relative isolate overflow-hidden border-b border-white/10 px-5 py-16 md:px-8 md:py-20">
        <div
          className="absolute inset-0 -z-30 bg-cover bg-[70%_center] md:bg-center"
          style={{ backgroundImage: "url('/fitment-hero.png')" }}
        />
        <div className="absolute inset-0 -z-20 bg-gradient-to-r from-black via-black/90 to-black/30" />
        <div className="absolute inset-0 -z-10 bg-gradient-to-t from-[#050609] via-transparent to-black/25" />

        <div className="mx-auto max-w-6xl">
          <Link
            href="/fitment"
            className="text-xs font-bold uppercase tracking-[0.22em] text-red-400 transition hover:text-red-300"
          >
            Fitment
          </Link>
          <h1 className="mt-5 max-w-3xl text-4xl font-black leading-[0.96] tracking-[-0.04em] sm:text-6xl">
            Wheel and Tire Fitment Guides
          </h1>
          <p className="mt-6 max-w-3xl text-base leading-7 text-white/65 md:text-lg">
            Vehicle-specific starting points for wheel widths, offsets, tire sizes,
            factory baselines, and common setup styles.
          </p>
        </div>
      </section>

      <section className="px-5 py-14 md:px-8 md:py-18">
        <div className="mx-auto max-w-6xl">
          <div className="mb-8 flex flex-col justify-between gap-4 border-b border-white/10 pb-6 md:flex-row md:items-end">
            <div>
              <p className="text-xs font-bold uppercase tracking-[0.24em] text-red-400/75">
                Browse
              </p>
              <h2 className="mt-3 text-3xl font-black tracking-tight">
                Available fitment pages
              </h2>
            </div>
            <Link
              href="/fitment"
              className="w-fit rounded-md bg-red-600 px-5 py-3 text-xs font-black uppercase tracking-[0.12em] transition hover:bg-red-500"
            >
              Open fitment tool
            </Link>
          </div>

          {pages.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
              {pages.map((page) => {
                const primarySetup = getPrimarySetup(page);
                const primaryTrim = page.trims[0];

                return (
                  <Link
                    key={page.key}
                    href={{ pathname: page.urlPath }}
                    className="group rounded-[1.25rem] border border-white/10 bg-[#0a0b0e] p-6 transition hover:border-red-400/50 hover:bg-red-500/[0.06]"
                  >
                    <p className="text-[10px] font-black uppercase tracking-[0.2em] text-red-300">
                      {page.makeName}
                    </p>
                    <h3 className="mt-4 text-2xl font-black leading-tight tracking-[-0.03em]">
                      {page.modelName}
                    </h3>
                    <p className="mt-3 text-sm leading-6 text-white/45">
                      {page.trims.length} trim{page.trims.length === 1 ? "" : "s"} with baseline
                      specs and preset fitment styles.
                    </p>

                    {primarySetup && primaryTrim ? (
                      <div className="mt-6 border-t border-white/10 pt-5">
                        <p className="text-[10px] font-black uppercase tracking-[0.18em] text-white/35">
                          Popular setup
                        </p>
                        <p className="mt-3 text-sm font-bold text-white/80">
                          {primarySetup.front}
                          {primarySetup.rear !== primarySetup.front ? ` / ${primarySetup.rear}` : ""}
                        </p>
                        <p className="mt-2 text-xs leading-5 text-white/42">
                          {primaryTrim.trim}: {primaryTrim.baselineFront}
                          {primaryTrim.baselineRear !== primaryTrim.baselineFront ? ` / ${primaryTrim.baselineRear}` : ""}
                        </p>
                      </div>
                    ) : null}

                    <span className="mt-6 inline-block text-xs font-bold text-red-400 transition group-hover:text-red-300">
                      View fitment guide -&gt;
                    </span>
                  </Link>
                );
              })}
            </div>
          ) : (
            <div className="rounded-[1.25rem] border border-white/10 bg-[#0a0b0e] p-8">
              <p className="text-lg font-black tracking-tight">No published fitment guides yet.</p>
              <p className="mt-3 max-w-2xl text-sm leading-6 text-white/50">
                The interactive fitment tool is still available while guide pages are generated
                from the production vehicle data set.
              </p>
              <Link
                href="/fitment"
                className="mt-6 inline-flex rounded-md bg-red-600 px-5 py-3 text-xs font-black uppercase tracking-[0.12em] transition hover:bg-red-500"
              >
                Open fitment tool
              </Link>
            </div>
          )}
        </div>
      </section>
    </main>
  );
}
