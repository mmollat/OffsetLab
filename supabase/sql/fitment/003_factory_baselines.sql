alter table public.fitment_presets
  add column if not exists factory_front text,
  add column if not exists factory_rear text,
  add column if not exists factory_tire text;

create table if not exists public.fitment_factory_baselines (
  id uuid primary key default gen_random_uuid(),
  make text not null,
  model text not null,
  trim text not null,
  front text not null,
  rear text not null,
  tire text not null,
  bolt_pattern text,
  center_bore text,
  year_start int,
  year_end int,
  package_name text,
  market text not null default 'US',
  is_default boolean not null default true,
  source_status text not null default 'needs_review'
    check (source_status in ('verified', 'needs_review')),
  source_note text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (make, model, trim)
);

create index if not exists fitment_factory_baselines_lookup_idx
  on public.fitment_factory_baselines (make, model, trim, is_default)
  where active;

comment on table public.fitment_factory_baselines is
  'True OEM wheel and tire baselines used for fitment comparison. Do not store OEM+ recommendation rows here.';

comment on column public.fitment_factory_baselines.source_status is
  'verified means checked against an OEM window sticker, owner manual, parts catalog, or other authoritative source.';

insert into public.fitment_factory_baselines (
  make,
  model,
  trim,
  front,
  rear,
  tire,
  bolt_pattern,
  center_bore,
  source_status,
  source_note
)
select distinct on (make, model, trim)
  make,
  model,
  trim,
  factory_front,
  coalesce(factory_rear, factory_front),
  factory_tire,
  bolt_pattern,
  center_bore,
  'needs_review',
  'Backfilled from fitment_presets.factory_* columns. Verify against OEM source before marking verified.'
from public.fitment_presets
where factory_front is not null
  and factory_tire is not null
order by make, model, trim, style
on conflict (make, model, trim) do update
set
  front = excluded.front,
  rear = excluded.rear,
  tire = excluded.tire,
  bolt_pattern = coalesce(excluded.bolt_pattern, public.fitment_factory_baselines.bolt_pattern),
  center_bore = coalesce(excluded.center_bore, public.fitment_factory_baselines.center_bore),
  source_note = excluded.source_note,
  updated_at = now();

create or replace view public.fitment_factory_baseline_gaps as
select distinct
  fp.make,
  fp.model,
  fp.trim,
  fp.bolt_pattern,
  fp.center_bore
from public.fitment_presets fp
left join public.fitment_factory_baselines fb
  on fb.make = fp.make
  and fb.model = fp.model
  and fb.trim = fp.trim
  and fb.active = true
where fp.active = true
  and fb.id is null
order by fp.make, fp.model, fp.trim;

comment on view public.fitment_factory_baseline_gaps is
  'Active fitment trims that do not yet have a true OEM baseline row.';
