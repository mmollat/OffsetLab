alter table public.fitment_factory_baselines
  add column if not exists year_start int,
  add column if not exists year_end int,
  add column if not exists package_name text,
  add column if not exists market text not null default 'US',
  add column if not exists is_default boolean not null default true;

alter table public.fitment_factory_baselines
  drop constraint if exists fitment_factory_baselines_make_model_trim_key;

drop index if exists fitment_factory_baselines_one_default_idx;

create unique index fitment_factory_baselines_one_default_idx
  on public.fitment_factory_baselines (make, model, trim, market)
  where active and is_default;

drop index if exists fitment_factory_baselines_package_key_idx;

create unique index fitment_factory_baselines_package_key_idx
  on public.fitment_factory_baselines (
    make,
    model,
    trim,
    market,
    coalesce(year_start, 0),
    coalesce(year_end, 9999),
    coalesce(package_name, 'Default')
  )
  where active;

drop index if exists fitment_factory_baselines_lookup_idx;

create index fitment_factory_baselines_lookup_idx
  on public.fitment_factory_baselines (make, model, trim, is_default)
  where active;

comment on column public.fitment_factory_baselines.year_start is
  'First model year this factory baseline applies to.';

comment on column public.fitment_factory_baselines.year_end is
  'Last model year this factory baseline applies to.';

comment on column public.fitment_factory_baselines.package_name is
  'Factory wheel package or trim-specific setup, such as Base 18-inch, Competition, CS, or optional 19-inch.';

comment on column public.fitment_factory_baselines.market is
  'Vehicle market for this baseline, defaulting to US.';

comment on column public.fitment_factory_baselines.is_default is
  'True when this is the default baseline Offset Lab should use for make/model/trim comparison.';
