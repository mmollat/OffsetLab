-- Offset Lab Fitment
-- Pack 044: verified Ford Focus RS and Mustang factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set year_start = case model when 'MK3' then 2016 when 'S550' then 2015 when 'S650' then 2024 end,
    year_end = case model when 'MK3' then 2018 when 'S550' then 2023 when 'S650' then 2026 end
where make = 'Ford' and model in ('MK3','S550','S650');

update public.fitment_presets
set factory_front='19x8 ET50', factory_rear='19x8 ET50',
    factory_tire='235/35R19 front / 235/35R19 rear',
    bolt_pattern='5x108', center_bore='63.4mm'
where make='Ford' and model='MK3' and trim='Focus RS' and active is not false;

update public.fitment_presets
set factory_front='17x7.5 ET37.5', factory_rear='17x7.5 ET37.5',
    factory_tire='235/55R17 front / 235/55R17 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S550' and trim='EcoBoost' and active is not false;

update public.fitment_presets
set factory_front='18x8 ET40', factory_rear='18x8 ET40',
    factory_tire='235/50R18 front / 235/50R18 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S550' and trim='GT' and active is not false;

update public.fitment_presets
set factory_front='19x10.5 ET30', factory_rear='19x11 ET62',
    factory_tire='295/35R19 front / 305/35R19 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S550' and trim='GT350' and active is not false;

update public.fitment_presets
set factory_front='17x7.5 ET37.5', factory_rear='17x7.5 ET37.5',
    factory_tire='235/55R17 front / 235/55R17 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S650' and trim='EcoBoost' and active is not false;

update public.fitment_presets
set factory_front='18x8.5 ET42.5', factory_rear='18x8.5 ET42.5',
    factory_tire='255/45R18 front / 255/45R18 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S650' and trim='GT' and active is not false;

update public.fitment_presets
set factory_front='19x9.5 ET40', factory_rear='19x10 ET52.5',
    factory_tire='255/40R19 front / 275/40R19 rear',
    bolt_pattern='5x114.3', center_bore='70.5mm'
where make='Ford' and model='S650' and trim='Dark Horse' and active is not false;

-- OEM+ keeps production tire sizing and moves the wheels outward about 6 mm.
update public.fitment_presets set front='19x8 +44',rear='19x8 +44',front_tire='235/35R19',rear_tire='235/35R19'
where make='Ford' and model='MK3' and trim='Focus RS' and style='oemplus' and active is not false;
update public.fitment_presets set front='17x7.5 +32',rear='17x7.5 +32',front_tire='235/55R17',rear_tire='235/55R17'
where make='Ford' and model='S550' and trim='EcoBoost' and style='oemplus' and active is not false;
update public.fitment_presets set front='18x8 +34',rear='18x8 +34',front_tire='235/50R18',rear_tire='235/50R18'
where make='Ford' and model='S550' and trim='GT' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x10.5 +24',rear='19x11 +56',front_tire='295/35R19',rear_tire='305/35R19'
where make='Ford' and model='S550' and trim='GT350' and style='oemplus' and active is not false;
update public.fitment_presets set front='17x7.5 +32',rear='17x7.5 +32',front_tire='235/55R17',rear_tire='235/55R17'
where make='Ford' and model='S650' and trim='EcoBoost' and style='oemplus' and active is not false;
update public.fitment_presets set front='18x8.5 +37',rear='18x8.5 +37',front_tire='255/45R18',rear_tire='255/45R18'
where make='Ford' and model='S650' and trim='GT' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x9.5 +34',rear='19x10 +47',front_tire='255/40R19',rear_tire='275/40R19'
where make='Ford' and model='S650' and trim='Dark Horse' and style='oemplus' and active is not false;

create temp table if not exists ford_performance_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,bolt_pattern text,
 center_bore text,source_status text,source_note text
) on commit drop;
truncate table ford_performance_verified_baselines;

