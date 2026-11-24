-- Offset Lab Fitment
-- Pack 097: verified BMW G05 X5 xDrive40i, M50i, and M60i baselines.
-- Uses BMW North America specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G05 X5',year_start=2019,year_end=2026
where make='BMW' and model='G05';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9 ET35',factory_rear='20x9 ET35',
    factory_tire='275/45R20 front / 275/45R20 rear'
where make='BMW' and model='G05'
  and trim in ('X5 xDrive40i','X5 M50i / M60i') and active is not false;

-- OEM+ previously duplicated the later default package for both active trims.
update public.fitment_presets
set front='20x9 ET30',rear='20x9 ET30',
    front_tire='275/45R20',rear_tire='275/45R20'
where make='BMW' and model='G05'
  and trim in ('X5 xDrive40i','X5 M50i / M60i')
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g05_x5_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g05_x5_verified_baselines;

insert into bmw_g05_x5_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G05','X5 xDrive40i',2024,2026,'Standard 20-inch package','United States',true,
 '20x9 ET35','20x9 ET35','275/45R20 front / 275/45R20 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the 2024-onward G05 X5 xDrive40i standard package as 20x9 front and rear with 275/45R20 all-season run-flat tires. The BMW OEM parts catalog identifies the compatible 740M wheel as 9Jx20 ET35 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0408460EN_US/the-2024-bmw-x5-and-x6 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2523&id=JU41-EUR-03-2023-G05-BMW-X5_M50iX'),
('BMW','G05','X5 xDrive40i',2019,2023,'Standard 734 19-inch package','United States',false,
 '19x9 ET38','19x9 ET38','265/50R19 front / 265/50R19 rear','5x112','66.6mm','verified',
 'BMW USA launch specifications identify the earlier G05 X5 xDrive40i standard package as 19x9 front and rear with 265/50R19 tires. The BMW OEM parts catalog identifies the 734 wheel as 9Jx19 ET38 and lists M14x1.25 wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0281821EN_US/the-all-new-2019-bmw-x5-sports-activity-vehicle ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2517&id=13EU-USA---G05N-BMW-X5+40i'),
('BMW','G05','X5 M50i / M60i',2020,2026,'Standard 740M 20-inch package','United States',true,
 '20x9 ET35','20x9 ET35','275/45R20 front / 275/45R20 rear','5x112','66.6mm','verified',
 'BMW USA model-year documentation identifies the X5 M50i standard 740M package as 20-inch wheels, and BMW USA specifications identify the M60i standard package as 20x9 front and rear with 275/45R20 tires. The BMW OEM parts catalog identifies the 740M wheel as 9Jx20 ET35 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0299940EN_US/bmw-model-year-2020-update-information ; https://www.press.bmwgroup.com/usa/article/detail/T0408460EN_US/the-2024-bmw-x5-and-x6 ; https://www.press.bmwgroup.com/canada/article/attachment/T0304263EN/444937 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2523&id=JU41-EUR-03-2023-G05-BMW-X5_M50iX');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g05_x5_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g05_x5_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G05'
  and trim in ('X5 xDrive40i','X5 M50i / M60i') and active
order by trim,is_default desc,year_start;
