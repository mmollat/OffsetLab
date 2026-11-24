-- Offset Lab Fitment
-- Pack 099: verified BMW G15/F92 Coupe and G16/F93 Gran Coupe baselines.
-- Uses BMW North America specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G15/F92 8 Series Coupe',year_start=2019,year_end=2025
where make='BMW' and model='G15';

update public.vehicle_models
set display_name='G16/F93 8 Series Gran Coupe',year_start=2020,year_end=2025
where make='BMW' and model='G16';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x8 ET26',factory_rear='20x9 ET41',
    factory_tire='245/35R20 front / 275/30R20 rear'
where make='BMW' and model in ('G15','G16')
  and trim in ('M850i Coupe','M850i Gran Coupe') and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET28',factory_rear='20x10.5 ET28',
    factory_tire='275/35R20 front / 285/35R20 rear'
where make='BMW' and model in ('G15','G16')
  and trim in ('M8 Coupe','M8 Competition Coupe','M8 Gran Coupe','M8 Competition Gran Coupe')
  and active is not false;

-- OEM+ is a conservative step beyond factory, not a duplicate or a narrower
-- package: retain factory tires and move each wheel 5 mm outward.
update public.fitment_presets
set front='20x9.5 ET23',rear='20x10.5 ET23',
    front_tire='275/35R20',rear_tire='285/35R20'
where make='BMW' and model in ('G15','G16')
  and trim in ('M8 Coupe','M8 Competition Coupe','M8 Gran Coupe','M8 Competition Gran Coupe')
  and style='oemplus' and active is not false;

-- M850i OEM+ adds a half-inch of width and a mild outward position while
-- retaining the factory tire diameters.
update public.fitment_presets
set front='20x8.5 ET24',rear='20x9.5 ET39',
    front_tire='245/35R20',rear_tire='275/30R20'
where make='BMW' and model in ('G15','G16')
  and trim in ('M850i Coupe','M850i Gran Coupe')
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g15_g16_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g15_g16_verified_baselines;

insert into bmw_g15_g16_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G15','M850i Coupe',2019,2025,'Standard 728M 20-inch package','United States',true,
 '20x8 ET26','20x9 ET41','245/35R20 front / 275/30R20 rear','5x112','66.6mm','verified',
 'BMW North America documentation identifies the M850i xDrive Coupe standard 728M package as 20x8 front and 20x9 rear with 245/35R20 and 275/30R20 tires. The BMW OEM parts catalog identifies the wheels as 8Jx20 ET26 front and 9Jx20 ET41 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0295054EN/441833 ; https://www.press.bmwgroup.com/canada/article/attachment/T0304259EN/444871 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2493&id=FY21-EUR-10_2017_G14-BMW-840dX'),
('BMW','G16','M850i Gran Coupe',2020,2025,'Standard 728M 20-inch package','United States',true,
 '20x8 ET26','20x9 ET41','245/35R20 front / 275/30R20 rear','5x112','66.6mm','verified',
 'BMW USA documentation identifies the M850i xDrive Gran Coupe standard 728M package as 20x8 front and 20x9 rear with 245/35R20 and 275/30R20 tires. The BMW OEM parts catalog identifies the wheels as 8Jx20 ET26 front and 9Jx20 ET41 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0297281EN_US/the-new-bmw-8-series-gran-coupe ; https://www.press.bmwgroup.com/canada/article/attachment/T0295054EN/441833 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2493&id=FY21-EUR-10_2017_G14-BMW-840dX'),
('BMW','G15','M8 Coupe',2020,2025,'Standard 810M 20-inch package','United States',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW North America documentation identifies the M8 Coupe standard 810M package as 20x9.5 front and 20x10.5 rear with 275/35R20 and 285/35R20 tires. The BMW OEM parts catalog identifies the wheels as 9.5Jx20 ET28 front and 10.5Jx20 ET28 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0295053EN/441811 ; https://www.press.bmwgroup.com/canada/article/detail/T0296840EN/the-new-2020-bmw-m8-coup%C3%A9-and-m8-cabriolet ; https://www.realoem.com/bmw/de/showparts?diagId=36_2635&id=GV02-EUR-10_2018_F93-BMW-M8'),
('BMW','G15','M8 Competition Coupe',2020,2025,'Standard 813M 20-inch package','United States',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW North America documentation identifies the M8 Competition Coupe standard 813M package as 20x9.5 front and 20x10.5 rear with 275/35R20 and 285/35R20 tires. The BMW OEM parts catalog identifies the 813M wheels as 9.5Jx20 ET28 front and 10.5Jx20 ET28 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0295053EN/441811 ; https://www.press.bmwgroup.com/global/article/attachment/T0364657EN/519059 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2638&id=GV02-EUR-02-2025-F93-BMW-M8'),
('BMW','G16','M8 Gran Coupe',2020,2025,'Standard 810M 20-inch package','United States',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW USA documentation identifies the M8 Gran Coupe standard package as 20x9.5 front and 20x10.5 rear with 275/35R20 and 285/35R20 tires; BMW Canada identifies the base-model wheel as 810M. The BMW OEM parts catalog identifies the 810M wheels as 9.5Jx20 ET28 front and 10.5Jx20 ET28 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0301607EN_US/the-new-2020-bmw-m8-gran-coupe-and-m8-gran-coupe-competition ; https://www.press.bmwgroup.com/canada/article/attachment/T0304262EN/444929 ; https://www.realoem.com/bmw/de/showparts?diagId=36_2635&id=GV02-EUR-10_2018_F93-BMW-M8'),
('BMW','G16','M8 Competition Gran Coupe',2020,2025,'Standard 813M 20-inch package','United States',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW USA documentation identifies the M8 Competition Gran Coupe standard package as 20x9.5 front and 20x10.5 rear with 275/35R20 and 285/35R20 tires; BMW Canada identifies the Competition wheel as 813M. The BMW OEM parts catalog identifies the 813M wheels as 9.5Jx20 ET28 front and 10.5Jx20 ET28 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0301607EN_US/the-new-2020-bmw-m8-gran-coupe-and-m8-gran-coupe-competition ; https://www.press.bmwgroup.com/canada/article/attachment/T0304262EN/444929 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2638&id=GV02-EUR-02-2025-F93-BMW-M8');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g15_g16_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g15_g16_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('G15','G16') and active
order by model,trim,is_default desc,year_start;
