import type { GalleryBuild } from "../data/gallery";

export default function GalleryCard({ build }: { build: GalleryBuild }) {
  const showImage = Boolean(build.imageUrl);

  return (
    <article className="overflow-hidden rounded-3xl border border-white/10 bg-[#11141a] shadow-2xl shadow-black/30">
      <div className="relative h-[26rem] overflow-hidden bg-black">
        {showImage ? (
          <img
            src={build.imageUrl}
            alt={build.label}
            className="h-full w-full object-contain"
            onError={(e) => {
              e.currentTarget.style.display = "none";
              const fallback = e.currentTarget.nextElementSibling as HTMLElement | null;
              if (fallback) fallback.style.display = "flex";
            }}
          />
        ) : null}

        <div
          className="flex h-full w-full items-center justify-center bg-white/[0.03]"
          style={{ display: showImage ? "none" : "flex" }}
        >
          <div className="px-6 text-center">
            <p className="text-xs uppercase tracking-[0.35em] text-white/30">
              Verified Image
            </p>
            <p className="mt-3 text-3xl font-black tracking-tight text-white/80">
              Coming Soon
            </p>
            <p className="mt-3 text-sm text-white/45">
              We only show photos when the specs match this fitment category.
            </p>
          </div>
        </div>

        <div className={`absolute left-4 top-4 rounded-full border px-3 py-1 text-xs font-semibold backdrop-blur ${
          build.match === "Exact Match"
            ? "border-emerald-400/30 bg-emerald-400/15 text-emerald-300"
            : build.match === "Close Match"
            ? "border-blue-400/30 bg-blue-400/15 text-blue-300"
            : "border-yellow-400/30 bg-yellow-400/15 text-yellow-300"
        }`}>
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

        <div className="mt-4 rounded-2xl border border-white/10 bg-white/[0.03] p-4">
          <p className="text-xs uppercase tracking-wide text-white/35">Verification</p>
          <p className="mt-2 text-sm text-white/65">{build.verificationNote}</p>
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

          {build.sourceUrl ? (
            <a
              href={build.sourceUrl}
              target="_blank"
              rel="noreferrer"
              className="rounded-2xl border border-emerald-400/40 px-4 py-2 text-center text-sm font-semibold text-emerald-300 transition hover:bg-emerald-400/10"
            >
              View Full Setup →
            </a>
          ) : (
            <span className="rounded-2xl border border-white/10 px-4 py-2 text-center text-sm font-semibold text-white/40">
              Source Pending
            </span>
          )}
        </div>
      </div>
    </article>
  );
}
