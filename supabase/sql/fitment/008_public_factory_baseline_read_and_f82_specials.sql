-- Allow the public app client to read factory baseline rows.
--
-- The Next.js client reads public.fitment_factory_baselines directly before
-- falling back to legacy fitment_presets.factory_* columns. Without this grant,
-- the deployed anon client receives permission denied and cannot use the new
-- factory baseline system.

grant select on public.fitment_factory_baselines to anon, authenticated;

-- BMW F82 M4 CS / GTS cleanup.
--
-- The live fitment preset data has one combined trim, "M4 CS / GTS". Split it
-- into separate active M4 CS and M4 GTS trim rows, while preserving the existing
-- recommendation values. These rows remain fitment recommendations, not OEM
-- baselines. The factory baselines below are intentionally needs_review.

create temp table if not exists f82_combined_preset_rows as
select *
from public.fitment_presets
where false;

truncate table f82_combined_preset_rows;

insert into f82_combined_preset_rows
select *
from public.fitment_presets
where make = 'BMW'
  and model = 'F82'
  and trim = 'M4 CS / GTS'
  and active = true;

insert into public.fitment_presets (
  make,
  model,
  trim,
  style,
  title,
  subtitle,
  front,
  rear,
  front_tire,
  rear_tire,
  poke_front,
  poke_rear,
  inner_front,
  inner_rear,
  diameter,
  aggression,
  daily,
  risk,
  verdict,
  warnings,
  alternate,
  active,
  sort_order,
  bolt_pattern,
  center_bore,
  factory_front,
  factory_rear,
  factory_tire
)
select
  make,
  model,
  'M4 GTS',
  style,
  title,
  replace(subtitle, 'M4', 'M4 GTS'),
  front,
  rear,
  front_tire,
  rear_tire,
  poke_front,
  poke_rear,
  inner_front,
  inner_rear,
  diameter,
  aggression,
  daily,
  risk,
  replace(verdict, 'F82 M4', 'F82 M4 GTS'),
  warnings,
  alternate,
  active,
  sort_order + 1,
  bolt_pattern,
  center_bore,
  factory_front,
  factory_rear,
  factory_tire
from f82_combined_preset_rows source_rows
where not exists (
  select 1
  from public.fitment_presets existing
  where existing.make = source_rows.make
    and existing.model = source_rows.model
    and existing.trim = 'M4 GTS'
    and existing.style = source_rows.style
    and existing.active = true
);

update public.fitment_presets fp
set
  trim = 'M4 CS',
  subtitle = replace(fp.subtitle, 'M4', 'M4 CS'),
  verdict = replace(fp.verdict, 'F82 M4', 'F82 M4 CS')
where fp.make = 'BMW'
  and fp.model = 'F82'
  and fp.trim = 'M4 CS / GTS'
  and fp.active = true
  and not exists (
    select 1
    from public.fitment_presets existing
    where existing.make = fp.make
      and existing.model = fp.model
      and existing.trim = 'M4 CS'
      and existing.style = fp.style
      and existing.active = true
  );

update public.fitment_presets fp
set active = false
where fp.make = 'BMW'
  and fp.model = 'F82'
  and fp.trim = 'M4 CS / GTS'
  and fp.active = true;

create temp table if not exists f82_special_baseline_rows (
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

truncate table f82_special_baseline_rows;

insert into f82_special_baseline_rows (
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
    'BMW', 'F82', 'M4 CS',
    2019, 2020, 'CS 19/20-inch Style 763M', 'US', true,
    '19x9 ET29', '20x10 ET40', '265/35R19 front / 285/30R20 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial F82 M4 CS baseline from commonly documented Style 763M dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
  ),
  (
    'BMW', 'F82', 'M4 GTS',
    2016, 2016, 'GTS 19/20-inch Style 666M forged', 'US', true,
    '19x9.5 ET29', '20x10.5 ET40', '265/35R19 front / 285/30R20 rear',
    '5x120', '72.6mm',
    'needs_review',
    'Initial F82 M4 GTS baseline from commonly documented Style 666M forged dimensions and public factory tire-size references. Verify against BMW ETK/window sticker.'
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
from f82_special_baseline_rows br
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
from f82_special_baseline_rows br
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
from f82_special_baseline_rows br
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
