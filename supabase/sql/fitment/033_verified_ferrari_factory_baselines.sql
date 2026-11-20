-- Offset Lab Fitment
-- Pack 033: verified US-market Ferrari factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Factory dimensions come from Ferrari owner manuals/technical sheets and
-- genuine Ferrari wheel catalog data or wheel markings for the offsets.

update public.vehicle_models
set year_start = case model
      when 'F142' then 2010
      when 'F142M' then 2016
      when 'F152M' then 2018
      when 'F173' then 2021
    end,
    year_end = case model
      when 'F142' then 2015
      when 'F142M' then 2023
      when 'F152M' then 2023
      when 'F173' then 2025
    end
where make = 'Ferrari' and model in ('F142', 'F142M', 'F152M', 'F173');

update public.fitment_presets
set factory_front = '20x8.5 ET46.5',
    factory_rear = '20x10.5 ET58.5',
    factory_tire = '235/35R20 front / 295/35R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Ferrari' and model = 'F142' and trim = '458 Italia'
  and active is not false;

update public.fitment_presets
set factory_front = '20x9 ET44.7',
    factory_rear = '20x11 ET48.4',
    factory_tire = '245/35R20 front / 305/30R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Ferrari' and model = 'F142' and trim = '458 Speciale'
  and active is not false;

update public.fitment_presets
set factory_front = '20x9 ET44.7',
    factory_rear = '20x11 ET38.5',
    factory_tire = '245/35R20 front / 305/30R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Ferrari' and model = 'F142M'
  and trim in ('488 GTB', 'F8 Tributo') and active is not false;

update public.fitment_presets
set factory_front = '20x10 ET48.4',
    factory_rear = '20x11.5 ET57.3',
    factory_tire = '275/35R20 front / 315/35R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Ferrari' and model = 'F152M' and trim = '812 Superfast'
  and active is not false;

update public.fitment_presets
set factory_front = '20x9.5 ET43.3',
    factory_rear = '20x11.5 ET35.9',
    factory_tire = '255/35R20 front / 315/30R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Ferrari' and model = 'F173' and trim = 'SF90 Stradale'
  and active is not false;

-- Keep OEM+ visibly and geometrically distinct from the verified factory set.
update public.fitment_presets
set front = '20x10 +43', rear = '20x11.5 +52',
    front_tire = '275/35R20', rear_tire = '315/35R20'
where make = 'Ferrari' and model = 'F152M' and trim = '812 Superfast'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x9.5 +38', rear = '20x11.5 +31',
    front_tire = '255/35R20', rear_tire = '315/30R20'
where make = 'Ferrari' and model = 'F173' and trim = 'SF90 Stradale'
  and style = 'oemplus' and active is not false;

create temp table if not exists ferrari_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table ferrari_verified_baselines;

