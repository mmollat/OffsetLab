-- Offset Lab Fitment
-- Pack 092: verified BMW G80 M3 and M3 Competition xDrive baselines.
-- Uses BMW launch specifications and BMW Genuine Parts wheel geometry.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G80 M3',year_start=2021,year_end=2024
where make='BMW' and model='G80';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x9.5 ET20',factory_rear='19x10.5 ET20',
    factory_tire='275/40R18 front / 285/35R19 rear'
where make='BMW' and model='G80' and trim='M3 (RWD)'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9.5 ET20',factory_rear='20x10.5 ET20',
    factory_tire='275/35R19 front / 285/30R20 rear'
where make='BMW' and model='G80' and trim='M3 Competition xDrive'
  and active is not false;

create temp table if not exists bmw_g80_m3_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g80_m3_verified_baselines;

insert into bmw_g80_m3_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G80','M3 (RWD)',2021,2024,'Base 18/19-inch factory setup','United States',true,
 '18x9.5 ET20','19x10.5 ET20','275/40R18 front / 285/35R19 rear','5x112','66.6mm','verified',
 'BMW USA launch documentation identifies the rear-wheel-drive G80 M3 standard package as 18x9.5 front and 19x10.5 rear with 275/40ZR18 and 285/35ZR19 tires. BMW Genuine Parts identifies the 824M wheels as 9.5Jx18 ET20 front (36 10 8 093 830) and 10.5Jx19 ET20 rear (36 10 8 093 831). Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0317577EN_US/the-new-2021-bmw-m3-sedan-and-m4-coupe ; https://shop.bmw.co.uk/product/genuine-18-disc-wheel-rim-light-alloy-orbit-grey-9-5jx18-et-20-36-10-8-093-830 ; https://shop.bmw.co.uk/product/genuine-19-disc-wheel-rim-light-alloy-orbit-grey-10-5jx19-et-20-36-10-8-093-831'),
('BMW','G80','M3 (RWD)',2021,2024,'Optional 19/20-inch factory setup','United States',false,
 '19x9.5 ET20','20x10.5 ET20','275/35R19 front / 285/30R20 rear','5x112','66.6mm','verified',
 'BMW USA launch documentation identifies the optional G80 M3 package as 19x9.5 front and 20x10.5 rear with 275/35ZR19 and 285/30ZR20 tires. BMW Genuine Parts identifies the compatible front and rear wheels as ET20. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0317577EN_US/the-new-2021-bmw-m3-sedan-and-m4-coupe ; https://shop.bmw.co.uk/product/genuine-19-disc-wheel-rim-light-alloy-jet-black-9-5jx19-et-20-36-10-8-093-836 ; https://shop.bmw.co.uk/product/genuine-20-disc-wheel-rim-light-alloy-jet-black-10-5jx20-et-20-36-10-8-093-837'),
('BMW','G80','M3 Competition xDrive',2022,2024,'Competition xDrive 19/20-inch factory setup','United States',true,
 '19x9.5 ET20','20x10.5 ET20','275/35R19 front / 285/30R20 rear','5x112','66.6mm','verified',
 'BMW USA launch documentation identifies the G80 M3 Competition xDrive standard package as 19x9.5 front and 20x10.5 rear with 275/35ZR19 and 285/30ZR20 tires. BMW Genuine Parts identifies the compatible 826M wheels as ET20 front and rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0330025EN_US/the-new-2022-bmw-m3-competition-xdrive-sedan-and-m4-competition-xdrive-coupe ; https://shop.bmw.co.uk/product/genuine-19-disc-wheel-rim-light-alloy-jet-black-9-5jx19-et-20-36-10-8-093-836 ; https://shop.bmw.co.uk/product/genuine-20-disc-wheel-rim-light-alloy-jet-black-10-5jx20-et-20-36-10-8-093-837');

update public.fitment_factory_baselines target
set year_start=source.year_start,
    year_end=source.year_end,
    market=source.market,
    is_default=source.is_default,
    front=source.front,
    rear=source.rear,
    tire=source.tire,
    bolt_pattern=source.bolt_pattern,
    center_bore=source.center_bore,
    source_status=source.source_status,
    source_note=source.source_note,
    active=true
from bmw_g80_m3_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g80_m3_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G80'
  and trim in ('M3 (RWD)','M3 Competition xDrive') and active
order by trim,is_default desc,year_start;
