-- Offset Lab Fitment
-- Pack 086: verified second-generation Audi R8 (Type 4S) V10 baselines.
-- Uses Audi's standard 19-inch production package and keeps OEM+ distinct.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='Type 4S R8',year_start=2017,year_end=2023
where make='Audi' and model='4S';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='19x8.5 ET42',factory_rear='19x11 ET50',
    factory_tire='245/35R19 front / 295/35R19 rear'
where make='Audi' and model='4S'
  and trim in ('V10','V10 Plus / Performance') and active is not false;

update public.fitment_presets
set front='20x8.5 +40',rear='20x11 +45',
    front_tire='245/30R20',rear_tire='305/30R20'
where make='Audi' and model='4S'
  and trim in ('V10','V10 Plus / Performance')
  and style='oemplus' and active is not false;

create temp table if not exists audi_4s_r8_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_4s_r8_verified_baselines;

insert into audi_4s_r8_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','4S','V10',2017,2023,'R8 V10 standard 19-inch production package','North America/Europe',true,
 '19x8.5 ET42','19x11 ET50','245/35R19 front / 295/35R19 rear','5x112','57.1mm','verified',
 'Audi technical documentation identifies the Type 4S R8 V10 standard wheels as 8.5Jx19 ET42 front and 11Jx19 ET50 rear with 245/35R19 and 295/35R19 tires. It separately identifies the optional 20-inch package as 8.5Jx20 ET42 and 11Jx20 ET47 with 245/30R20 and 305/30R20 tires. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Source: https://static.nhtsa.gov/odi/tsbs/2016/MC-10119355-9999.pdf'),
('Audi','4S','V10 Plus / Performance',2017,2023,'R8 V10 Plus standard 19-inch production package','North America/Europe',true,
 '19x8.5 ET42','19x11 ET50','245/35R19 front / 295/35R19 rear','5x112','57.1mm','verified',
 'Audi technical documentation identifies the Type 4S R8 V10 Plus standard wheels as 8.5Jx19 ET42 front and 11Jx19 ET50 rear with 245/35R19 and 295/35R19 tires. It separately identifies the optional 20-inch package as 8.5Jx20 ET42 and 11Jx20 ET47 with 245/30R20 and 305/30R20 tires. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Source: https://static.nhtsa.gov/odi/tsbs/2016/MC-10119355-9999.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and model='4S'
  and trim in ('V10','V10 Plus / Performance');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_4s_r8_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='4S'
  and trim in ('V10','V10 Plus / Performance') and active
order by trim,is_default desc,year_start;
