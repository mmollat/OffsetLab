-- Offset Lab Torque Hub
-- Pack 000: add source metadata columns to torque_specs.
--
-- Run this once in Supabase SQL Editor before running any researched
-- torque data seed packs. It is safe to re-run.

alter table public.torque_specs
  add column if not exists source_name text,
  add column if not exists source_url text,
  add column if not exists source_note text,
  add column if not exists source_checked_at timestamptz;

create index if not exists torque_specs_generation_category_idx
  on public.torque_specs (generation_id, category_id);

create index if not exists torque_specs_source_status_idx
  on public.torque_specs (source_status);

