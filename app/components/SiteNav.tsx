"use client";

import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";

const navigation = [
  { href: "/fitment", label: "Fitment" },
  { href: "/torque", label: "Torque Hub" },
  { href: "/compare", label: "Compare" },
  { href: "/gallery", label: "Gallery" },
] as const;

export default function SiteNav() {
  const pathname = usePathname();
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    setMenuOpen(false);
  }, [pathname]);

  useEffect(() => {
    document.body.style.overflow = menuOpen ? "hidden" : "";

    return () => {
      document.body.style.overflow = "";
    };
  }, [menuOpen]);

  return (
    <header className="sticky top-0 z-50 border-b border-white/10 bg-black/95 backdrop-blur-xl">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-5 md:h-[73px] md:px-8">
        <Link href="/" className="relative z-50 flex shrink-0 items-center" aria-label="Offset Lab home">
          <Image
            src="/logos/offset-lab-secondary-logo.png"
            alt="Offset Lab"
            width={160}
            height={40}
            priority
            className="h-auto w-[132px] sm:w-40"
          />
        </Link>

        <nav aria-label="Primary navigation" className="hidden items-center gap-7 text-sm md:flex">
          {navigation.map((item) => {
            const active = pathname === item.href;

            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={active ? "page" : undefined}
                className={`transition ${
                  active ? "text-white" : "text-white/55 hover:text-white"
                }`}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>

        <button
          type="button"
          aria-label={menuOpen ? "Close navigation menu" : "Open navigation menu"}
          aria-expanded={menuOpen}
          aria-controls="mobile-navigation"
          onClick={() => setMenuOpen((open) => !open)}
          className="relative z-50 grid h-11 w-11 place-items-center rounded-lg border border-white/15 bg-white/[0.04] text-white transition hover:border-white/30 hover:bg-white/[0.08] md:hidden"
        >
          <span className="sr-only">{menuOpen ? "Close menu" : "Open menu"}</span>
          <span className="relative block h-4 w-5">
            <span
              className={`absolute left-0 top-0 h-0.5 w-5 rounded-full bg-current transition ${
                menuOpen ? "translate-y-[7px] rotate-45" : ""
              }`}
            />
            <span
              className={`absolute left-0 top-[7px] h-0.5 w-5 rounded-full bg-current transition ${
                menuOpen ? "opacity-0" : ""
              }`}
            />
            <span
              className={`absolute left-0 top-[14px] h-0.5 w-5 rounded-full bg-current transition ${
                menuOpen ? "-translate-y-[7px] -rotate-45" : ""
              }`}
            />
          </span>
        </button>
      </div>

      <div
        id="mobile-navigation"
        className={`fixed inset-x-0 top-16 z-40 h-[calc(100dvh-4rem)] border-t border-white/10 bg-[#050506] transition duration-200 md:hidden ${
          menuOpen
            ? "visible translate-y-0 opacity-100"
            : "invisible -translate-y-3 opacity-0"
        }`}
      >
        <nav aria-label="Mobile navigation" className="flex h-full flex-col px-5 pb-8 pt-5">
          <div className="divide-y divide-white/10 border-y border-white/10">
            {navigation.map((item, index) => {
              const active = pathname === item.href;

              return (
                <Link
                  key={item.href}
                  href={item.href}
                  aria-current={active ? "page" : undefined}
                  className="group flex items-center justify-between py-5"
                >
                  <span className="flex items-center gap-4">
                    <span className="text-[10px] font-black tracking-[0.2em] text-red-500">
                      0{index + 1}
                    </span>
                    <span
                      className={`text-2xl font-black tracking-[-0.03em] ${
                        active ? "text-white" : "text-white/72"
                      }`}
                    >
                      {item.label}
                    </span>
                  </span>
                  <span className="text-lg text-red-500 transition group-hover:translate-x-1">
                    -&gt;
                  </span>
                </Link>
              );
            })}
          </div>

          <div className="mt-auto border-t border-white/10 pt-5">
            <p className="text-xs font-black uppercase tracking-[0.22em] text-white/35">
              Precision fitment. No guesswork.
            </p>
          </div>
        </nav>
      </div>
    </header>
  );
}
