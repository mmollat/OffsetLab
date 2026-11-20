-- Offset Lab Fitment
-- Pack 020: verified Acura TLX Type S and NC1 NSX factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Replaces needs-review rows copied from OEM+ recommendations.

update public.fitment_presets
set
  bolt_pattern = '5x120',
  center_bore = case
    when model = 'NC1' then '70.1mm'
    else '64.1mm'
  end,
  factory_front = case
    when model = 'UB5' then '20x9 ET50'
    when model = 'NC1' then '19x8.5 ET55'
  end,
  factory_rear = case
    when model = 'UB5' then '20x9 ET50'
    when model = 'NC1' then '20x11 ET55'
  end,
  factory_tire = case
    when model = 'UB5' then '255/35R20'
    when model = 'NC1' then '245/35ZR19 front / 305/30ZR20 rear'
  end
where make = 'Acura'
  and (
    (model = 'UB5' and trim = 'TLX Type S')
    or (model = 'NC1' and trim = 'NSX')
  )
  and active is not false;

create temp table if not exists acura_tlx_nsx_verified_baselines (
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

truncate table acura_tlx_nsx_verified_baselines;

insert into acura_tlx_nsx_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Acura', 'UB5', 'TLX Type S', 2021, null,
    'Type S 20-inch factory package', 'US', true,
    '20x9 ET50', '20x9 ET50',
    '255/35R20 front / 255/35R20 rear',
    '5x120', '64.1mm', 'verified',
    'Acura US Type S specifications list 20x9 wheels with 255/35R20 tires. Genuine wheel 42800-TGZ-A80 replacement-wheel records specify ET50, 5x120, and the UB5/UB6 hub is 64.1 mm. Sources: https://acuranews.com/en-US/releases/release-53541be6030b25a47a2899aba1114808-2021-acura-tlx-type-s-press-kit ; https://acuranews.com/en-US/releases/release-a6122f36d84ae07a2f9839772b008b4c-2025-acura-tlx-tlx-type-s-specifications-features ; https://www.detroitwheelandtire.com/2021-2023-acura-tlx-20x9-grey-genuine-oem-wheel-42800-tgz-a80-hol-71882-ggg-a.html'
  ),
  (
    'Acura', 'NC1', 'NSX', 2017, 2022,
    'Standard 19/20-inch factory package', 'US', true,
    '19x8.5 ET55', '20x11 ET55',
    '245/35ZR19 front / 305/30ZR20 rear',
    '5x120', '70.1mm', 'verified',
    'Acura accessory installation bulletin BII13194-01 specifies 19x8.5J inset 55 front, 20x11J inset 55 rear, 245/35ZR19 and 305/30ZR20 tires, and a five-hole 120 mm PCD for the 2020 NSX. The NC1 front hub reference is 70.1 mm. Sources: https://acura.bernardiparts.com/Images/Install/2020_NSX_AluminumWheel_BII13194-01.pdf ; https://deapps.honda.de/inhalt/service/downloads/tyrepdf/nc_nsx.pdf ; https://www.magnumautoequipment.ca/_files/ugd/76c931_4afa1cdefb6e493787eaea018db2d024.pdf'
  );

update public.fitment_factory_baselines existing
set
  year_start = source.year_start,
  year_end = source.year_end,
  package_name = source.package_name,
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
from acura_tlx_nsx_verified_baselines source
where existing.make = source.make
  and existing.model = source.model
  and existing.trim = source.trim
  and existing.market = source.market
  and existing.is_default = true;

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select
  source.make, source.model, source.trim, source.year_start, source.year_end,
  source.package_name, source.market, source.is_default, source.front,
  source.rear, source.tire, source.bolt_pattern, source.center_bore,
  source.source_status, source.source_note
from acura_tlx_nsx_verified_baselines source
where not exists (
  select 1
  from public.fitment_factory_baselines existing
  where existing.make = source.make
    and existing.model = source.model
    and existing.trim = source.trim
    and existing.market = source.market
    and existing.is_default = true
);

select trim, front, rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Acura'
  and (
    (model = 'UB5' and trim = 'TLX Type S')
    or (model = 'NC1' and trim = 'NSX')
  )
  and active
  and is_default
order by model, trim;
