-- Offset Lab Fitment
-- Pack 059: verified Nissan Z34 370Z factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2009,year_end=2020
where make='Nissan' and model='Z34';

update public.fitment_presets
set factory_front='18x8 ET43',factory_rear='18x9 ET15',
    factory_tire='225/50R18 front / 245/45R18 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='Z34' and trim='Base' and active is not false;

update public.fitment_presets
set factory_front='19x9 ET47',factory_rear='19x10 ET30',
    factory_tire='245/40R19 front / 275/35R19 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='Z34' and trim in ('Sport','370Z Sport')
  and active is not false;

update public.fitment_presets
set factory_front='19x9.5 ET40',factory_rear='19x10.5 ET23',
    factory_tire='245/40R19 front / 285/35R19 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='Z34' and trim in ('Nismo','NISMO')
  and active is not false;

create temp table if not exists nissan_z34_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_z34_verified_baselines;

insert into nissan_z34_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','Z34','Base',2009,2020,'370Z Base 18-inch production package','US',true,
 '18x8 ET43','18x9 ET15','225/50R18 front / 245/45R18 rear',
 '5x114.3','66.1mm','verified',
 'The official 2020 Nissan 370Z owner manual specifies 18x8J ET43 front and 18x9J ET15 rear wheels. Nissan''s 2020 brochure and press kit assign 225/50R18 and 245/45R18 tires to the base 370Z package. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2020/2020-ZCoupe-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2020/2020-nissan-370z-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/us-2020-nissan-370z-coupe-press-kit'),
('Nissan','Z34','370Z Sport',2009,2020,'370Z Sport 19-inch RAYS production package','US',true,
 '19x9 ET47','19x10 ET30','245/40R19 front / 275/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2020 Nissan 370Z owner manual specifies 19x9J ET47 front and 19x10J ET30 rear wheels. Nissan''s brochure and press kit assign the RAYS package with 245/40R19 and 275/35R19 tires to Sport. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2020/2020-ZCoupe-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2020/2020-nissan-370z-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/us-2020-nissan-370z-coupe-press-kit'),
('Nissan','Z34','Sport',2009,2020,'370Z Sport 19-inch RAYS production package','US',true,
 '19x9 ET47','19x10 ET30','245/40R19 front / 275/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2020 Nissan 370Z owner manual specifies 19x9J ET47 front and 19x10J ET30 rear wheels. Nissan''s brochure and press kit assign the RAYS package with 245/40R19 and 275/35R19 tires to Sport. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2020/2020-ZCoupe-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2020/2020-nissan-370z-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/us-2020-nissan-370z-coupe-press-kit'),
('Nissan','Z34','Nismo',2009,2020,'370Z NISMO 19-inch RAYS production package','US',true,
 '19x9.5 ET40','19x10.5 ET23','245/40R19 front / 285/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2020 Nissan 370Z owner manual specifies NISMO wheels at 19x9.5J ET40 front and 19x10.5J ET23 rear. Nissan''s brochure and press kit confirm 245/40R19 and 285/35R19 tires. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2020/2020-ZCoupe-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2020/2020-nissan-370z-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/us-2020-nissan-370z-coupe-press-kit'),
('Nissan','Z34','NISMO',2009,2020,'370Z NISMO 19-inch RAYS production package','US',true,
 '19x9.5 ET40','19x10.5 ET23','245/40R19 front / 285/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2020 Nissan 370Z owner manual specifies NISMO wheels at 19x9.5J ET40 front and 19x10.5J ET23 rear. Nissan''s brochure and press kit confirm 245/40R19 and 285/35R19 tires. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2020/2020-ZCoupe-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2020/2020-nissan-370z-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/us-2020-nissan-370z-coupe-press-kit');

delete from public.fitment_factory_baselines
where make='Nissan' and model='Z34';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_z34_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='Z34' and active
order by trim;
