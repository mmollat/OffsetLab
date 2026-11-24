-- Offset Lab Fitment
-- Pack 100: verified BMW G20 3 Series, G22 4 Series, and G29 Z4 baselines.
-- Uses BMW North America specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G20 3 Series',year_start=2019,year_end=2026
where make='BMW' and model='G20';

update public.vehicle_models
set display_name='G22 4 Series Coupe',year_start=2021,year_end=2026
where make='BMW' and model='G22';

update public.vehicle_models
set display_name='G29 Z4',year_start=2019,year_end=2025
where make='BMW' and model='G29';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET25',factory_rear='18x7.5 ET25',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='BMW' and model='G20' and trim='330i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET25',factory_rear='18x8.5 ET40',
    factory_tire='225/45R18 front / 255/40R18 rear'
where make='BMW' and model='G20' and trim='M340i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET25',factory_rear='18x7.5 ET25',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='BMW' and model='G22' and trim='M440i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9 ET32',factory_rear='19x10 ET40',
    factory_tire='255/35R19 front / 275/35R19 rear'
where make='BMW' and model='G29' and trim='Z4 M40i' and active is not false;

-- OEM+ is deliberately one conservative step beyond factory.
update public.fitment_presets
set front='18x8 ET20',rear='18x8 ET20',
    front_tire='225/45R18',rear_tire='225/45R18'
where make='BMW' and model='G20' and trim='330i'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='18x7.5 ET20',rear='18x8.5 ET35',
    front_tire='225/45R18',rear_tire='255/40R18'
where make='BMW' and model='G20' and trim='M340i'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x8 ET22',rear='19x8.5 ET35',
    front_tire='225/40R19',rear_tire='255/35R19'
where make='BMW' and model='G22' and trim='M440i'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9 ET27',rear='19x10 ET35',
    front_tire='255/35R19',rear_tire='275/35R19'
where make='BMW' and model='G29' and trim='Z4 M40i'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g20_g22_g29_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g20_g22_g29_verified_baselines;

insert into bmw_g20_g22_g29_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G20','330i',2019,2026,'Standard 780 18-inch all-season package','United States',true,
 '18x7.5 ET25','18x7.5 ET25','225/45R18 front / 225/45R18 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the G20 330i standard all-season package as 18x7.5 front and rear with 225/45R18 tires. The BMW OEM parts catalog identifies the 780 wheel as 7.5Jx18 ET25 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0285572EN_US/the-all-new-2019-bmw-3-series ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2545&id=5R11-EUR---G20-BMW-330i'),
('BMW','G20','M340i',2020,2026,'Standard 790M 18-inch performance package','United States',true,
 '18x7.5 ET25','18x8.5 ET40','225/45R18 front / 255/40R18 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the rear-wheel-drive G20 M340i standard performance package as 18x7.5 front and 18x8.5 rear with 225/45R18 and 255/40R18 tires. The BMW OEM parts catalog identifies the 790M wheels as 7.5Jx18 ET25 front and 8.5Jx18 ET40 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0286917EN_US/the-all-new-2020-bmw-m340i-and-m340i-xdrive-sedans ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2548&id=5U79-USA-06-2022-G20-BMW-M340i'),
('BMW','G22','M440i',2021,2026,'Standard 848M 18-inch all-season package','United States',true,
 '18x7.5 ET25','18x7.5 ET25','225/45R18 front / 225/45R18 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the G22 M440i xDrive Coupe standard package as 18x7.5 front and rear with 225/45R18 tires. The BMW OEM parts catalog identifies the square 848M wheel as 7.5Jx18 ET25 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0309161EN_US/the-new-2021-bmw-4-series-coupe ; https://www.realoem.com/bmw/enUS/options?code=S1HXA&series=G22N'),
('BMW','G29','Z4 M40i',2019,2022,'Standard 800M 19-inch package','United States',true,
 '19x9 ET32','19x10 ET40','255/35R19 front / 275/35R19 rear','5x112','66.6mm','verified',
 'BMW North America wheel documentation identifies the G29 Z4 M40i standard 800M package as 19x9 front and 19x10 rear with 255/35R19 and 275/35R19 tires. The BMW OEM parts catalog identifies the 800M wheels as 9Jx19 ET32 front and 10Jx19 ET40 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0295052EN/443525 ; https://www.realoem.com/bmw/en/showparts?diagId=36_2535&id=HF51-EUR-10_2017_G29-BMW-Z4_M40i');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g20_g22_g29_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g20_g22_g29_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('G20','G22','G29') and active
order by model,trim,is_default desc,year_start;
