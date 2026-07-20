-- Monday scout factory baseline candidate pack.
--
-- These rows are intentionally marked needs_review. They prevent Offset Lab
-- from deriving factory comparison baselines from recommendation rows while
-- keeping the verification state honest. Before marking any row verified,
-- check against OEM-grade documentation such as a parts catalog, Monroney,
-- owner documentation, or service documentation.

create temp table if not exists monday_baseline_rows (
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

truncate table monday_baseline_rows;

insert into monday_baseline_rows (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Honda', 'FK8', 'Type R', 2017, 2021, 'Factory 20-inch wheel', 'US', true,
   '20x8.5 ET60', '20x8.5 ET60', '245/30R20 front / 245/30R20 rear', '5x120', '64.1mm', 'needs_review',
   'Baseline candidate from FK8 Civic Type R OEM wheel fitment references and owner/community documentation. Verify against Honda parts catalog, Monroney, or owner documentation before marking verified.'),
  ('Honda', 'FL5', 'Type R', 2023, null, 'Factory 19-inch wheel', 'US', true,
   '19x9.5 ET60', '19x9.5 ET60', '265/30R19 front / 265/30R19 rear', '5x120', '64.1mm', 'needs_review',
   'Baseline candidate from Honda Info Center tire/wheel spec plus FL5 OEM wheel fitment references. Verify offset against Honda parts catalog or Monroney before marking verified.'),
  ('Subaru', 'VA', 'WRX', 2015, 2021, 'Factory 18-inch wheel', 'US', true,
   '18x8.5 ET55', '18x8.5 ET55', '245/40R18 front / 245/40R18 rear', '5x114.3', '56.1mm', 'needs_review',
   'Baseline candidate from VA WRX OEM wheel fitment references. Verify against Subaru parts catalog, window sticker, or owner documentation before marking verified.'),
  ('Subaru', 'VA', 'STI', 2018, 2021, 'Factory 19-inch wheel', 'US', true,
   '19x8.5 ET55', '19x8.5 ET55', '245/35R19 front / 245/35R19 rear', '5x114.3', '56.1mm', 'needs_review',
   'Baseline candidate for late VA STI 19-inch factory wheel package. Verify year range and specs against Subaru parts catalog, window sticker, or owner documentation before marking verified.'),
  ('Toyota', 'GR Corolla', 'Core / Premium / Circuit', 2023, null, 'Factory 18-inch wheel', 'US', true,
   '18x8.5 ET30', '18x8.5 ET30', '235/40R18 front / 235/40R18 rear', '5x114.3', null, 'needs_review',
   'Baseline candidate from Toyota GR Corolla tire/wheel publications and GR Corolla OEM wheel fitment references. Verify center bore and market/package details against Toyota parts catalog or Monroney before marking verified.'),
  ('Toyota', 'GR86', 'Base / Premium', 2022, null, 'Base 17-inch factory wheel', 'US', true,
   '17x7.5 ET48', '17x7.5 ET48', '215/45R17 front / 215/45R17 rear', '5x100', '56.1mm', 'needs_review',
   'Baseline candidate from Toyota GR86 published wheel/tire sizing plus OEM fitment references. Verify offset against Toyota/Subaru parts catalog or Monroney before marking verified.'),
  ('Toyota', 'GR86', 'Base / Premium', 2022, null, 'Premium 18-inch factory wheel', 'US', false,
   '18x7.5 ET48', '18x7.5 ET48', '215/40R18 front / 215/40R18 rear', '5x100', '56.1mm', 'needs_review',
   'Optional/premium baseline candidate from Toyota GR86 published wheel/tire sizing plus OEM fitment references. Verify offset against Toyota/Subaru parts catalog or Monroney before marking verified.'),
  ('Toyota', 'Supra', 'MK5 (A90 / A91)', 2020, null, '3.0 factory 19-inch wheel', 'US', true,
   '19x9 ET32', '19x10 ET40', '255/35R19 front / 275/35R19 rear', '5x112', '66.6mm', 'needs_review',
   'Baseline candidate from Toyota GR Supra wheel/tire publications and A90/A91 OEM wheel references. Verify offset and center bore against Toyota parts catalog or Monroney before marking verified.');

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
from monday_baseline_rows br
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
from monday_baseline_rows br
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
from monday_baseline_rows br
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
