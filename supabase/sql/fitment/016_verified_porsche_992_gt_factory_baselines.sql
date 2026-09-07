-- Offset Lab Fitment
-- Pack 016: verified Porsche 992.1 GT3 and GTS factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Porsche publishes wheel width, diameter, offset, tire size, and center-lock
-- hardware for both applications. Carrera and Turbo rows are intentionally
-- deferred until trim-specific OEM offset documentation is verified.

update public.fitment_presets
set
  bolt_pattern = 'Center-lock',
  center_bore = 'N/A'
where make = 'Porsche'
  and model = '992'
  and trim in ('GT3', 'GTS')
  and active is not false;

create temp table if not exists porsche_992_verified_baseline_rows (
  make text,
  model text,
  trim text,
  year_start int,
  year_end int,
  package_name text,
  market text,
  is_default boolean,
  front text,
  rear text,
  tire text,
  bolt_pattern text,
  center_bore text,
  source_status text,
  source_note text
) on commit drop;

truncate table porsche_992_verified_baseline_rows;

insert into porsche_992_verified_baseline_rows (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Porsche', '992', 'GT3', 2022, 2024,
    '992.1 GT3 standard center-lock setup', 'US', true,
    '20x9.5 ET46', '21x12 ET45',
    '255/35ZR20 front / 315/30ZR21 rear',
    'Center-lock', 'N/A', 'verified',
    'Verified against Porsche Newsroom product technical guidance for the 992 GT3: 20x9.5 ET46 front, 21x12 ET45 rear, with 255/35 ZR20 and 315/30 ZR21 tires; Porsche identifies the wheels as a one-piece center-lock design. Source: https://newsroom.porsche.com/en_AU/2025/products/product-highlights--porsche-911-gt3---pure-and-racing-roots-40869.html'
  ),
  (
    'Porsche', '992', 'GTS', 2022, 2024,
    '992.1 GTS standard center-lock setup', 'US', true,
    '20x8.5 ET50', '21x11.5 ET67',
    '245/35ZR20 front / 305/30ZR21 rear',
    'Center-lock', 'N/A', 'verified',
    'Verified against Porsche Newsroom 992 GTS product guidance: 20x8.5 ET50 front, 21x11.5 ET67 rear, with 245/35 ZR20 and 305/30 ZR21 tires; Porsche identifies the forged wheels as center-lock. Source: https://newsroom.porsche.com/en_AU/2022/products/product-highlights-porsche-911-GTS-27479.html'
  );

update public.fitment_factory_baselines existing
set
  year_start = source.year_start,
  year_end = source.year_end,
  front = source.front,
  rear = source.rear,
  tire = source.tire,
  bolt_pattern = source.bolt_pattern,
  center_bore = source.center_bore,
  source_status = source.source_status,
  source_note = source.source_note,
  is_default = true,
  active = true,
  updated_at = now()
from porsche_992_verified_baseline_rows source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and coalesce(existing.package_name, 'Default') = source.package_name;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from porsche_992_verified_baseline_rows source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and coalesce(existing.package_name, 'Default') = source.package_name
);

select
  count(*) as verified_porsche_992_gt_default_baselines
from public.fitment_factory_baselines
where make = 'Porsche'
  and model = '992'
  and trim in ('GT3', 'GTS')
  and active
  and is_default
  and source_status = 'verified';
