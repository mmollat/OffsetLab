-- Initial BMW M factory baseline pack.
--
-- These rows are intentionally marked needs_review. They are seeded from
-- commonly documented OEM wheel style dimensions plus enthusiast fitment-guide
-- cross-checks, but should be verified against BMW ETK/window-sticker data
-- before changing source_status to verified.
--
-- Rerun-safe behavior:
-- 1. update exact package matches,
-- 2. deactivate older needs_review default placeholders for the same trim,
-- 3. insert missing package rows without overwriting verified defaults.

create temp table if not exists bmw_m_baseline_rows (
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

truncate table bmw_m_baseline_rows;

insert into bmw_m_baseline_rows (
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
    'BMW', 'F80', 'M3',
    2015, 2018, 'Base 18-inch Style 513M', 'US', true,
    '18x9 ET29', '18x10 ET40', '255/40R18 front / 275/40R18 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW Style 513M F8X fitment and APEX F80/F82 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F80', 'M3',
    2015, 2018, 'Optional 19-inch Style 437M', 'US', false,
    '19x9 ET29', '19x10 ET40', '255/35R19 front / 275/35R19 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial optional baseline from commonly documented BMW Style 437M F8X fitment and APEX F80/F82 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F80', 'M3 Competition',
    2016, 2018, 'Competition 20-inch Style 666M', 'US', true,
    '20x9 ET29', '20x10 ET40', '265/30R20 front / 285/30R20 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW Style 666M Competition fitment. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F80', 'M3 CS',
    2018, 2018, 'CS 19/20-inch Style 763M', 'US', true,
    '19x9 ET29', '20x10 ET40', '265/35R19 front / 285/30R20 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW Style 763M CS fitment. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F82', 'M4',
    2015, 2020, 'Base 18-inch Style 513M', 'US', true,
    '18x9 ET29', '18x10 ET40', '255/40R18 front / 275/40R18 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW Style 513M F8X fitment and APEX F80/F82 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F82', 'M4',
    2015, 2020, 'Optional 19-inch Style 437M', 'US', false,
    '19x9 ET29', '19x10 ET40', '255/35R19 front / 275/35R19 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial optional baseline from commonly documented BMW Style 437M F8X fitment and APEX F80/F82 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F82', 'M4 Competition',
    2016, 2020, 'Competition 20-inch Style 666M', 'US', true,
    '20x9 ET29', '20x10 ET40', '265/30R20 front / 285/30R20 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW Style 666M Competition fitment. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F87', 'M2',
    2016, 2018, 'Base 19-inch Style 437M', 'US', true,
    '19x9 ET29', '19x10 ET40', '245/35R19 front / 265/35R19 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW F87 M2 Style 437M fitment and APEX F87 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F87', 'M2 Competition',
    2019, 2021, 'Competition 19-inch Style 788M', 'US', true,
    '19x9 ET29', '19x10 ET40', '245/35R19 front / 265/35R19 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW F87 M2 Competition fitment and APEX F87 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F87', 'M2 CS',
    2020, 2020, 'CS 19-inch Style 763M', 'US', true,
    '19x9 ET29', '19x10 ET40', '245/35R19 front / 265/35R19 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial baseline from commonly documented BMW F87 M2 CS Style 763M fitment and APEX F87 factory tire-size cross-check. Verify against BMW ETK/window sticker.'
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
from bmw_m_baseline_rows br
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
from bmw_m_baseline_rows br
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
from bmw_m_baseline_rows br
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
