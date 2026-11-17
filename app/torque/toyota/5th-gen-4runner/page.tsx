import type { Metadata } from "next";
import Link from "next/link";

const path = "/torque/toyota/5th-gen-4runner";
const title = "5th-Gen Toyota 4Runner Lug Nut Torque";
const description = "Verified U.S. 2019 and 2024 4Runner wheel nut torque: factory steel wheels 83 ft-lbf (112 N·m); factory aluminum wheels 76 ft-lbf (103 N·m). Other years and hardware require separate verification.";
const manuals = [
  { year: 2019, publication: "OM35B48U", page: 472 },
  { year: 2024, publication: "OM35C03U", page: 532 },
];

export const metadata: Metadata = {
  title,
  description,
  alternates: { canonical: path },
  openGraph: { title, description, url: path, siteName: "Offset Lab", type: "article" },
};

export default function FifthGen4RunnerTorquePage() {
  return (
    <main className="min-h-screen bg-[#050609] text-white">
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify({
        "@context": "https://schema.org",
        "@type": "TechArticle",
        headline: title,
        description,
        mainEntityOfPage: `https://offset-lab.com${path}`,
        publisher: { "@type": "Organization", name: "Offset Lab", url: "https://offset-lab.com" },
      }) }} />
      <section className="border-b border-white/10 px-5 py-16 md:px-8 md:py-20">
        <div className="mx-auto max-w-5xl">
          <Link href="/torque" className="text-xs font-bold uppercase tracking-[0.22em] text-red-400 hover:text-red-300">Torque Hub</Link>
          <h1 className="mt-5 text-4xl font-black leading-tight tracking-[-0.04em] sm:text-6xl">{title}</h1>
          <p className="mt-6 max-w-3xl text-base leading-7 text-white/65 md:text-lg">
            Choose your model year and wheel type before tightening. The values below are verified only for the U.S. 2019 and 2024 owner manuals, not every 5th-generation model year.
          </p>
          <div className="mt-8 rounded-2xl border border-amber-400/20 bg-amber-400/[0.06] p-5 text-sm leading-6 text-amber-100">
            <strong>Check your exact hardware.</strong> These are factory wheel references. Do not assume they apply to aftermarket or accessory wheels, replacement studs or lug nuts, or another model year. Follow the applicable vehicle and wheel/hardware manufacturer instructions; resolve conflicting specifications before tightening.
          </div>
        </div>
      </section>
      <section className="px-5 py-12 md:px-8">
        <div className="mx-auto max-w-5xl space-y-8">
          {manuals.map((manual) => (
            <article key={manual.year} className="rounded-[1.5rem] border border-white/10 bg-[#0a0b0e] p-6">
              <p className="text-xs font-bold uppercase tracking-[0.18em] text-emerald-300">Verified model year · U.S. manual</p>
              <h2 className="mt-3 text-2xl font-black">{manual.year} Toyota 4Runner</h2>
              <div className="mt-6 grid gap-4 sm:grid-cols-2">
                <div className="rounded-xl border border-white/10 p-5">
                  <h3 className="font-bold">Factory steel wheels</h3>
                  <p className="mt-3 text-3xl font-black">83 <span className="text-base font-normal text-white/60">ft-lbf</span></p>
                  <p className="mt-1 text-white/65">112 N·m</p>
                </div>
                <div className="rounded-xl border border-white/10 p-5">
                  <h3 className="font-bold">Factory aluminum wheels</h3>
                  <p className="mt-3 text-3xl font-black">76 <span className="text-base font-normal text-white/60">ft-lbf</span></p>
                  <p className="mt-1 text-white/65">103 N·m</p>
                </div>
              </div>
              <p className="mt-5 text-sm leading-6 text-white/60">
                Source: Toyota {manual.year} U.S. Owner’s Manual, {manual.publication}, printed page {manual.page}, “Tires and wheels,” wheel nut torque. Checked November 17, 2026. Values are reproduced as listed by Toyota, not recalculated conversions.
              </p>
              <a href={`https://assets.sia.toyota.com/publications/en/om-s/${manual.publication}/pdf/${manual.publication}.pdf#page=${manual.page}`} target="_blank" rel="noreferrer" className="mt-4 inline-block text-sm font-bold text-red-400 hover:text-red-300">
                Open Toyota {manual.year} manual (PDF, p. {manual.page}) →
              </a>
            </article>
          ))}
          <aside className="rounded-2xl border border-amber-400/20 bg-amber-400/[0.06] p-6">
            <h2 className="text-xl font-black">Other years are not verified here</h2>
            <p className="mt-3 text-sm leading-6 text-white/65">Do not carry these values across the entire 2010–2024 generation. Specifications can depend on year and wheel hardware. Check your exact model-year manual and any applicable accessory instructions.</p>
            <p className="mt-3 text-sm leading-6 text-white/65">Use a calibrated torque wrench and the tightening sequence in your manual. Do not lubricate wheel studs or nuts; Toyota warns that oil or grease can cause overtightening and damage.</p>
          </aside>
          <nav aria-label="Related 4Runner guides" className="flex flex-col gap-4 text-sm font-bold text-red-400">
            <Link href="/torque/toyota/6th-gen-4runner" className="hover:text-red-300">2025 4Runner? See the separate 6th-gen torque guide →</Link>
            <Link href="/fitment/toyota/5th-gen-4runner" className="hover:text-red-300">5th-gen 4Runner wheel and tire fitment guide →</Link>
            <Link href="/torque" className="hover:text-red-300">Back to Torque Hub →</Link>
          </nav>
        </div>
      </section>
    </main>
  );
}
