-- Offset Lab Fitment
-- Pack 103: verified BMW E82 135i Coupe and 1 Series M Coupe baselines.
-- Uses BMW North America standard-equipment documentation and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='E82 1 Series Coupe',year_start=2008,year_end=2013
where make='BMW' and model='E82';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x7.5 ET49',factory_rear='18x8.5 ET52',
    factory_tire='215/40R18 front / 245/35R18 rear'
where make='BMW' and model='E82' and trim='135i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x9 ET31',factory_rear='19x10 ET25',
    factory_tire='245/35R19 front / 265/35R19 rear'
where make='BMW' and model='E82' and trim='1M' and active is not false;

-- OEM+ retains each factory tire package and moves the wheels outward 5 mm.
update public.fitment_presets
set front='18x7.5 ET44',rear='18x8.5 ET47',front_tire='215/40R18',rear_tire='245/35R18'
where make='BMW' and model='E82' and trim='135i'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9 ET26',rear='19x10 ET20',front_tire='245/35R19',rear_tire='265/35R19'
where make='BMW' and model='E82' and trim='1M'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_e82_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_e82_verified_baselines;

insert into bmw_e82_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','E82','135i',2008,2013,'Standard 264 18-inch performance package','United States',true,'18x7.5 ET49','18x8.5 ET52','215/40R18 front / 245/35R18 rear','5x120','72.6mm','verified','BMW North America standard-equipment documentation identifies the E82 135i Coupe standard style 264 package as 18x7.5 front and 18x8.5 rear with 215/40R18 and 245/35R18 performance tires. The BMW OEM parts catalog identifies the corresponding E82 geometry as 7.5Jx18 ET49 front and 8.5Jx18 ET52 rear and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0018120EN_US/42485 ; https://www.realoem.com/bmw/enUS/options?code=SZXTA&series=E82'),
('BMW','E82','1M',2011,2012,'Standard 359M 19-inch package','United States',true,'19x9 ET31','19x10 ET25','245/35R19 front / 265/35R19 rear','5x120','72.6mm','verified','BMW North America documentation identifies the 1 Series M Coupe standard 359M package as 19x9 front and 19x10 rear with 245/35R19 and 265/35R19 tires. The BMW OEM parts catalog identifies the 359M wheels as 9Jx19 ET31 front and 10Jx19 ET25 rear and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0092337EN_US/the-all-new-bmw-1-series-m-coupe ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1631&id=UR91-EUR-09_2010_E82_BMW_M_Coup%C3%A9');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_e82_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_e82_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='E82' and active
order by trim,is_default desc,year_start;
