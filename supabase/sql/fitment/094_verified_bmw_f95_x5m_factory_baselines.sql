-- Offset Lab Fitment
-- Pack 094: verified BMW F95 X5 M and X5 M Competition baselines.
-- Uses BMW USA launch specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F95 X5 M',year_start=2020,year_end=2026
where make='BMW' and model='F95';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='21x10.5 ET31',factory_rear='21x11.5 ET43',
    factory_tire='295/35R21 front / 315/35R21 rear'
where make='BMW' and model='F95' and trim='X5M'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='21x10.5 ET31',factory_rear='22x11.5 ET43',
    factory_tire='295/35R21 front / 315/30R22 rear'
where make='BMW' and model='F95' and trim='X5M Competition'
  and active is not false;

-- Preserve OEM+ as a mild 5 mm outward step from each trim's default factory package.
update public.fitment_presets
set front='21x10.5 ET26',rear='21x11.5 ET38',
    front_tire='295/35R21',rear_tire='315/35R21'
where make='BMW' and model='F95' and trim='X5M'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='21x10.5 ET26',rear='22x11.5 ET38',
    front_tire='295/35R21',rear_tire='315/30R22'
where make='BMW' and model='F95' and trim='X5M Competition'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f95_x5m_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f95_x5m_verified_baselines;

insert into bmw_f95_x5m_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F95','X5M',2020,2023,'Standard 808M 21-inch package','United States',true,
 '21x10.5 ET31','21x11.5 ET43','295/35R21 front / 315/35R21 rear','5x112','66.6mm','verified',
 'BMW USA launch specifications identify the F95 X5 M standard 808M package as 10.5Jx21 front and 11.5Jx21 rear with 295/35ZR21 and 315/35ZR21 tires. The BMW OEM parts catalog identifies ET31 front and ET43 rear and M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0301383EN_US/the-new-2020-bmw-x5-m-and-x6-m ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2616&id=JU01-EUR-11_2017_F95_BMW_X5_M'),
('BMW','F95','X5M Competition',2020,2026,'Standard 818M/809M 21/22-inch package','United States',true,
 '21x10.5 ET31','22x11.5 ET43','295/35R21 front / 315/30R22 rear','5x112','66.6mm','verified',
 'BMW USA launch specifications identify the F95 X5 M Competition standard package as 10.5Jx21 front and 11.5Jx22 rear with 295/35ZR21 and 315/30ZR22 tires. The BMW OEM parts catalog identifies ET31 front and ET43 rear for the 818M and 809M packages and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0301383EN_US/the-new-2020-bmw-x5-m-and-x6-m ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2643&id=JU02-EUR-04_2018_F95_BMW_X5_M ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2642&id=13ET-USA-03-2025-F95N-BMW-X5_M_Comp');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_f95_x5m_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_f95_x5m_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F95' and trim in ('X5M','X5M Competition') and active
order by trim,is_default desc,year_start;
