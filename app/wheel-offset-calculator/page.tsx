import type { Metadata } from "next";
import type { Route } from "next";
import Link from "next/link";
import WheelOffsetCalculatorClient from "./WheelOffsetCalculatorClient";

export const metadata: Metadata = {
  title: "Wheel Offset Calculator for Cars",
  description:
    "Use Offset Lab's wheel offset calculator to compare stock and aftermarket wheels, estimate poke, inner clearance, width change, and track width change.",
  alternates: {
    canonical: "/wheel-offset-calculator",
  },
  openGraph: {
    title: "Wheel Offset Calculator for Cars | Offset Lab",
    description:
      "Compare wheel width and offset changes to estimate poke, inner clearance, and track width before buying wheels for your car.",
    url: "/wheel-offset-calculator",
    type: "website",
  },
};

const faqItems = [
  {
    question: "What does wheel offset mean?",
    answer:
      "Wheel offset is the distance in millimeters between the wheel mounting face and the wheel centerline. Higher positive offset pulls the wheel inward, while lower offset pushes it outward.",
  },
  {
    question: "How do I use a wheel offset calculator?",
    answer:
      "Enter your current wheel width and offset, then enter the new wheel width and offset. The calculator estimates how much farther the new wheel sits toward the fender and how much inner clearance changes.",
  },
  {
    question: "Is lower offset always more aggressive?",
    answer:
      "Usually, yes. A lower offset pushes the wheel outward, but width matters too. A wider wheel with the same offset can also add poke and reduce inner clearance.",
  },
  {
    question: "Does tire size affect wheel offset fitment?",
    answer:
      "Tire size does not change wheel offset, but it can change real-world clearance. Wider or taller tires can rub even when the wheel offset math looks reasonable.",
  },
] as const;

const jsonLd = {
  "@context": "https://schema.org",
  "@type": "WebApplication",
  name: "Wheel Offset Calculator for Cars",
  applicationCategory: "AutomotiveApplication",
  operatingSystem: "Any",
  url: "https://offset-lab.com/wheel-offset-calculator",
  description:
    "A car wheel offset calculator for comparing stock and aftermarket wheel width, offset, poke, inner clearance, and track width change.",
  offers: {
    "@type": "Offer",
    price: "0",
    priceCurrency: "USD",
  },
};

const faqJsonLd = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: faqItems.map((item) => ({
    "@type": "Question",
    name: item.question,
    acceptedAnswer: {
      "@type": "Answer",
      text: item.answer,
    },
  })),
};

