-- Offset Lab Fitment
-- Pack 098: verified BMW G11/G12 7 Series 740i, 750i, and M760i baselines.
-- Uses BMW North America specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G11/G12 7 Series',year_start=2016,year_end=2022
where make='BMW' and model='G11';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET30',factory_rear='18x8 ET30',
    factory_tire='245/50R18 front / 245/50R18 rear'
where make='BMW' and model='G11' and trim='740i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET25',factory_rear='19x8.5 ET25',
    factory_tire='245/45R19 front / 245/45R19 rear'
where make='BMW' and model='G11' and trim='750i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x8.5 ET25',factory_rear='20x10 ET41',
    factory_tire='245/40R20 front / 275/35R20 rear'
where make='BMW' and model='G11' and trim='M760i' and active is not false;

-- Keep OEM+ visibly distinct from the M760i factory package: same factory
-- widths and tires with a conservative 5 mm outward position per axle.
update public.fitment_presets
set front='20x8.5 ET20',rear='20x10 ET36',
    front_tire='245/40R20',rear_tire='275/35R20'
where make='BMW' and model='G11' and trim='M760i'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g11_7_series_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g11_7_series_verified_baselines;

insert into bmw_g11_7_series_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G11','740i',2016,2022,'Standard 642 18-inch package','United States',true,
 '18x8 ET30','18x8 ET30','245/50R18 front / 245/50R18 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the G11 740i standard package as 18x8 front and rear with 245/50R18 tires. The BMW OEM parts catalog identifies the 642 wheel as 8Jx18 ET30 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0290164EN_US/the-new-2020-bmw-7-series-sedan ; https://www.press.bmwgroup.com/usa/article/attachment/T0266022EN_US/403294 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2251&id=7S61-EUR-02_2018_G11N_BMW-740dX'),
('BMW','G11','750i',2016,2022,'Standard 630 19-inch package','United States',true,
 '19x8.5 ET25','19x8.5 ET25','245/45R19 front / 245/45R19 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the G11/G12 750i standard package as 19x8.5 front and rear with 245/45R19 tires. The BMW OEM parts catalog identifies the 630 wheel as 8.5Jx19 ET25 and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0290164EN_US/the-new-2020-bmw-7-series-sedan ; https://www.press.bmwgroup.com/usa/article/attachment/T0266022EN_US/403294 ; https://www.realoem.com/bmw/en/showparts?diagId=36_2254&id=7F03-USA---G12-BMW-750i'),
('BMW','G11','M760i',2017,2022,'Standard 760M 20-inch package','United States',true,
 '20x8.5 ET25','20x10 ET41','245/40R20 front / 275/35R20 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the G12 M760i standard package as 20x8.5 front and 20x10 rear with 245/40R20 and 275/35R20 tires. The BMW OEM parts catalog identifies the 760M wheels as 8.5Jx20 ET25 front and 10Jx20 ET41 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0290164EN_US/the-new-2020-bmw-7-series-sedan ; https://www.press.bmwgroup.com/usa/article/attachment/T0266022EN_US/403294 ; https://www.realoem.com/bmw/en/showparts?diagId=36_2340&id=7F03-USA---G12-BMW-750i');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g11_7_series_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g11_7_series_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G11'
  and trim in ('740i','750i','M760i') and active
order by trim,is_default desc,year_start;