insert into ford_performance_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
values
 ('Ford','MK3','Focus RS',2016,2018,'19-inch RS production package','US',true,'19x8 ET50','19x8 ET50','235/35R19 front / 235/35R19 rear','5x108','63.4mm','verified',
  'The Ford Focus RS owner supplement explicitly specifies the original-equipment 19x8 ET50 aluminum wheel. Ford technical and accessory documentation specifies 235/35R19 tires; hardware is 5x108, 63.4 mm with M12x1.5 lug nuts. Sources: https://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/2016_Focus_RS_ST.pdf ; https://shop.ford.co.uk/products/alloy-wheel-19-5-x-2-spoke-design-black'),
 ('Ford','S550','EcoBoost',2015,2023,'17-inch EcoBoost base production package','US',true,'17x7.5 ET37.5','17x7.5 ET37.5','235/55R17 front / 235/55R17 rear','5x114.3','70.5mm','verified',
  'Ford US Mustang technical specifications identify the standard EcoBoost 17x7.5 wheel with 235/55R17 all-season tires. Genuine Ford S550 base wheels establish ET37.5; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/2015_Specs/2015_Mustang_Specs.pdf'),
 ('Ford','S550','GT',2015,2023,'18-inch GT base production package','US',true,'18x8 ET40','18x8 ET40','235/50R18 front / 235/50R18 rear','5x114.3','70.5mm','verified',
  'Ford US Mustang technical specifications identify the standard GT 18x8 wheel with 235/50R18 all-season tires. Genuine Ford S550 18-inch production wheels are marked ET40; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/2015_Specs/2015_Mustang_Specs.pdf'),
 ('Ford','S550','GT350',2016,2020,'19-inch GT350 production package','US',true,'19x10.5 ET30','19x11 ET62','295/35R19 front / 305/35R19 rear','5x114.3','70.5mm','verified',
  'Ford Shelby GT350 technical specifications identify 19x10.5 front and 19x11 rear aluminum wheels with 295/35ZR19 and 305/35ZR19 Michelin Pilot Super Sport tires. Genuine Ford GT350 wheels are marked ET30 front and ET62 rear; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/2015/08/24/gt350-gt350r-tech-specs.pdf'),
 ('Ford','S650','EcoBoost',2024,2026,'17-inch EcoBoost base production package','US',true,'17x7.5 ET37.5','17x7.5 ET37.5','235/55R17 front / 235/55R17 rear','5x114.3','70.5mm','verified',
  'Ford 2024 Mustang technical specifications identify the standard EcoBoost 17x7.5 wheel with 235/55R17 tires. Genuine Ford S650 base wheel catalog data establishes ET37.5; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/2022/09/14/2024-mustang-technical-specifications.pdf'),
 ('Ford','S650','GT',2024,2026,'18-inch GT base production package','US',true,'18x8.5 ET42.5','18x8.5 ET42.5','255/45R18 front / 255/45R18 rear','5x114.3','70.5mm','verified',
  'Ford 2024 Mustang technical specifications identify the standard GT 18x8.5 wheel with 255/45R18 tires. Genuine Ford PR3Z-1007-B production wheels are marked ET42.5; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Source: https://media.ford.com/content/dam/fordmedia/North%20America/US/2022/09/14/2024-mustang-technical-specifications.pdf'),
 ('Ford','S650','Dark Horse',2024,2026,'19-inch Dark Horse base production package','US',true,'19x9.5 ET40','19x10 ET52.5','255/40R19 front / 275/40R19 rear','5x114.3','70.5mm','verified',
  'Ford technical specifications and the Mustang owner manual identify the standard Dark Horse 19x9.5 front and 19x10 rear package with 255/40R19 and 275/40R19 tires. Ford Performance kit M-1007K-DHB explicitly documents ET40 front and ET52.5 rear; hardware is 5x114.3, 70.5 mm with M14x1.5 lug nuts. Sources: https://media.ford.com/content/dam/fordmedia/North%20America/US/2022/09/14/2024-mustang-technical-specifications.pdf ; https://performanceparts.ford.com/part/M-1007K-DHB');

delete from public.fitment_factory_baselines existing
where existing.make='Ford' and existing.model in ('MK3','S550','S650');
insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from ford_performance_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines where make='Ford' and model in ('MK3','S550','S650') and active
order by model,trim;
