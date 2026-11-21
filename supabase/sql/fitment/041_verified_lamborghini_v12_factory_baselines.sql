-- Offset Lab Fitment
-- Pack 041: verified Lamborghini V12 factory baselines.
--
-- Plain SQL only. Safe to re-run. Wheel and tire dimensions come from
-- Automobili Lamborghini technical literature. Exact offsets and hardware are
-- corroborated by genuine Lamborghini wheel markings/catalog listings.

update public.vehicle_models
set year_start = case model
      when 'LP700' then 2012
      when 'Murciélago LP640' then 2007
      when 'Revuelto' then 2024
    end,
    year_end = case model
      when 'LP700' then 2022
      when 'Murciélago LP640' then 2010
      when 'Revuelto' then 2026
    end
where make = 'Lamborghini'
  and model in ('LP700','Murciélago LP640','Revuelto');

-- Aventador LP700-4 production Iperione/Dione package. This platform uses
-- different five-lug patterns and hub bores at the front and rear axles.
update public.fitment_presets
set factory_front = '19x9 ET32.2',
    factory_rear = '20x12 ET56.7',
    factory_tire = '255/35R19 front / 335/30R20 rear',
    bolt_pattern = '5x112 front / 5x120 rear',
    center_bore = '57.1mm front / 70.1mm rear'
where make = 'Lamborghini' and model = 'LP700'
  and trim = 'Aventador LP700-4' and active is not false;

-- Aventador SVJ Nireo production package uses the factory center-lock system.
update public.fitment_presets
set factory_front = '20x9 ET32.2',
    factory_rear = '21x13 ET66.7',
    factory_tire = '255/30R20 front / 355/25R21 rear',
    bolt_pattern = 'center lock',
    center_bore = 'factory center-lock hub'
where make = 'Lamborghini' and model = 'LP700'
  and trim = 'Aventador SVJ' and active is not false;

update public.fitment_presets
set factory_front = '18x8.5 ET58',
    factory_rear = '18x13 ET14.5',
    factory_tire = '245/35R18 front / 335/30R18 rear',
    bolt_pattern = '5x120.65', center_bore = '72.6mm'
where make = 'Lamborghini' and model = 'Murciélago LP640'
  and trim = 'Base' and active is not false;

update public.fitment_presets
set factory_front = '20x9.5 ET40',
    factory_rear = '21x12 ET44',
    factory_tire = '265/35R20 front / 345/30R21 rear',
    bolt_pattern = '5x120', center_bore = '70.1mm'
where make = 'Lamborghini' and model = 'Revuelto'
  and trim = 'Base' and active is not false;

-- OEM+ remains close to production sizing while moving each wheel outward
-- approximately six millimetres. It must not duplicate the factory baseline.
update public.fitment_presets
set front = '19x9 +26', rear = '20x12 +51',
    front_tire = '255/35R19', rear_tire = '335/30R20'
where make = 'Lamborghini' and model = 'LP700'
  and trim = 'Aventador LP700-4' and style = 'oemplus'
  and active is not false;

update public.fitment_presets
set front = '20x9 +26', rear = '21x13 +61',
    front_tire = '255/30R20', rear_tire = '355/25R21'
where make = 'Lamborghini' and model = 'LP700'
  and trim = 'Aventador SVJ' and style = 'oemplus'
  and active is not false;

update public.fitment_presets
set front = '18x8.5 +52', rear = '18x13 +8',
    front_tire = '245/35R18', rear_tire = '335/30R18'
where make = 'Lamborghini' and model = 'Murciélago LP640'
  and trim = 'Base' and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x9.5 +34', rear = '21x12 +38',
    front_tire = '265/35R20', rear_tire = '345/30R21'
where make = 'Lamborghini' and model = 'Revuelto'
  and trim = 'Base' and style = 'oemplus' and active is not false;

create temp table if not exists lamborghini_v12_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table lamborghini_v12_verified_baselines;

