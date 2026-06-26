-- Allow the public app client to see active factory baselines.
--
-- Pack 008 grants SELECT on the table, but Supabase RLS still filters rows
-- unless an explicit policy allows them. The app only needs active baseline
-- rows, so keep the public policy narrow.

alter table public.fitment_factory_baselines enable row level security;

drop policy if exists fitment_factory_baselines_public_read_active
  on public.fitment_factory_baselines;

create policy fitment_factory_baselines_public_read_active
  on public.fitment_factory_baselines
  for select
  to anon, authenticated
  using (active = true);

grant select on public.fitment_factory_baselines to anon, authenticated;
grant select on public.fitment_factory_baseline_gaps to anon, authenticated;