insert into ferrari_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Ferrari', 'F142', '458 Italia', 2010, 2015,
   '20-inch standard factory package', 'US', true,
   '20x8.5 ET46.5', '20x10.5 ET58.5',
   '235/35R20 front / 295/35R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari 458 Italia Owner''s Manual specifies 20x8.5J ET46.5 front and 20x10.5J ET58.5 rear wheels with 235/35 ZR20 and 295/35 ZR20 approved tires. Genuine Ferrari wheel catalog/markings identify front parts 255225/262949/268641 and rear parts 255226/262950/268642. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Sources: https://di-uploads-development.dealerinspire.com/ferrarioffortlauderdale/uploads/2020/05/458italia.pdf ; https://www.ferrarifl.com/owners-manuals/ ; https://eurospares.co.uk/ferrari/458/458-italia-rhd/part-diagrams/0039/wheels'),
  ('Ferrari', 'F142', '458 Speciale', 2014, 2015,
   '20-inch Speciale factory package', 'US', true,
   '20x9 ET44.7', '20x11 ET48.4',
   '245/35R20 front / 305/30R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari 458 Speciale Owner''s Manual explicitly specifies 20x9J ET44.7 front and 20x11J ET48.4 rear wheels and Ferrari-approved 245/35 ZR20 front and 305/30 ZR20 rear tires. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Source: https://di-uploads-development.s3.us-east-1.amazonaws.com/ferrarioffortlauderdale/uploads/2020/05/458speciale.pdf'),
  ('Ferrari', 'F142M', '488 GTB', 2016, 2019,
   '20-inch standard factory package', 'US', true,
   '20x9 ET44.7', '20x11 ET38.5',
   '245/35R20 front / 305/30R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari 488 GTB Owner''s Manual explicitly specifies 20x9J ET44.7 front and 20x11J ET38.5 rear wheels with Ferrari-approved 245/35 ZR20 and 305/30 ZR20 tires. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Sources: https://di-uploads-development.dealerinspire.com/ferrarioffortlauderdale/uploads/2020/05/488gtb.pdf ; https://www.ferrarifl.com/owners-manuals/'),
  ('Ferrari', 'F142M', 'F8 Tributo', 2020, 2023,
   '20-inch standard factory package', 'US', true,
   '20x9 ET44.7', '20x11 ET38.5',
   '245/35R20 front / 305/30R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari''s F8 technical specification gives 20x9 front and 20x11 rear wheels with 245/35 ZR20 and 305/30 ZR20 tires. Genuine Ferrari F8 wheel catalog parts 342906/866267 front and 342907 rear, together with OEM wheel markings, specify ET44.7 front and ET38.5 rear. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Sources: https://cdn.ferrari.com/cms/network/media/pdf/pr_ferrari_f8_spider_gbr.pdf ; https://awitalian.com/diagrams/ferrari/f8-tributo/0083-mechanical-system-d-29-complete-wheels/ ; https://supercars.parts/parts/ferrari-f8-tributo-front-wheel-gray-p-n-861252/p8997/'),
  ('Ferrari', 'F152M', '812 Superfast', 2018, 2023,
   '20-inch standard factory package', 'US', true,
   '20x10 ET48.4', '20x11.5 ET57.3',
   '275/35R20 front / 315/35R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari 812 Superfast Owner''s Manual explicitly specifies 20x10J ET48.4 front and 20x11.5J ET57.3 rear wheels with Ferrari-approved 275/35 ZR20 and 315/35 ZR20 tires. Genuine Ferrari wheels are cataloged as parts 324158 front and 324159 rear. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Sources: https://techinfo-test.ferrari.com/documentcatalogues/last ; https://www.scribd.com/document/654697164/812-Superfast-1 ; https://premiumwheels.de/20-Zoll-Original-Ferrari-812-Superfast-Felgen-Styling-324-324158-324159/171739743'),
  ('Ferrari', 'F173', 'SF90 Stradale', 2021, 2025,
   '20-inch standard factory package', 'US', true,
   '20x9.5 ET43.3', '20x11.5 ET35.9',
   '255/35R20 front / 315/30R20 rear', '5x114.3', '67.1mm', 'verified',
   'Ferrari''s SF90 technical specification gives 20x9.5 front and 20x11.5 rear wheels with 255/35 ZR20 and 315/30 ZR20 tires. Genuine Ferrari wheel markings and catalog parts, including 764245 front and 764246/848643 rear, specify ET43.3 front and ET35.9 rear. Hardware is 5x114.3, 67.1 mm center bore, M14x1.5 wheel bolts. Sources: https://cdn.ferrari.com/cms/network/media/pdf/pr_ferrari_sf90_stradale_gbr.pdf ; https://www.eurospares.co.uk/parts/70005285/ferrari?pi=246009 ; https://www.dynotec-parts.com/en/home/2848-original-oem-ferrari-sf90-stradale-20-inch-wheels-set-of-4.html');

delete from public.fitment_factory_baselines existing
where existing.make = 'Ferrari'
  and existing.model in ('F142', 'F142M', 'F152M', 'F173')
  and existing.trim in (
    '458 Italia', '458 Speciale', '488 GTB', 'F8 Tributo',
    '812 Superfast', 'SF90 Stradale'
  );

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from ferrari_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Ferrari' and active
order by model, trim, is_default desc, year_start desc;