insert into lamborghini_v12_verified_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
values
 ('Lamborghini','LP700','Aventador LP700-4',2012,2016,
  '19/20-inch Iperione production package','US',true,
  '19x9 ET32.2','20x12 ET56.7',
  '255/35R19 front / 335/30R20 rear',
  '5x112 front / 5x120 rear','57.1mm front / 70.1mm rear','verified',
  'Automobili Lamborghini technical data and the factory Aventador brochure specify 19x9 front and 20x12 rear wheels with 255/35ZR19 and 335/30ZR20 Pirelli tires. Genuine Lamborghini Speedline Iperione wheels, parts 470601025 and 470601025A, are marked ET32.2 front and ET56.7 rear. The five-lug platform uses 5x112/57.1 mm front and 5x120/70.1 mm rear hardware with M14x1.5 bolts. Sources: https://preview.thenewsmarket.com/Previews/lamb/DocumentAssets/200081.pdf ; https://autocatalogarchive.com/wp-content/uploads/2018/11/Lamborghini-Aventador-LP-700-4-Roadster-2014-INT.pdf ; https://www.autoteilekauf.com/product/?id=267442607990'),
 ('Lamborghini','LP700','Aventador SVJ',2019,2022,
  '20/21-inch Nireo forged center-lock production package','US',true,
  '20x9 ET32.2','21x13 ET66.7',
  '255/30R20 front / 355/25R21 rear','center lock',
  'factory center-lock hub','verified',
  'Automobili Lamborghini Aventador SVJ technical data explicitly specifies 9Jx20 ET32.2 front and 13Jx21 ET66.7 rear wheels with 255/30ZR20 and 355/25ZR21 Pirelli P Zero Corsa tires. Genuine APP-TECH Nireo SVJ production wheels carry the matching dimensions and factory center-lock mounting. Source: https://preview.thenewsmarket.com/Previews/lamb/DocumentAssets/518315.pdf'),
 ('Lamborghini','Murciélago LP640','Base',2007,2010,
  '18-inch Hercules production package','US',true,
  '18x8.5 ET58','18x13 ET14.5',
  '245/35R18 front / 335/30R18 rear','5x120.65','72.6mm','verified',
  'Automobili Lamborghini LP640 press technical data specifies 8.5x18 front and 13x18 rear wheels with 245/35ZR18 and 335/30ZR18 tires. Genuine Lamborghini Speedline Hercules wheel families 410601017/410601025 are marked ET58 front and ET14.5 rear. Hardware is 5x120.65, 72.6 mm, with M14x1.5 bolts. Sources: https://preview.thenewsmarket.com/Previews/lamb/DocumentAssets/267755.pdf ; https://www.laglobalparts.com/Catalog/Details/13917 ; https://wheel-boys.com/product/lamborghini-murcielago-18-inch-rim-oem-genuine-hercules-wheels-set-of-4/'),
 ('Lamborghini','Revuelto','Base',2024,2026,
  '20/21-inch Triguero production package','US',true,
  '20x9.5 ET40','21x12 ET44',
  '265/35R20 front / 345/30R21 rear','5x120','70.1mm','verified',
  'Automobili Lamborghini Revuelto technical brochure specifies the standard 9.5Jx20 front and 12Jx21 rear package with 265/35ZR20 and 345/30ZR21 Bridgestone Potenza Sport tires. Two documented genuine OEM 47B601017 take-off sets identify ET40 front, ET44 rear and 5x120 hardware; the Revuelto hub bore is 70.1 mm with M14x1.5 bolts. Sources: https://www.lamborghini.com/original/DAM/lamborghini/facelift_2019/model_detail/revuelto/2024/brochure/06_24/REVUELTO_DIGITAL_BROCHURE_EN_2024.pdf ; https://premiumwheels.de/en/20-21-Sommerraeder-original-Lamborghini-Revuelto-47B601017-So/171743113 ; https://www.ebay.com/itm/336381039802');

delete from public.fitment_factory_baselines existing
where existing.make = 'Lamborghini'
  and (
    (existing.model = 'LP700'
      and existing.trim in ('Aventador LP700-4','Aventador SVJ'))
    or (existing.model = 'Murciélago LP640' and existing.trim = 'Base')
    or (existing.model = 'Revuelto' and existing.trim = 'Base')
  );

insert into public.fitment_factory_baselines (
  make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
)
select make,model,trim,year_start,year_end,package_name,market,is_default,
  front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from lamborghini_v12_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
  bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make = 'Lamborghini' and active
order by model,trim,year_start desc;
