-- Offset Lab Fitment
-- Pack 106: verified BMW G30 540i and M550i factory baselines.
-- Uses BMW North America technical/pricing documentation and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set display_name='G30 5 Series Sedan',year_start=2017,year_end=2023
where make='BMW' and model='G30';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET30',factory_rear='18x8 ET30',
    factory_tire='245/45R18 front / 245/45R18 rear'
where make='BMW' and model='G30' and trim='540i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8 ET30',factory_rear='19x9 ET44',
    factory_tire='245/40R19 front / 275/35R19 rear'
where make='BMW' and model='G30' and trim='M550i' and active is not false;

create temp table if not exists bmw_g30_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g30_verified_baselines;

insert into bmw_g30_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G30','540i',2017,2023,'Standard 634 18-inch all-season package','United States',true,'18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x112','66.6mm','verified','BMW North America identifies the G30 540i standard style 634 package as 18x8 front and rear with 245/45R18 all-season run-flat tires. BMW technical data specifies ET30 front and rear. The OEM hardware uses M14x1.25 wheel bolts, a 5x112 bolt pattern, 66.6 mm center bore, and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0266788EN_US/391871 ; https://www.press.bmwgroup.com/usa/article/detail/T0264802EN_US/the-all-new-2017-bmw-5-series%3A-performance-redefined'),
('BMW','G30','M550i',2018,2023,'Standard 664M 19-inch performance package','United States',true,'19x8 ET30','19x9 ET44','245/40R19 front / 275/35R19 rear','5x112','66.6mm','verified','BMW North America identifies the G30 M550i standard package as 19x8 front and 19x9 rear with 245/40R19 and 275/35R19 tires. The BMW OEM parts catalog identifies style 664M as 8Jx19 ET30 front and 9Jx19 ET44 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0308911EN_US/the-new-2021-bmw-5-series-sedan ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2369&id=JD71-EUR-06-2020-G30-BMW-M550dX');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g30_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_g30_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G30' and active
order by trim,is_default desc,year_start;
