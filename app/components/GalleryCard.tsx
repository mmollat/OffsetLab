import type { GalleryBuild } from "../data/gallery";

export default function GalleryCard({ build }: { build: GalleryBuild }) {
  return (
    <article className="overflow-hidden rounded-3xl border border-white/10 bg-[#11141a] shadow-2xl shadow-black/30">
      <div className="relative h-72 overflow-hidden bg-black">
        <img
          src={build.imageUrl}
          alt={build.label}
          className="h-full w-full object-cover"
          onError={(e) => {
            e.currentTarget.src = "/logos/offset-lab-primary-logo.png";
            e.currentTarget.className = "h-full w-full object-contain p-10 opacity-60";
          }}
        />

        <div className="absolute left-4 top-4 rounded-full border border-emerald-400/30 bg-black/70 px-3 py-1 text-xs font-semibold text-emerald-300 backdrop-blur">
          {build.match}
        </div>
      </div>

      <div className="p-5">
        <h4 className="text-xl font-bold">{build.label}</h4>
        <p className="mt-2 text-sm text-white/60">{build.note}</p>

        {build.verified ? (
          <div className="mt-5 grid gap-3 sm:grid-cols-2">
            <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
              <p className="text-xs text-white/35">Wheel</p>
              <p className="mt-2 text-sm font-semibold">{build.wheel}</p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-black/30 p-4">
              <p className="text-xs text-white/35">Tire</p>
              <p className="mt-2 text-sm font-semibold">{build.tire}</p>
            </div>
          </div>
        ) : (
          <div className="mt-5 rounded-2xl border border-yellow-400/20 bg-yellow-400/5 p-4 text-sm text-yellow-300">
            Visual reference only — specs not verified
          </div>
        )}

        <div className="mt-5 flex justify-between items-center">
          <p className="text-sm text-white/45">Source: {build.sourceName}</p>
          <a
            href={build.sourceUrl}
            target="_blank"
            className="rounded-xl border border-emerald-400/40 px-4 py-2 text-sm text-emerald-300 hover:bg-emerald-400/10"
          >
            View Full Setup →
          </a>
        </div>
      </div>
    </article>
  );
}
