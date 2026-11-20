-- Offset Lab Fitment
-- Pack 026: verified US-market Cadillac V-Series factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- GM's parts storefront labels offset values with an inch unit in some rendered
-- fields, but the values are the OE millimetre offsets (for example 1.26 in is
-- the storefront conversion of 32 mm). Source notes retain the GM part numbers.

update public.vehicle_models set year_start = 2016, year_end = 2019
where make = 'Cadillac' and model = 'Alpha';

update public.vehicle_models set year_start = 2022, year_end = null
where make = 'Cadillac' and model = 'Alpha2';

update public.vehicle_models set year_start = 2009, year_end = 2015
where make = 'Cadillac' and model = 'V2';

update public.vehicle_models set year_start = 2016, year_end = 2019
where make = 'Cadillac' and model = 'V3';

update public.fitment_presets
set
  bolt_pattern = '5x120',
  center_bore = '66.9mm',
  factory_front = case
    when model = 'Alpha' and trim = 'ATS-V' then '18x9 ET28'
    when model = 'Alpha2' and trim = 'CT4-V Blackwing' then '18x9 ET32'
    when model = 'Alpha2' and trim = 'CT5-V Blackwing' then '19x10 ET32'
    when model = 'V2' then '19x9 ET51'
    when model = 'V3' and trim = 'CTS-V' then '19x9.5 ET23'
  end,
  factory_rear = case
    when model = 'Alpha' and trim = 'ATS-V' then '18x9.5 ET36'
    when model = 'Alpha2' and trim = 'CT4-V Blackwing' then '18x9.5 ET48'
    when model = 'Alpha2' and trim = 'CT5-V Blackwing' then '19x11 ET50'
    when model = 'V2' and trim = 'CTS-V Coupe' then '19x10 ET40'
    when model = 'V2' and trim = 'CTS-V Sedan' then '19x9.5 ET56'
    when model = 'V3' and trim = 'CTS-V' then '19x10 ET39'
  end,
  factory_tire = case
    when model = 'Alpha' and trim = 'ATS-V'
      then '255/35ZR18 front / 275/35ZR18 rear'
    when model = 'Alpha2' and trim = 'CT4-V Blackwing'
      then '255/35ZR18 front / 275/35ZR18 rear'
    when model = 'Alpha2' and trim = 'CT5-V Blackwing'
      then '275/35ZR19 front / 305/30ZR19 rear'
    when model = 'V2'
      then '255/40ZR19 front / 285/35ZR19 rear'
    when model = 'V3' and trim = 'CTS-V'
      then '265/35ZR19 front / 295/30ZR19 rear'
  end
where make = 'Cadillac'
  and (
    (model = 'Alpha' and trim = 'ATS-V')
    or (model = 'Alpha2' and trim in ('CT4-V Blackwing', 'CT5-V Blackwing'))
    or (model = 'V2' and trim in ('CTS-V Coupe', 'CTS-V Sedan'))
    or (model = 'V3' and trim = 'CTS-V')
  )
  and active is not false;

create temp table if not exists cadillac_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table cadillac_verified_baselines;

