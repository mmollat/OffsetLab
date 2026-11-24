-- Offset Lab Fitment
-- Pack 088: verified BMW F90 M5, M5 Competition, and M5 CS baselines.
-- Uses the trim-specific standard wheel packages documented by BMW Group.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F90 M5',year_start=2018,year_end=2023
where make='BMW' and model='F90';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9.5 ET26',factory_rear='19x10.5 ET28',
    factory_tire='275/40R19 front / 285/40R19 rear'
where make='BMW' and model='F90' and trim='M5' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET28',factory_rear='20x10.5 ET28',
    factory_tire='275/35R20 front / 285/35R20 rear'
where make='BMW' and model='F90' and trim in ('M5 Competition','M5 CS')
  and active is not false;

update public.fitment_presets
set front='20x10 ET25',rear='20x11 ET25',
    front_tire='275/35R20',rear_tire='285/35R20'
where make='BMW' and model='F90' and trim in ('M5 Competition','M5 CS')
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f90_m5_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f90_m5_verified_baselines;

insert into bmw_f90_m5_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F90','M5',2018,2023,'M5 standard 705M 19-inch package','North America/Europe',true,
 '19x9.5 ET26','19x10.5 ET28','275/40R19 front / 285/40R19 rear','5x112','66.6mm','verified',
 'BMW Group technical wheel documentation identifies the F90 M5 standard 705M package as 9.5Jx19 IS26 front and 10.5Jx19 IS28 rear with 275/40ZR19 and 285/40ZR19 tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F90_M5_2017.pdf ; https://www.press.bmwgroup.com/usa/article/detail/T0273727EN_US/the-all-new-2018-bmw-m5%3A-the-quintessential-high-performance-sedan?language=en_US'),
('BMW','F90','M5',2018,2023,'M5 optional 706M 20-inch package','North America/Europe',false,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW Group technical wheel documentation identifies the optional F90 M5 706M package as 9.5Jx20 IS28 front and 10.5Jx20 IS28 rear with 275/35ZR20 and 285/35ZR20 tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 conical-seat wheel bolts. Source: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F90_M5_2017.pdf'),
('BMW','F90','M5 Competition',2019,2023,'M5 Competition standard 706M/789M 20-inch package','North America/Europe',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW Group documentation identifies the F90 M5 Competition standard package as 9.5Jx20 front and 10.5Jx20 rear with 275/35R20 and 285/35R20 tires. BMW technical wheel documentation gives IS28 on both axles for the 706M production wheels. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F90_M5_2017.pdf ; https://www.press.bmwgroup.com/usa/article/detail/T0309541EN_US/the-new-2021-bmw-m5-sedan?language=en_US'),
('BMW','F90','M5 CS',2022,2022,'M5 CS standard 789M 20-inch package','North America/Europe',true,
 '20x9.5 ET28','20x10.5 ET28','275/35R20 front / 285/35R20 rear','5x112','66.6mm','verified',
 'BMW Group documentation identifies the F90 M5 CS standard 789M package as 9.5Jx20 front and 10.5Jx20 rear with 275/35R20 and 285/35R20 tires; original BMW wheel specifications establish ET28 on both axles. Hardware is 5x112 with a 66.6 mm center bore and M14x1.25 conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0325006EN_US/the-new-bmw-m5-cs?language=en_US ; https://www.press.bmwgroup.com/canada/article/attachment/T0325569EN/471564');

delete from public.fitment_factory_baselines
where make='BMW' and model='F90' and trim in ('M5','M5 Competition','M5 CS');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from bmw_f90_m5_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F90' and trim in ('M5','M5 Competition','M5 CS')
  and active
order by trim,is_default desc,year_start;
