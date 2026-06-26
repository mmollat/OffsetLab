-- Initial BMW M factory baseline pack.
--
-- These rows are intentionally marked needs_review. They are seeded from
-- commonly documented OEM wheel style dimensions plus enthusiast fitment-guide
-- cross-checks, but should be verified against BMW ETK/window-sticker data
-- before changing source_status to verified.

with baseline_rows (
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
) as (
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
    )
)
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
from baseline_rows br
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
);
