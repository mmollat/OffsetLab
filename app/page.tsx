'use client';

import Image from 'next/image';
import Link from 'next/link';
import { Card } from '@/app/components/Card';
import { SiteHeader } from '@/app/components/SiteHeader';

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background text-white">
      <SiteHeader />
      <div className="mx-auto flex max-w-6xl flex-col gap-8 px-6 py-10">
        <section className="grid items-center gap-8 md:grid-cols-[1.2fr_0.8fr] md:py-8">
          <div>
            <Image
              src="/logos/offset-lab-primary-logo.png"
              alt="Offset Lab"
              width={900}
              height={370}
              priority
              className="h-auto w-full max-w-3xl"
            />
            <p className="mt-6 max-w-2xl text-base text-muted md:text-lg">
              Tesla Model 3 enthusiast-first fitment recommendations with poke, clearance, and tire math built in.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link href="/fitment" className="rounded-2xl bg-white px-5 py-3 text-sm font-semibold text-black transition hover:opacity-90">
                Start Fitment
              </Link>
              <Link href="/compare" className="rounded-2xl border border-border bg-surface2 px-5 py-3 text-sm font-semibold text-white transition hover:border-white/40">
                Compare Setup
              </Link>
            </div>
          </div>

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

        <section className="grid gap-6 md:grid-cols-3">
          {[
            ['OEM+', 'Close to stock. Clean upgrade.'],
            ['Flush', 'Balanced stance. Daily-friendly.'],
            ['Aggressive', 'Wider stance. Tighter fitment.'],
          ].map(([title, desc]) => (
            <Card key={title} className="p-6">
              <p className="text-lg font-semibold text-white">{title}</p>
              <p className="mt-2 text-sm text-muted">{desc}</p>
            </Card>
          ))}
        </section>
      </div>
    </main>
  );
}