export default function WheelOffsetCalculatorPage() {
  return (
    <main className="bg-[#050506] text-white">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd) }}
      />

      <section className="border-b border-white/10 px-6 py-16 lg:px-8 lg:py-20">
        <div className="mx-auto grid max-w-7xl gap-10 lg:grid-cols-[0.9fr_1.1fr] lg:items-center">
          <div>
            <p className="text-xs font-black uppercase tracking-[0.28em] text-red-500">
              Offset calculator for cars
            </p>
            <h1 className="mt-5 text-5xl font-black leading-[0.95] tracking-[-0.045em] sm:text-6xl">
              Wheel Offset Calculator for Cars
            </h1>
            <p className="mt-7 max-w-2xl text-base leading-7 text-white/58 sm:text-lg">
              Compare stock and aftermarket wheels to estimate outer poke, inner clearance,
              wheel width change, and track width change before you buy wheels for your car.
            </p>
            <div className="mt-8 flex flex-col gap-3 sm:flex-row">
              <a
                href="#wheel-offset-tool"
                className="inline-flex min-h-12 items-center justify-center rounded-md bg-red-600 px-7 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:bg-red-500"
              >
                Use Calculator
              </a>
              <Link
                href="/fitment"
                className="inline-flex min-h-12 items-center justify-center rounded-md border border-white/20 bg-white/[0.03] px-7 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:border-white/40 hover:bg-white/[0.06]"
              >
                Find Fitment
              </Link>
            </div>
          </div>

          <WheelOffsetCalculatorClient />
        </div>
      </section>

      <section className="px-6 py-16 lg:px-8">
        <div className="mx-auto grid max-w-7xl gap-8 lg:grid-cols-[0.9fr_1.1fr]">
          <aside className="lg:sticky lg:top-28 lg:self-start">
            <p className="text-xs font-black uppercase tracking-[0.28em] text-red-500">
              Fitment basics
            </p>
            <h2 className="mt-4 text-3xl font-black tracking-[-0.03em] sm:text-4xl">
              What offset changes on a car.
            </h2>
            <p className="mt-5 text-sm leading-6 text-white/48">
              Offset is only one part of wheel fitment. Wheel width, tire size, camber,
              ride height, brake clearance, and body clearance all matter when deciding
              whether a setup actually fits.
            </p>
          </aside>

          <div className="grid gap-4">
            <InfoBlock
              title="Positive vs negative wheel offset"
              copy="Positive offset means the mounting face is closer to the outside face of the wheel, which usually pulls the wheel inward. Lower positive offset, zero offset, or negative offset moves the wheel outward and usually creates more poke."
            />
            <InfoBlock
              title="Outer poke"
              copy="Outer poke is how much farther the new wheel sits toward the fender compared with the current wheel. More poke can look more flush, but too much can rub the fender or quarter panel."
            />
            <InfoBlock
              title="Inner clearance"
              copy="Inner clearance is the space between the wheel and suspension or chassis. A wider wheel or higher offset can reduce inner clearance even if the outside position looks conservative."
            />
            <InfoBlock
              title="Next step after offset math"
              copy="After the offset calculator gives you a starting point, use vehicle-specific fitment data to check real-world constraints for your platform."
              href="/fitment/guides"
              cta="Browse fitment guides"
            />
          </div>
        </div>
      </section>

      <section className="border-t border-white/10 bg-[#08090c] px-6 py-16 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <p className="text-xs font-black uppercase tracking-[0.28em] text-red-500">
            Wheel offset FAQ
          </p>
          <h2 className="mt-4 text-3xl font-black tracking-[-0.03em] sm:text-4xl">
            Common offset questions.
          </h2>

          <div className="mt-8 grid gap-4 md:grid-cols-2">
            {faqItems.map((item) => (
              <div key={item.question} className="rounded-lg border border-white/10 bg-black/35 p-6">
                <h3 className="text-lg font-black tracking-[-0.02em]">{item.question}</h3>
                <p className="mt-3 text-sm leading-6 text-white/48">{item.answer}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="border-t border-white/10 px-6 py-12 lg:px-8">
        <div className="mx-auto flex max-w-7xl flex-col justify-between gap-5 rounded-xl border border-white/10 bg-white/[0.025] p-6 md:flex-row md:items-center">
          <div>
            <p className="text-xs font-black uppercase tracking-[0.22em] text-red-500">
              Need vehicle-specific numbers?
            </p>
            <h2 className="mt-3 text-2xl font-black tracking-[-0.03em]">
              Move from offset math to complete fitment.
            </h2>
          </div>
          <div className="flex flex-col gap-3 sm:flex-row">
            <Link
              href="/fitment"
              className="inline-flex min-h-12 items-center justify-center rounded-md bg-red-600 px-6 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:bg-red-500"
            >
              Start Fitment
            </Link>
            <Link
              href="/compare"
              className="inline-flex min-h-12 items-center justify-center rounded-md border border-white/20 px-6 text-sm font-black uppercase tracking-[0.12em] text-white transition hover:border-white/40"
            >
              Compare Setup
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}

function InfoBlock({
  title,
  copy,
  href,
  cta,
}: {
  title: string;
  copy: string;
  href?: Route;
  cta?: string;
}) {
  return (
    <article className="rounded-lg border border-white/10 bg-white/[0.025] p-6">
      <h3 className="text-xl font-black tracking-[-0.03em]">{title}</h3>
      <p className="mt-3 text-sm leading-6 text-white/48">{copy}</p>
      {href && cta ? (
        <Link href={href} className="mt-5 inline-block text-sm font-bold text-red-400 hover:text-red-300">
          {cta} -&gt;
        </Link>
      ) : null}
    </article>
  );
}
