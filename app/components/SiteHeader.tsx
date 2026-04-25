import Image from "next/image";
import Link from "next/link";

export default function SiteHeader() {
  return (
    <header className="sticky top-0 z-50 border-b border-white/10 bg-black/85 backdrop-blur">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-5 py-4">
        <Link href="/" className="flex items-center gap-3">
<Image

            src="/logos/offset-lab-secondary-logov2.png"

            alt="Offset Lab"

            width={220}

            height={52}

            priority

            className="h-8 w-auto md:h-10"

          />
        </Link>

        <nav className="flex items-center gap-2 md:gap-3">
          <Link
            href="/fitment"
            className="rounded-xl border border-white/10 px-4 py-2 text-sm text-white/90 hover:border-emerald-400/40 hover:bg-emerald-400/10"
          >
            Fitment
          </Link>

          <Link
            href="/compare"
            className="rounded-xl border border-white/10 px-4 py-2 text-sm text-white/90 hover:border-emerald-400/40 hover:bg-emerald-400/10"
          >
            Compare
          </Link>

          {/* 🔥 NEW */}
          <Link
            href="/gallery"
            className="rounded-xl border border-white/10 px-4 py-2 text-sm text-white/90 hover:border-emerald-400/40 hover:bg-emerald-400/10"
          >
            Gallery
          </Link>
        </nav>
      </div>
    </header>
  );
}
