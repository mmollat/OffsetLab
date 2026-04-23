'use client';

import Link from 'next/link';
import { Card } from '@/app/components/Card';

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background px-6 py-10 text-white">
      <div className="mx-auto flex max-w-6xl flex-col gap-8">
        <header className="flex items-center justify-between">
          <div>
            <p className="text-sm uppercase tracking-[0.35em] text-accent">Offset Lab</p>
            <h1 className="mt-3 text-4xl font-semibold tracking-tight md:text-6xl">Precision fitment. No guesswork.</h1>
            <p className="mt-4 max-w-2xl text-base text-muted md:text-lg">
              Tesla Model 3 enthusiast-first fitment recommendations with poke, clearance, and tire math built in.
            </p>
          </div>
        </header>

        <section className="grid gap-6 md:grid-cols-[1.4fr_1fr]">
          <Card className="p-8">
            <div className="flex flex-col gap-6">
              <div>
                <p className="text-sm uppercase tracking-[0.25em] text-muted">MVP</p>
                <h2 className="mt-2 text-2xl font-semibold">Start fitment search</h2>
                <p className="mt-3 max-w-xl text-muted">
                  Pick your trim, style, and suspension. Offset Lab returns a recommendation, fitment metrics, and warnings.
                </p>
              </div>
              <div className="flex flex-wrap gap-3">
                <Link href="/fitment" className="rounded-2xl bg-white px-5 py-3 text-sm font-semibold text-black transition hover:opacity-90">
                  Start Fitment
                </Link>
                <Link href="/compare" className="rounded-2xl border border-border bg-surface2 px-5 py-3 text-sm font-semibold text-white transition hover:border-white/40">
                  Compare Setup
                </Link>
              </div>
            </div>
          </Card>

          <Card className="p-8">
            <p className="text-sm uppercase tracking-[0.25em] text-muted">Included</p>
            <div className="mt-4 space-y-4">
              {[
                'Tesla Model 3 RWD, Long Range AWD, Performance',
                'OEM+, Flush, and Aggressive presets',
                'Poke change and inner clearance math',
                'Tire diameter variance and risk labels',
              ].map((item) => (
                <div key={item} className="rounded-2xl border border-border bg-surface2 px-4 py-3 text-sm text-white">
                  {item}
                </div>
              ))}
            </div>
          </Card>
        </section>
      </div>
    </main>
  );
}
