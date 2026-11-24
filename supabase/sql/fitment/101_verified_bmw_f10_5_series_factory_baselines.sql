-- Offset Lab Fitment
-- Pack 101: verified BMW F10 535i, 550i, and M5 baselines.
-- Uses BMW North America specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F10 5 Series',year_start=2011,year_end=2016
where make='BMW' and model='F10';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET30',factory_rear='18x8 ET30',
    factory_tire='245/45R18 front / 245/45R18 rear'
where make='BMW' and model='F10' and trim in ('535i','550i')
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x9 ET32',factory_rear='19x10 ET34',
    factory_tire='265/40R19 front / 295/35R19 rear'
where make='BMW' and model='F10' and trim='M5' and active is not false;

-- Keep OEM+ conservative and clearly beyond the factory baseline.
update public.fitment_presets
set front='18x8.5 ET25',rear='18x8.5 ET25',
    front_tire='245/45R18',rear_tire='245/45R18'
where make='BMW' and model='F10' and trim in ('535i','550i')
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9 ET27',rear='19x10 ET29',
    front_tire='265/40R19',rear_tire='295/35R19'
where make='BMW' and model='F10' and trim='M5'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f10_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f10_verified_baselines;

insert into bmw_f10_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F10','535i',2011,2016,'Standard 237/328 18-inch all-season package','United States',true,
 '18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x120','72.6mm','verified',
 'BMW USA launch specifications identify the F10 535i standard package as 18x8 front and rear with 245/45R18 run-flat all-season tires. BMW model-year documentation identifies style 328 as the later standard wheel, and the BMW OEM parts catalog identifies it as 8Jx18 ET30 with M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0077108EN_US/the-new-6th-generation-bmw-5-series-sedan-u-s-version-%3A-the-perfect-symbiosis-of-modern-design-and-dynamic-performance ; https://www.press.bmwgroup.com/usa/article/detail/T0222782EN_US/model-year-2016-update-information ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1459&id=5B33-USA---F10N-BMW-535iX'),
('BMW','F10','550i',2011,2016,'Standard 281/328/609 18-inch all-season package','United States',true,
 '18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x120','72.6mm','verified',
 'BMW USA launch specifications identify the F10 550i standard package as 18x8 front and rear with 245/45R18 run-flat all-season tires. BMW model-year documentation identifies the later standard-wheel changes, while the BMW OEM parts catalog identifies the compatible standard wheels as 8Jx18 ET30 with M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0077108EN_US/the-new-6th-generation-bmw-5-series-sedan-u-s-version-%3A-the-perfect-symbiosis-of-modern-design-and-dynamic-performance ; https://www.press.bmwgroup.com/usa/article/detail/T0222782EN_US/model-year-2016-update-information ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1471&id=FR93-USA-01_2009_F10-BMW-550i'),
('BMW','F10','M5',2013,2016,'Standard 345M 19-inch package','United States',true,
 '19x9 ET32','19x10 ET34','265/40R19 front / 295/35R19 rear','5x120','72.6mm','verified',
 'BMW USA pricing documentation identifies the F10 M5 standard 345M package as 19x9 front and 19x10 rear with 265/40R19 and 295/35R19 tires. The BMW OEM parts catalog identifies the 345M wheels as 9Jx19 ET32 front and 10Jx19 ET34 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0141998EN_US/361018 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1644&id=FV92-EUR-06_2010_F10-BMW-M5');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_f10_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_f10_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F10' and active
order by trim,is_default desc,year_start;
