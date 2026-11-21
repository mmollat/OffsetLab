-- Offset Lab Fitment
-- Pack 042: verified Ford P702 F-150 factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set year_start = 2021, year_end = 2026
where make = 'Ford' and model = 'P702';

update public.fitment_presets
set factory_front = '18x7.5 ET44', factory_rear = '18x7.5 ET44',
    factory_tire = '275/65R18 front / 275/65R18 rear',
    bolt_pattern = '6x135', center_bore = '87.1mm'
where make = 'Ford' and model = 'P702' and trim = 'F-150'
  and active is not false;

update public.fitment_presets
set factory_front = '17x8.5 ET34', factory_rear = '17x8.5 ET34',
    factory_tire = '315/70R17 front / 315/70R17 rear',
    bolt_pattern = '6x135', center_bore = '87.1mm'
where make = 'Ford' and model = 'P702' and trim = 'Raptor'
  and active is not false;

-- OEM+ keeps the factory tire and square layout with a mild 6 mm outward move.
update public.fitment_presets
set front = '18x7.5 +38', rear = '18x7.5 +38',
    front_tire = '275/65R18', rear_tire = '275/65R18'
where make = 'Ford' and model = 'P702' and trim = 'F-150'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '17x8.5 +28', rear = '17x8.5 +28',
    front_tire = '315/70R17', rear_tire = '315/70R17'
where make = 'Ford' and model = 'P702' and trim = 'Raptor'
  and style = 'oemplus' and active is not false;

create temp table if not exists ford_p702_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table ford_p702_verified_baselines;

insert into ford_p702_verified_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
values
 ('Ford','P702','F-150',2021,2026,
  '18-inch 4x4 all-terrain production package','US',true,
  '18x7.5 ET44','18x7.5 ET44',
  '275/65R18 front / 275/65R18 rear','6x135','87.1mm','verified',
  'The Ford 2021 F-150 US order guide assigns 275/65R18 all-terrain tires to the 18-inch 4x4 production packages. Genuine Ford P702 18x7.5 wheel family ML3Z/ML3V-1007 is marked ET44; Ford hardware is 6x135 with an 87.1 mm hub bore and M14x1.5 lug nuts. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/f150/pdfs/2021-F-150-Order-Guide.pdf ; https://www.wheelership.com/18-x-7-5-ford-f-150-2021-2022-2023-2024-factory-oem-wheel-rim-10343-take-off.html'),
 ('Ford','P702','Raptor',2021,2026,
  '17-inch Raptor 35 production package','US',true,
  '17x8.5 ET34','17x8.5 ET34',
  '315/70R17 front / 315/70R17 rear','6x135','87.1mm','verified',
  'Ford 2021 F-150 Raptor technical specifications identify the standard 17x8.5 cast-aluminum wheel and LT315/70R17 BFGoodrich All-Terrain T/A KO2 tire package. Genuine Ford wheel ML3V-1007-CA is documented at ET34, 6x135 and 87.1 mm with M14x1.5 lug nuts. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/product/2021/f150/raptor/pdf/2021-Ford-F-150-Raptor-Tech-Specs.pdf ; https://www.detroitwheelandtire.com/2021-2023-ford-f-150-raptor-17x8-5-grey-black-genuine-oem-wheel-ml3v-1007-ca-hol-10459-gbb-a.html');

delete from public.fitment_factory_baselines existing
where existing.make = 'Ford' and existing.model = 'P702'
  and existing.trim in ('F-150','Raptor');

insert into public.fitment_factory_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
select make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from ford_p702_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
  bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make = 'Ford' and model = 'P702' and active
order by trim,year_start desc;
