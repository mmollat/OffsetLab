-- Monday scout factory baseline candidate pack.
--
-- These rows are intentionally marked needs_review. They close confirmed
-- factory-baseline gaps for active fitment platforms while preserving the
-- requirement to verify each row against OEM-grade documentation before
-- marking it verified.

create temp table if not exists scout_baseline_rows (
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

truncate table scout_baseline_rows;

insert into scout_baseline_rows (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Volkswagen', 'MK8', 'GTI', 2022, null, 'Factory 18-inch wheel', 'US', true,
   '18x7.5 ET51', '18x7.5 ET51', '225/40R18 front / 225/40R18 rear', '5x112', '57.1mm', 'needs_review',
   'Baseline candidate from VW wheel/tire combination references and MK8 GTI OEM fitment references. Verify against VW parts catalog, Monroney, or owner documentation before marking verified.'),
  ('Volkswagen', 'MK8', 'Golf R', 2022, null, 'Factory 19-inch wheel', 'US', true,
   '19x8 ET50', '19x8 ET50', '235/35R19 front / 235/35R19 rear', '5x112', '57.1mm', 'needs_review',
   'Baseline candidate from VW Golf R press/spec data and OEM fitment references. Verify against VW parts catalog, Monroney, or owner documentation before marking verified.'),
  ('Ford', 'S650', 'EcoBoost', 2024, null, 'Base 18-inch factory setup', 'US', true,
   '18x8 ET40', '18x8 ET40', '235/50R18 front / 235/50R18 rear', '5x114.3', '70.5mm', 'needs_review',
   'Baseline candidate from Ford Mustang tire/wheel publications and S650 OEM fitment references. Verify offset and exact package against Ford parts catalog, door placard, or window sticker before marking verified.'),
  ('Ford', 'S650', 'GT', 2024, null, 'Performance Package 19-inch factory setup', 'US', true,
   '19x9 ET45', '19x9.5 ET52', '255/40R19 front / 275/40R19 rear', '5x114.3', '70.5mm', 'needs_review',
   'Baseline candidate from Ford Mustang Performance Package wheel/tire publications and S650 OEM fitment references. Verify offset and package against Ford parts catalog, door placard, or window sticker before marking verified.'),
  ('Ford', 'S650', 'Dark Horse', 2024, null, 'Dark Horse 19-inch factory setup', 'US', true,
   '19x9.5 ET45', '19x10 ET50', '255/40R19 front / 275/40R19 rear', '5x114.3', '70.5mm', 'needs_review',
   'Baseline candidate from Ford Mustang Dark Horse wheel/tire publications and S650 OEM fitment references. Verify offsets and package against Ford parts catalog, door placard, or window sticker before marking verified.'),
  ('Hyundai', 'CN7', 'Elantra N', 2022, null, 'Factory 19-inch forged wheel', 'US', true,
   '19x8 ET55', '19x8 ET55', '245/35R19 front / 245/35R19 rear', '5x114.3', '67.1mm', 'needs_review',
   'Baseline candidate from Hyundai Elantra N wheel/tire specifications and OEM fitment references. Verify offset against Hyundai parts catalog or window sticker before marking verified.'),
  ('Cadillac', 'Alpha2', 'CT4-V Blackwing', 2022, null, 'Factory 18-inch staggered wheel', 'US', true,
   '18x9 ET20', '18x9.5 ET44', '255/35ZR18 front / 275/35ZR18 rear', '5x120', '66.9mm', 'needs_review',
   'Baseline candidate from Cadillac CT4-V Blackwing tire publications and OEM fitment references. Verify offsets against GM parts catalog, wheel casting markings, or window sticker before marking verified.'),
  ('Cadillac', 'Alpha2', 'CT5-V Blackwing', 2022, null, 'Factory 19-inch staggered wheel', 'US', true,
   '19x10 ET20', '19x11 ET50', '275/35ZR19 front / 305/30ZR19 rear', '5x120', '66.9mm', 'needs_review',
   'Baseline candidate from Cadillac CT5-V Blackwing official wheel/tire specifications and OEM fitment references. Verify offsets against GM parts catalog, wheel casting markings, or window sticker before marking verified.'),
  ('Subaru', 'VB', 'WRX', 2022, null, 'Factory 18-inch wheel', 'US', true,
   '18x8.5 ET55', '18x8.5 ET55', '245/40R18 front / 245/40R18 rear', '5x114.3', '56.1mm', 'needs_review',
   'Baseline candidate from Subaru WRX owner/manual tire specifications and VB WRX OEM fitment references. Verify trim/package details against Subaru parts catalog, door placard, or window sticker before marking verified.');

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
from scout_baseline_rows br
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
set active = false, updated_at = now()
from scout_baseline_rows br
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
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  br.make, br.model, br.trim, br.year_start, br.year_end, br.package_name, br.market, br.is_default,
  br.front, br.rear, br.tire, br.bolt_pattern, br.center_bore, br.source_status, br.source_note
from scout_baseline_rows br
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
