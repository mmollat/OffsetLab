import Image from "next/image";
import Link from "next/link";

export default function Home() {
  return (
    <main className="min-h-[calc(100vh-73px)] bg-black">
      <section className="mx-auto flex max-w-6xl flex-col items-center px-6 py-20 text-center md:py-28">
        <Image
          src="/logos/offset-lab-primary-logo.png"
          alt="Offset Lab"
          width={700}
          height={300}
          priority
          className="mb-8 h-auto w-full max-w-[520px]"
        />

        <p className="max-w-2xl text-lg text-white/80 md:text-xl">
          Precision fitment. No guesswork.
        </p>

        <p className="mt-4 max-w-2xl text-sm leading-6 text-white/50 md:text-base">
          Get wheel, offset, and tire recommendations based on your Tesla model,
          trim, and the look you want — from OEM+ to aggressive daily fitment.
        </p>

        <div className="mt-10 flex flex-col gap-4 sm:flex-row">
          <Link
            href="/fitment"
            className="rounded-2xl bg-white px-7 py-3.5 font-semibold text-black transition hover:scale-[1.02]"
          >
            Start Fitment
          </Link>
          <Link
            href="/compare"
            className="rounded-2xl border border-white/15 px-7 py-3.5 font-semibold text-white transition hover:border-white/30 hover:bg-white/5"
          >
            Compare Setup
          </Link>
        </div>

        <div className="mt-14 grid w-full max-w-4xl gap-4 md:grid-cols-3">
          <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-5 text-left">
            <p className="text-sm font-semibold text-white">OEM+</p>
            <p className="mt-2 text-sm text-white/60">
              Clean upgrade, near-stock behavior, minimal compromise.
            </p>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-5 text-left">
            <p className="text-sm font-semibold text-white">Flush</p>
            <p className="mt-2 text-sm text-white/60">
              Balanced stance, daily-friendly, filled out properly.
            </p>
          </div>

          <div className="rounded-2xl border border-white/10 bg-white/[0.03] p-5 text-left">
            <p className="text-sm font-semibold text-white">Aggressive</p>
            <p className="mt-2 text-sm text-white/60">
              Wider stance, tighter fitment, stronger visual impact.
            </p>
          </div>
        </div>
      </section>
    </main>
  );
}
