-- Offset Lab Fitment
-- Pack 093: verified BMW G87 M2 factory baseline.
-- Uses BMW launch specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G87 M2',year_start=2023,year_end=2026
where make='BMW' and model='G87';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9.5 ET20',factory_rear='20x10.5 ET20',
    factory_tire='275/35R19 front / 285/30R20 rear'
where make='BMW' and model='G87' and trim='M2'
  and active is not false;

-- Preserve OEM+ as a mild, distinct step outward from the verified factory setup.
update public.fitment_presets
set front='19x9.5 ET15',rear='20x10.5 ET15',
    front_tire='275/35R19',rear_tire='285/30R20'
where make='BMW' and model='G87' and trim='M2'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_g87_m2_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g87_m2_verified_baselines;

insert into bmw_g87_m2_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G87','M2',2023,2026,'Standard 930M 19/20-inch package','United States',true,
 '19x9.5 ET20','20x10.5 ET20','275/35R19 front / 285/30R20 rear','5x112','66.6mm','verified',
 'BMW USA launch documentation identifies the G87 M2 standard setup as 9.5Jx19 front and 10.5Jx20 rear with 275/35ZR19 and 285/30ZR20 tires. The BMW OEM parts catalog identifies the 930M wheels as ET20 front (36 11 7 882 869) and rear (36 11 7 882 870) and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0404581EN_US/the-all-new-bmw-m2-purebred-driving-pleasure-intensely-concentrated ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2899&id=11DM-EUR-09_2021_G87_BMW-M2');

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
from bmw_g87_m2_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_g87_m2_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G87' and trim='M2' and active
order by is_default desc,year_start;
