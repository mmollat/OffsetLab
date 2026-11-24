-- Offset Lab Fitment
-- Pack 096: verified BMW G01 X3 xDrive30i and X3 M40i baselines.
-- Uses BMW North America product guides and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G01 X3',year_start=2018,year_end=2024
where make='BMW' and model='G01';

-- Display the later-generation North American standard package for each active trim.
update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x7.5 ET32',factory_rear='19x7.5 ET32',
    factory_tire='245/50R19 front / 245/50R19 rear'
where make='BMW' and model='G01' and trim='X3 xDrive30i'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x8 ET27',factory_rear='20x9.5 ET43',
    factory_tire='245/45R20 front / 275/40R20 rear'
where make='BMW' and model='G01' and trim='X3 M40i'
  and active is not false;

-- Preserve M40i OEM+ as a mild 5 mm outward step from its later factory package.
update public.fitment_presets
set front='20x8 ET22',rear='20x9.5 ET38',
    front_tire='245/45R20',rear_tire='275/40R20'
where make='BMW' and model='G01' and trim='X3 M40i'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g01_x3_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g01_x3_verified_baselines;

insert into bmw_g01_x3_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G01','X3 xDrive30i',2020,2024,'Standard 693 19-inch package','United States/Canada',true,
 '19x7.5 ET32','19x7.5 ET32','245/50R19 front / 245/50R19 rear','5x112','66.6mm','verified',
 'BMW North America documentation identifies the later G01 X3 xDrive30i standard 693 package as 19x7.5 front and rear with 245/50R19 tires. The BMW OEM parts catalog identifies the 693 wheel as 7.5Jx19 ET32 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0334902EN_US/the-new-bmw-x3-and-the-new-bmw-x4 ; https://www.press.bmwgroup.com/canada/article/attachment/T0346013EN/494853 ; https://www.realoem.com/bmw/de/showparts?diagId=36_2497&id=51DP-EUR---G01N-BMW-X3+30iX'),
('BMW','G01','X3 xDrive30i',2018,2019,'Standard 688 18-inch package','United States',false,
 '18x7 ET22','18x7 ET22','225/60R18 front / 225/60R18 rear','5x112','66.6mm','verified',
 'BMW North America launch and pricing documentation identifies the early G01 X3 xDrive30i standard 688 package as 18x7 front and rear with 225/60R18 tires. The BMW OEM parts catalog identifies the 688 wheel as 7Jx18 ET22 and lists M14x1.25 wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0272041EN_US/the-all-new-2018-bmw-x3 ; https://www.press.bmwgroup.com/usa/article/attachment/T0272041EN_US/403418 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2444&id=TY16-EUR---G01-BMW-X3+20iX'),
('BMW','G01','X3 M40i',2022,2024,'Standard 699M 20-inch package','United States/Canada',true,
 '20x8 ET27','20x9.5 ET43','245/45R20 front / 275/40R20 rear','5x112','66.6mm','verified',
 'BMW North America documentation identifies the later G01 X3 M40i standard 699M package as 20x8 front and 20x9.5 rear with 245/45R20 and 275/40R20 tires. The BMW OEM parts catalog identifies ET27 front, ET43 rear, and M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0334902EN_US/the-new-bmw-x3-and-the-new-bmw-x4 ; https://www.press.bmwgroup.com/canada/article/attachment/T0346013EN/494853 ; https://www.realoem.com/bmw/de/showparts?diagId=36_2437&id=51DP-EUR---G01N-BMW-X3+30iX'),
('BMW','G01','X3 M40i',2018,2021,'Standard 698M 19-inch package','United States',false,
 '19x7.5 ET32','19x7.5 ET32','245/50R19 front / 245/50R19 rear','5x112','66.6mm','verified',
 'BMW North America launch documentation identifies a 19-inch square package as the early G01 X3 M40i standard fitment, with 245/50R19 tires. BMW product documentation identifies the 698M package as 19x7.5 front and rear, and the BMW OEM parts catalog establishes ET32 and M14x1.25 wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0272041EN_US/the-all-new-2018-bmw-x3 ; https://www.press.bmwgroup.com/canada/article/attachment/T0276858EN/399080 ; https://www.realoem.com/bmw/it/showparts?diagId=36_2435&id=TR12-EUR-07_2017_G01_BMW_X3_20i');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g01_x3_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g01_x3_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G01'
  and trim in ('X3 xDrive30i','X3 M40i') and active
order by trim,is_default desc,year_start;
