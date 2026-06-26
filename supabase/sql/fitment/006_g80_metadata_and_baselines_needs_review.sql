-- BMW G80 metadata correction and initial factory baseline pack.
--
-- G8x M cars should not inherit older F8x 5x120 / 72.6mm metadata.
-- These baseline rows remain needs_review until checked against BMW ETK,
-- window-sticker data, or another OEM-grade source.

update public.fitment_presets
set
  bolt_pattern = '5x112',
  center_bore = '66.6mm'
where make = 'BMW'
  and model = 'G80'
  and active = true;

create temp table if not exists g80_baseline_rows (
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

truncate table g80_baseline_rows;

insert into g80_baseline_rows (
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
    'BMW', 'G80', 'M3 (RWD)',
    2021, 2024, 'Base 18/19-inch factory setup', 'US', true,
    '18x9.5 ET20', '19x10.5 ET20', '275/40R18 front / 285/35R19 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial G80 M3 RWD baseline from commonly documented OEM 18/19-inch setup. Verify against BMW ETK/window sticker before marking verified.'
  ),
  (
    'BMW', 'G80', 'M3 (RWD)',
    2021, 2024, 'Optional 19/20-inch factory setup', 'US', false,
    '19x9.5 ET20', '20x10.5 ET20', '275/35R19 front / 285/30R20 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial optional G80 M3 RWD baseline from commonly documented OEM 19/20-inch setup. Verify against BMW ETK/window sticker before marking verified.'
  ),
  (
    'BMW', 'G80', 'M3 Competition xDrive',
    2022, 2024, 'Competition xDrive 19/20-inch factory setup', 'US', true,
    '19x9.5 ET20', '20x10.5 ET20', '275/35R19 front / 285/30R20 rear',
    '5x112', '66.6mm',
    'needs_review',
    'Initial G80 M3 Competition xDrive baseline from commonly documented OEM 19/20-inch setup. Verify against BMW ETK/window sticker before marking verified.'
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
from g80_baseline_rows br
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
from g80_baseline_rows br
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
from g80_baseline_rows br
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
