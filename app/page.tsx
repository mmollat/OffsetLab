import Link from "next/link";

const tools = [
  {
    number: "01",
    title: "Fitment",
    description: "Vehicle-specific wheel and tire recommendations built around your stance and driving goal.",
    href: "/fitment",
    cta: "Build your setup",
  },
  {
    number: "02",
    title: "Compare",
    description: "See factory specs and your selected setup side by side, including poke and inner clearance.",
    href: "/compare",
    cta: "Compare fitment",
  },
  {
    number: "03",
    title: "Gallery",
    description: "Explore real vehicles and verified builds filtered by the platform you actually drive.",
    href: "/gallery",
    cta: "Browse builds",
  },
  {
    number: "04",
    title: "Torque Hub",
    description: "Look up vehicle-specific wheel torque specs and practical installation guidance.",
    href: "/torque",
    cta: "Find torque specs",
  },
] as const;

export default function Home() {
  return (
    <main className="bg-[#050506] text-white">
      <section className="relative isolate min-h-[740px] overflow-hidden border-b border-white/10">
        <div
          className="absolute inset-0 -z-30 bg-cover bg-[72%_center] md:bg-center"
          style={{ backgroundImage: "url('/home-hero.png')" }}
        />
        <div className="absolute inset-0 -z-20 bg-gradient-to-r from-black via-black/85 to-black/5" />
        <div className="absolute inset-0 -z-10 bg-gradient-to-t from-[#050506] via-transparent to-black/25" />

        <div className="mx-auto flex min-h-[650px] max-w-7xl items-center px-6 pb-28 pt-20 lg:px-8">
          <div className="max-w-3xl">
            <p className="text-xs font-bold uppercase tracking-[0.3em] text-red-500">
              Precision fitment. No guesswork.
            </p>
            <h1 className="mt-5 max-w-3xl text-5xl font-black leading-[0.95] tracking-[-0.045em] sm:text-6xl lg:text-[82px]">
              Build the Stance
              <span className="block text-red-500">You Want.</span>
            </h1>
            <p className="mt-7 max-w-xl text-base leading-7 text-white/62 sm:text-lg">
              Find the wheel, offset, tire, torque specs, and visual references that fit your car.
            </p>

            <div className="mt-9 flex flex-col gap-3 sm:flex-row">
              <Link
                href="/fitment"
                className="inline-flex min-h-12 items-center justify-center rounded-md bg-red-600 px-7 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:bg-red-500"
              >
                Start Fitment
              </Link>
              <Link
                href="/compare"
                className="inline-flex min-h-12 items-center justify-center rounded-md border border-white/25 bg-black/20 px-7 text-sm font-black uppercase tracking-[0.12em] text-white backdrop-blur transition hover:border-white/50 hover:bg-white/5"
              >
                Compare Setup
              </Link>
            </div>

            <Link
              href="/gallery"
              className="mt-6 inline-flex items-center gap-3 text-sm font-semibold text-white/65 transition hover:text-white"
            >
              Explore verified builds <span className="text-red-500">-&gt;</span>
            </Link>
          </div>
        </div>

        <div className="absolute inset-x-0 bottom-0 border-t border-white/10 bg-black/55 backdrop-blur-md">
          <div className="mx-auto grid max-w-7xl divide-y divide-white/10 px-6 sm:grid-cols-3 sm:divide-x sm:divide-y-0 lg:px-8">
            <TrustItem label="Vehicle-Specific Data" copy="Built around your exact platform" />
            <TrustItem label="Real Fitment Math" copy="Poke, clearance, and diameter" />
            <TrustItem label="Verified Builds" copy="Real-world visual references" />
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-7xl px-6 py-20 lg:px-8 lg:py-28">
        <div className="flex flex-col justify-between gap-6 border-b border-white/10 pb-9 md:flex-row md:items-end">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.28em] text-red-500">Offset Lab Tools</p>
            <h2 className="mt-4 text-3xl font-black tracking-[-0.03em] sm:text-5xl">
              Everything Your Setup Needs.
            </h2>
          </div>
          <p className="max-w-md text-sm leading-6 text-white/45">
            Start with fitment, validate the numbers, then see how it looks on real vehicles.
          </p>
        </div>

        <div className="mt-8 grid gap-px overflow-hidden rounded-xl border border-white/10 bg-white/10 md:grid-cols-2">
          {tools.map((tool) => (
            <Link
              key={tool.title}
              href={tool.href}
              className="group relative min-h-64 bg-[#0a0a0c] p-7 transition hover:bg-[#101014] sm:p-9"
            >
              <span className="text-xs font-bold tracking-[0.25em] text-red-500">{tool.number}</span>
              <h3 className="mt-8 text-3xl font-black tracking-[-0.03em]">{tool.title}</h3>
              <p className="mt-4 max-w-md text-sm leading-6 text-white/48">{tool.description}</p>
              <span className="absolute bottom-8 left-9 text-sm font-bold text-white/75 transition group-hover:text-red-400">
                {tool.cta} -&gt;
              </span>
            </Link>
          ))}
        </div>
      </section>
    </main>
  );
}

function TrustItem({ label, copy }: { label: string; copy: string }) {
  return (
    <div className="py-4 sm:px-6 sm:py-5 first:sm:pl-0">
      <p className="text-xs font-black uppercase tracking-[0.13em] text-white/88">{label}</p>
      <p className="mt-1 text-xs text-white/38">{copy}</p>
    </div>
  );
}
