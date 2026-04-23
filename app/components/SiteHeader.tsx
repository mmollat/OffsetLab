import Image from 'next/image';
import Link from 'next/link';

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-20 border-b border-white/10 bg-black/70 backdrop-blur">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
        <Link href="/" className="flex items-center gap-3">
          <Image src="/logos/offset-lab-secondary-logo.png" alt="Offset Lab" width={250} height={57} priority className="h-8 w-auto md:h-10" />
        </Link>
        <nav className="flex items-center gap-2 text-sm font-medium">
          <Link href="/fitment" className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-white transition hover:border-white/30 hover:bg-white/10">
            Fitment
          </Link>
          <Link href="/compare" className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-white transition hover:border-white/30 hover:bg-white/10">
            Compare
          </Link>
        </nav>
      </div>
    </header>
  );
}
