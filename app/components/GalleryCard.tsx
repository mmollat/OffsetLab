import type { GalleryBuild } from "../data/gallery";

export default function GalleryCard({ build }: { build: GalleryBuild }) {
  return (
    <article className="overflow-hidden rounded-3xl border border-white/10 bg-[#11141a] shadow-2xl shadow-black/30">
      <div className="relative flex h-64 items-center justify-center overflow-hidden bg-black md:h-72">
        <img
          src={build.imageUrl}
          alt={build.label}
          className="max-h-full max-w-full object-contain transition duration-500 hover:scale-[1.02]"
          referrerPolicy="no-referrer"
          loading="lazy"
        />

        <div className="absolute left-4 top-4 rounded-full border border-emerald-400/30 bg-black/70 px-3 py-1 text-xs font-semibold text-emerald-300 backdrop-blur">
          {build.match}
        </div>
      </div>

      <div className="p-5">
        <h4 className="text-xl font-bold">{build.label}</h4>
        <p className="mt-2 text-sm leading-6 text-white/60">{build.note}</p>

        <div className="mt-5 grid gap-3 sm:grid-cols-2">
          <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
            <p className="text-xs uppercase tracking-wide text-white/35">Wheel</p>
            <p className="mt-2 text-sm font-semibold">{build.wheel}</p>
          </div>
          <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
            <p className="text-xs uppercase tracking-wide text-white/35">Tire</p>
            <p className="mt-2 text-sm font-semibold">{build.tire}</p>
          </div>
        </div>

        <div className="mt-4 flex flex-wrap gap-2">
          {build.tags.map((tag) => (
            <span key={tag} className="rounded-full border border-white/10 px-3 py-1 text-xs text-white/55">
              {tag}
            </span>
          ))}
        </div>

        <div className="mt-5 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <p className="text-sm text-white/45">Source: {build.sourceName}</p>
          <a
            href={build.sourceUrl}
            target="_blank"
            rel="noreferrer"
            className="rounded-2xl border border-emerald-400/40 px-4 py-2 text-center text-sm font-semibold text-emerald-300 transition hover:bg-emerald-400/10"
          >
            View Full Setup →
          </a>
        </div>
      </div>
    </article>
  );
}
