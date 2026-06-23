import { supabase } from "../lib/supabase";

export const dynamic = "force-dynamic";

export default async function BuildsPage() {
  const { data: builds, error } = await supabase
    .from("build_submissions")
    .select("id, created_at, make, model, trim, year, fitment_style, front_wheel, rear_wheel, front_tire, rear_tire, suspension, notes, image_url, instagram_handle")
    .eq("status", "approved")
    .order("created_at", { ascending: false });

  return (
    <main className="min-h-screen bg-[#050609] px-5 py-10 text-white">
      <div className="mx-auto max-w-7xl">
        <div className="mb-10">
          <p className="text-xs uppercase tracking-[0.25em] text-emerald-300/70">Community Builds</p>
          <h1 className="mt-2 text-3xl font-bold md:text-5xl">Approved Builds Gallery</h1>
          <p className="mt-3 max-w-2xl text-white/55">
            Real community-submitted builds approved for the Offset Lab gallery.
          </p>
        </div>

        {error ? (
          <div className="rounded-3xl border border-red-500/20 bg-red-500/10 p-6 text-red-200">
            Failed to load approved builds.
          </div>
        ) : builds && builds.length > 0 ? (
          <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
            {builds.map((build) => (
              <article key={build.id} className="overflow-hidden rounded-3xl border border-white/10 bg-white/[0.03]">
                <div className="aspect-[4/3] bg-black/30">
                  {build.image_url ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={build.image_url} alt={`${build.make} ${build.model}`} className="h-full w-full object-cover" />
                  ) : (
                    <div className="flex h-full items-center justify-center text-white/35">No image</div>
                  )}
                </div>
                <div className="p-5">
                  <p className="text-sm text-white/45">{build.year || ""} {build.make} {build.model}</p>
                  <h2 className="mt-1 text-xl font-semibold">{build.trim}</h2>
                  <p className="mt-2 text-sm text-emerald-300">{build.fitment_style}</p>

                  <div className="mt-4 space-y-2 text-sm text-white/70">
                    <p><span className="text-white/40">Front:</span> {build.front_wheel} / {build.front_tire}</p>
                    <p><span className="text-white/40">Rear:</span> {build.rear_wheel} / {build.rear_tire}</p>
                    {build.suspension ? <p><span className="text-white/40">Suspension:</span> {build.suspension}</p> : null}
                    {build.instagram_handle ? <p><span className="text-white/40">Instagram:</span> {build.instagram_handle}</p> : null}
                  </div>

                  {build.notes ? (
                    <p className="mt-4 text-sm leading-6 text-white/55">{build.notes}</p>
                  ) : null}
                </div>
              </article>
            ))}
          </div>
        ) : (
          <div className="rounded-3xl border border-white/10 bg-white/[0.03] p-8 text-white/60">
            No approved builds yet.
          </div>
        )}
      </div>
    </main>
  );
}
