-- BMW F90 M5 factory baseline pack.
--
-- These rows are intentionally marked needs_review. They are seeded from
-- commonly documented OEM wheel style dimensions plus public factory tire-size
-- references, but should be verified against BMW ETK/window-sticker data
-- before changing source_status to verified.

create temp table if not exists f90_baseline_rows (
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

truncate table f90_baseline_rows;

insert into f90_baseline_rows (
  make,
  model,
  trim,
  year_start,
  year_end,
  package_name,
  market,
  is_default,
  front,
  rear,
  tire,
  bolt_pattern,
  center_bore,
  source_status,
  source_note
)
values
  (
    'BMW', 'F90', 'M5',
    2018, 2020, 'Base 19-inch Style 705M', 'US', true,
    '19x9.5 ET28', '19x10.5 ET28', '275/40R19 front / 285/40R19 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial F90 M5 baseline from commonly documented OEM Style 705M dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F90', 'M5',
    2018, 2020, 'Optional 20-inch Style 706M', 'US', false,
    '20x9.5 ET28', '20x10.5 ET28', '275/35R20 front / 285/35R20 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial optional F90 M5 baseline from commonly documented OEM Style 706M dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F90', 'M5 Competition',
    2019, 2023, 'Competition 20-inch Style 706M', 'US', true,
    '20x9.5 ET28', '20x10.5 ET28', '275/35R20 front / 285/35R20 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial F90 M5 Competition baseline from commonly documented OEM Style 706M dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F90', 'M5 CS',
    2022, 2022, 'CS 20-inch Style 789M forged', 'US', true,
    '20x9.5 ET28', '20x10.5 ET28', '275/35R20 front / 285/35R20 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial F90 M5 CS baseline from commonly documented OEM Style 789M forged dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
  );

update public.fitment_factory_baselines existing
set
  front = br.front,
  rear = br.rear,
  tire = br.tire,
  bolt_pattern = br.bolt_pattern,
  center_bore = br.center_bore,
  source_status = br.source_status,
  source_note = br.source_note,
  updated_at = now()
from f90_baseline_rows br
where existing.make = br.make
  and existing.model = br.model
  and existing.trim = br.trim
  and existing.market = br.market
  and coalesce(existing.year_start, 0) = coalesce(br.year_start, 0)
  and coalesce(existing.year_end, 9999) = coalesce(br.year_end, 9999)
  and coalesce(existing.package_name, 'Default') = coalesce(br.package_name, 'Default')
  and existing.active = true
  and existing.source_status <> 'verified';

update public.fitment_factory_baselines existing
set
  active = false,
  updated_at = now()
from f90_baseline_rows br
where br.is_default = true
  and existing.make = br.make
  and existing.model = br.model
  and existing.trim = br.trim
  and existing.market = br.market
  and existing.is_default = true
  and existing.active = true
  and existing.source_status <> 'verified'
  and (
    coalesce(existing.year_start, 0) <> coalesce(br.year_start, 0)
    or coalesce(existing.year_end, 9999) <> coalesce(br.year_end, 9999)
    or coalesce(existing.package_name, 'Default') <> coalesce(br.package_name, 'Default')
  );

insert into public.fitment_factory_baselines (
  make,
  model,
  trim,
  year_start,
  year_end,
  package_name,
  market,
  is_default,
  front,
  rear,
  tire,
  bolt_pattern,
  center_bore,
  source_status,
  source_note
)
select
  br.make,
  br.model,
  br.trim,
  br.year_start,
  br.year_end,
  br.package_name,
  br.market,
  br.is_default,
  br.front,
  br.rear,
  br.tire,
  br.bolt_pattern,
  br.center_bore,
  br.source_status,
  br.source_note
from f90_baseline_rows br
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = br.make
    and existing.model = br.model
    and existing.trim = br.trim
    and existing.market = br.market
    and coalesce(existing.year_start, 0) = coalesce(br.year_start, 0)
    and coalesce(existing.year_end, 9999) = coalesce(br.year_end, 9999)
    and coalesce(existing.package_name, 'Default') = coalesce(br.package_name, 'Default')
    and existing.active = true
)
and not (
  br.is_default = true
  and exists (
    select 1
    from public.fitment_factory_baselines existing_default
    where existing_default.make = br.make
      and existing_default.model = br.model
      and existing_default.trim = br.trim
      and existing_default.market = br.market
      and existing_default.is_default = true
      and existing_default.active = true
  )
);
