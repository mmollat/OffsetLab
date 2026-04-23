export default function TrustStrip() {
  const items = [
    ["Real Builds", "Examples are sourced from real vehicle galleries and vendor builds."],
    ["Verified Fitment", "Specs are paired with visual references and fitment notes."],
    ["Community Driven", "Built for enthusiasts who care about stance, offset, and tire choice."],
  ];

  return (
    <section className="mt-10 grid gap-4 rounded-3xl border border-white/10 bg-white/[0.03] p-6 md:grid-cols-3">
      {items.map(([title, text]) => (
        <div key={title} className="rounded-2xl border border-white/10 bg-black/30 p-5">
          <p className="font-semibold">{title}</p>
          <p className="mt-2 text-sm leading-6 text-white/55">{text}</p>
        </div>
      ))}
    </section>
  );
}
