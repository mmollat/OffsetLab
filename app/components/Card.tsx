export function Card({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return <div className={`rounded-3xl border border-border bg-surface shadow-soft ${className}`}>{children}</div>;
}