insert into cadillac_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  (
    'Cadillac', 'Alpha', 'ATS-V', 2016, 2019,
    'Standard forged 18-inch factory setup', 'US', true,
    '18x9 ET28', '18x9.5 ET36',
    '255/35ZR18 front / 275/35ZR18 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac technical data specifies 18x9 front and 18x9.5 rear wheels with 255/35ZR18 and 275/35ZR18 tires. GM Genuine Parts front wheels 23459798/22942954 specify 18x9 ET28; rear wheel 22945697 specifies 18x9.5 ET36. GM OE brake/hub and wheel records establish the ATS-V-specific 5x120 pattern, 66.9 mm hub pilot, and M14 hardware. Sources: https://media.cadillac.com/content/dam/Media/documents/INTL/cadillac/2019/passanger-cars/ats-v/Technische-Daten-Cadillac-ATS-V-DE.pdf ; https://parts.gmparts.com/product/gm-genuine-parts-18x9-inch-aluminum-wheel-23459798 ; https://parts.gmparts.com/product/gm-genuine-parts-18x95-inch-aluminum-rear-wheel-22945697 ; https://parts.gmparts.com/product/gm-genuine-parts-rear-brake-rotor-85589611'
  ),
  (
    'Cadillac', 'Alpha2', 'CT4-V Blackwing', 2022, null,
    'Standard forged 18-inch factory setup', 'US', true,
    '18x9 ET32', '18x9.5 ET48',
    '255/35ZR18 front / 275/35ZR18 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac/GM order documentation specifies 255/35ZR18 front and 275/35ZR18 rear tires. GM Genuine Parts front wheel 84319209 specifies 18x9, 5x120 and a 1.26-inch converted offset field (32 mm); rear wheel 84319214 specifies 18x9.5, 5x120 and 1.89 inches (48 mm). GM hub/wheel records establish a 66.9 mm hub pilot and M14 hardware. Sources: https://cadillacvnet.com/tech-center/2022/blackwing/2022-cadillac-ct4-v-blackwing-order-guide.pdf ; https://parts.gmparts.com/product/gm-genuine-parts-front-wheel-84319209 ; https://parts.gmparts.com/product/gm-genuine-parts-rear-wheel-84319214'
  ),
  (
    'Cadillac', 'Alpha2', 'CT5-V Blackwing', 2022, null,
    'Standard forged 19-inch factory setup', 'US', true,
    '19x10 ET32', '19x11 ET50',
    '275/35ZR19 front / 305/30ZR19 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac technical specifications publish 19x10 front and 19x11 rear wheels with 275/35ZR19 and 305/30ZR19 tires. GM Genuine Parts front wheel 84319217 specifies 19x10, 5x120 and a 1.26-inch converted offset field (32 mm); rear wheel 84319221 specifies 19x11, 5x120 and 1.97 inches (50 mm). GM hub/wheel records establish a 66.9 mm hub pilot and M14 hardware. Sources: https://news.cadillac.com/newsroom.detail.html/Pages/news/us/en/2024/jan/0124-ct5v.html ; https://parts.gmparts.com/product/gm-genuine-parts-front-wheel-84319217 ; https://parts.gmparts.com/product/gm-genuine-parts-rear-wheel-84319221'
  ),
  (
    'Cadillac', 'V2', 'CTS-V Coupe', 2011, 2015,
    'Standard forged 19-inch factory setup', 'US', true,
    '19x9 ET51', '19x10 ET40',
    '255/40ZR19 front / 285/35ZR19 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac order/accessory documentation specifies the 19x9 front / 19x10 rear forged setup and 255/40ZR19 / 285/35ZR19 tires. GM Genuine Parts front wheel 20951881 specifies 19x9 ET51 and a 66.95 mm wheel pilot. GM OE rear wheel 9598615/20982650 catalog data specifies 19x10 ET40; catalog descriptions identify 5x120 M14 hardware. Sources: https://parts.gmparts.com/product/gm-genuine-parts-front-wheel-20951881 ; https://www.gmpartsgiant.com/parts-list/2015-cadillac-cts-v_series_coupe/brakes_rear_axle_propeller_shaft_wheels_tires/wheels.html ; https://autofanatik.ru/data/2013/08/03/1234213904/Cadillac_acc.pdf'
  ),
  (
    'Cadillac', 'V2', 'CTS-V Sedan', 2009, 2014,
    'Standard forged 19-inch factory setup', 'US', true,
    '19x9 ET51', '19x9.5 ET56',
    '255/40ZR19 front / 285/35ZR19 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac/GM documentation specifies 19x9 front and 19x9.5 rear wheels with 255/40ZR19 and 285/35ZR19 tires. GM Genuine Parts front wheel 20951881 specifies 19x9 ET51 and a 66.95 mm wheel pilot. The GM parts catalog identifies the sedan rear wheel as 19x9.5 ET56 with 5x120 M14 hardware. Sources: https://parts.gmparts.com/product/gm-genuine-parts-front-wheel-20951881 ; https://www.gmpartsgiant.com/parts-list/2014-cadillac-cts-v_series_sedan/brakes_rear_axle_propeller_shaft_wheels_tires/wheels.html ; https://media.cadillac.com/dld/content/product/public/us/en/cadillacracing/PressKits/_jcr_content/par/sectioncontainer/par/download_10/file.res/Cadillac%20Media%20Kit.pdf'
  ),
  (
    'Cadillac', 'V3', 'CTS-V', 2016, 2019,
    'Standard forged 19-inch factory setup', 'US', true,
    '19x9.5 ET23', '19x10 ET39',
    '265/35ZR19 front / 295/30ZR19 rear',
    '5x120', '66.9mm', 'verified',
    'Cadillac technical data and the US brochure specify 19x9.5 front / 19x10 rear wheels with 265/35ZR19 and 295/30ZR19 tires. GM Genuine Parts front wheel 22942961/23483709 specifies 19x9.5 ET23; rear wheel 22942964 specifies 19x10 ET39. GM wheel/hub records establish 5x120, a 66.9 mm hub pilot, and M14 hardware. Sources: https://www.cadillac.com/content/dam/cadillac/na/us/english/index/downloads/vehiclebrochures/brochures/2019/19_CAD_CTS_50999.pdf ; https://media.cadillac.com/content/dam/Media/documents/INTL/cadillac/2019/passanger-cars/cts-v/Technische-Daten-Cadillac-CTS-V-DE.pdf ; https://parts.gmparts.com/product/gm-genuine-parts-front-wheel-22942961 ; https://parts.gmparts.com/product/gm-genuine-parts-19x10-inch-aluminum-rear-wheel-22942964'
  );

delete from public.fitment_factory_baselines existing
where existing.make = 'Cadillac'
  and (
    (existing.model = 'Alpha' and existing.trim = 'ATS-V')
    or (existing.model = 'Alpha2' and existing.trim in ('CT4-V Blackwing', 'CT5-V Blackwing'))
    or (existing.model = 'V2' and existing.trim in ('CTS-V Coupe', 'CTS-V Sedan'))
    or (existing.model = 'V3' and existing.trim = 'CTS-V')
  );

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from cadillac_verified_baselines;

select model, trim, year_start, year_end, front, rear, tire, bolt_pattern,
  center_bore, source_status
from public.fitment_factory_baselines
where make = 'Cadillac' and active
order by model, trim;
