-- Offset Lab Fitment
-- Pack 085: verified first-generation Audi R8 (Type 42) V8/V10 baselines.
-- Preserves the axle-specific production package and separates OEM+ from OEM.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='Type 42 R8',year_start=2007,year_end=2015
where make='Audi' and model='42';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='19x8.5 ET42',factory_rear='19x11 ET50',
    factory_tire='235/35R19 front / 295/30R19 rear'
where make='Audi' and model='42' and trim in ('V8','V10')
  and active is not false;

update public.fitment_presets
set front='19x9 +40',rear='19x11 +47',
    front_tire='245/35R19',rear_tire='305/30R19'
where make='Audi' and model='42' and trim in ('V8','V10')
  and style='oemplus' and active is not false;

create temp table if not exists audi_42_r8_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_42_r8_verified_baselines;

insert into audi_42_r8_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','42','V8',2007,2015,'R8 V8 standard 19-inch production package','North America/Europe',true,
 '19x8.5 ET42','19x11 ET50','235/35R19 front / 295/30R19 rear','5x112','57.1mm','verified',
 'Audi of America model-year service documentation identifies the Type 42 R8 4.2 production tires as 235/35 R19 front and 295/30 R19 rear. Audi original Type 42 production wheels establish the corresponding axle geometry as 8.5Jx19 ET42 front and 11Jx19 ET50 rear. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2013/MC-10121526-9999.pdf ; https://www.kleinanzeigen.de/s-saarland/19-5-112/k0l285'),
('Audi','42','V10',2009,2015,'R8 V10 standard 19-inch production package','North America/Europe',true,
 '19x8.5 ET42','19x11 ET50','235/35R19 front / 295/30R19 rear','5x112','57.1mm','verified',
 'Audi of America model-year service documentation identifies the Type 42 R8 5.2 production tires as 235/35 R19 front and 295/30 R19 rear. Audi original Type 42 production wheels establish the corresponding axle geometry as 8.5Jx19 ET42 front and 11Jx19 ET50 rear. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2013/MC-10121526-9999.pdf ; https://www.kleinanzeigen.de/s-saarland/19-5-112/k0l285');

delete from public.fitment_factory_baselines
where make='Audi' and model='42' and trim in ('V8','V10');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_42_r8_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='42' and trim in ('V8','V10') and active
order by trim,is_default desc,year_start;
