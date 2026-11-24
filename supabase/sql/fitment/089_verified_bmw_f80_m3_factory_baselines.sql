-- Offset Lab Fitment
-- Pack 089: verified BMW F80 M3, M3 Competition, and M3 CS baselines.
-- Uses BMW Group's exact F8x wheel/tire matrix and trim-specific packages.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F80 M3',year_start=2015,year_end=2018
where make='BMW' and model='F80';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x9 ET29',factory_rear='18x10 ET40',
    factory_tire='255/40R18 front / 275/40R18 rear'
where make='BMW' and model='F80' and trim='M3' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='20x9 ET29',factory_rear='20x10 ET40',
    factory_tire='265/30R20 front / 285/30R20 rear'
where make='BMW' and model='F80' and trim='M3 Competition'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x9 ET29',factory_rear='20x10 ET40',
    factory_tire='265/35R19 front / 285/30R20 rear'
where make='BMW' and model='F80' and trim='M3 CS' and active is not false;

update public.fitment_presets
set front='20x9.5 ET25',rear='20x10.5 ET37',
    front_tire='265/30R20',rear_tire='285/30R20'
where make='BMW' and model='F80' and trim='M3 Competition'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9.5 ET25',rear='20x10.5 ET37',
    front_tire='265/35R19',rear_tire='285/30R20'
where make='BMW' and model='F80' and trim='M3 CS'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f80_m3_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f80_m3_verified_baselines;

insert into bmw_f80_m3_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F80','M3',2015,2018,'M3 standard 513M 18-inch package','North America/Europe',true,
 '18x9 ET29','18x10 ET40','255/40R18 front / 275/40R18 rear','5x120','72.6mm','verified',
 'BMW Group technical wheel documentation identifies the F80 M3 standard 513M package as 9Jx18 IS29 front and 10Jx18 IS40 rear with 255/40ZR18 and 275/40ZR18 tires. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F8xM_2017.pdf ; https://www.press.bmwgroup.com/south-africa/article/attachment/T0187882EN/275204'),
('BMW','F80','M3',2015,2018,'M3 optional 437M 19-inch package','North America/Europe',false,
 '19x9 ET29','19x10 ET40','255/35R19 front / 275/35R19 rear','5x120','72.6mm','verified',
 'BMW Group technical wheel documentation identifies the optional F80 M3 437M package as 9Jx19 IS29 front and 10Jx19 IS40 rear with 255/35ZR19 and 275/35ZR19 tires. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Source: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F8xM_2017.pdf'),
('BMW','F80','M3 Competition',2016,2018,'M3 Competition standard 666M 20-inch package','North America/Europe',true,
 '20x9 ET29','20x10 ET40','265/30R20 front / 285/30R20 rear','5x120','72.6mm','verified',
 'BMW Group technical wheel documentation identifies the F80 M3 Competition 666M package as 9Jx20 IS29 front and 10Jx20 IS40 rear with 265/30ZR20 and 285/30ZR20 tires. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F8xM_2017.pdf ; https://www.press.bmwgroup.com/usa/article/detail/T0250284EN_US/new-competition-package-amps-up-the-bmw-m3-and-m4?language=en_US'),
('BMW','F80','M3 CS',2018,2018,'M3 CS standard 763M 19/20-inch package','North America/Europe',true,
 '19x9 ET29','20x10 ET40','265/35R19 front / 285/30R20 rear','5x120','72.6mm','verified',
 'BMW Group technical wheel documentation identifies the F80 M3 CS 763M package as 9Jx19 IS29 front and 10Jx20 IS40 rear with 265/35ZR19 and 285/30ZR20 tires. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F8xM_2017.pdf ; https://www.press.bmwgroup.com/usa/article/detail/T0275824EN_US/the-first-ever-bmw-m3-cs');

delete from public.fitment_factory_baselines
where make='BMW' and model='F80'
  and trim in ('M3','M3 Competition','M3 CS');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from bmw_f80_m3_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F80'
  and trim in ('M3','M3 Competition','M3 CS') and active
order by trim,is_default desc,year_start;
