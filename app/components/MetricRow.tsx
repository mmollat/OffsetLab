export function MetricRow({ label, value, sub }: { label: string; value: string; sub?: string }) {
  return (
    <div className="flex items-start justify-between gap-4 border-b border-border/60 py-3 last:border-b-0">
      <div>
        <p className="text-sm text-muted">{label}</p>
        {sub ? <p className="mt-1 text-xs text-muted/80">{sub}</p> : null}
      </div>
      <p className="text-right text-sm font-semibold text-white">{value}</p>
    </div>
  );
}
