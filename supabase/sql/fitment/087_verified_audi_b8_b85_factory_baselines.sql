-- Offset Lab Fitment
-- Pack 087: verified Audi B8/B8.5 S4, S5, and RS4 factory baselines.
-- Records specific OEM 19-inch production packages and removes the RS4 placeholder.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='B8 S4 / S5',year_start=2008,year_end=2012
where make='Audi' and model='B8';

update public.vehicle_models
set display_name='B8.5 S4 / RS4',year_start=2013,year_end=2016
where make='Audi' and model='B8.5';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET43',factory_rear='19x8.5 ET43',
    factory_tire='255/35R19 square'
where make='Audi' and model in ('B8','B8.5') and trim='S4'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET32',factory_rear='19x8.5 ET32',
    factory_tire='255/35R19 square'
where make='Audi' and model='B8' and trim='S5' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9 ET24',factory_rear='19x9 ET24',
    factory_tire='265/35R19 square'
where make='Audi' and model='B8.5' and trim='RS4' and active is not false;

update public.fitment_presets
set front='19x9 +35',rear='19x9 +35',
    front_tire='255/35R19',rear_tire='255/35R19'
where make='Audi' and model='B8' and trim='S5'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9.5 +23',rear='19x9.5 +23',
    front_tire='265/35R19',rear_tire='265/35R19'
where make='Audi' and model='B8.5' and trim='RS4'
  and style='oemplus' and active is not false;

create temp table if not exists audi_b8_b85_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_b8_b85_verified_baselines;

insert into audi_b8_b85_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','B8','S4',2010,2012,'S4 factory 19-inch wheel package','North America',true,
 '19x8.5 ET43','19x8.5 ET43','255/35R19 square','5x112','66.6mm','verified',
 'Audi model-year tire documentation lists the S4 255/35R19 production tire. Audi original wheel part 8K0 601 025 AK and its OEM markings establish the matching 8.5Jx19 ET43 geometry. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 R13 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2014/MC-10216605-9999.pdf ; https://www.rennhart.com/audi-s4-19-peeler-wheels-speedlinesl21608k0601025ak19x85et43-sku-197582.html'),
('Audi','B8','S5',2008,2012,'S5 factory 19-inch wheel package','North America/Europe',true,
 '19x8.5 ET32','19x8.5 ET32','255/35R19 square','5x112','66.6mm','verified',
 'Audi model-year tire documentation lists the S5 255/35R19 production tire. Audi original Type 8T wheel specifications establish the matching 8.5Jx19 ET32 geometry. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 R13 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2013/MC-10068856-6903.pdf ; https://cdn.bbs.com/static/assets/images/service/pdfEn/Anwendungsliste_2020.pdf'),
('Audi','B8.5','S4',2013,2016,'S4 factory 19-inch wheel package','North America',true,
 '19x8.5 ET43','19x8.5 ET43','255/35R19 square','5x112','66.6mm','verified',
 'Audi model-year tire documentation lists the S4 255/35R19 production tire. Audi original wheel parts 8K0 601 025 AR/CN/CT and their OEM markings establish the matching 8.5Jx19 ET43 geometry. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 R13 ball-seat wheel bolts. Sources: https://static.nhtsa.gov/odi/tsbs/2014/MC-10216605-9999.pdf ; https://www.ecstuning.com/Audi-B8_S4-Quattro-3.0T/Wheels/OEM_Wheels/19_inch/'),
('Audi','B8.5','RS4',2013,2015,'RS4 Avant standard 19-inch production package','Europe',true,
 '19x9 ET24','19x9 ET24','265/35R19 square','5x112','66.6mm','verified',
 'Audi AG technical press documentation identifies the 2012-2015 RS4 Avant standard package as forged 9Jx19 wheels with 265/35R19 tires. Swiss federal type-approval data establishes ET24 for that 19-inch package and confirms 5x112, 66.5/66.6 mm hub fitment, and M14x1.5 hardware. Sources: https://www.ausmotive.com/downloads/Audi/RS4-Avant-press-kit-June2012.pdf ; https://www.dauto.ch/de/typenscheine/1ad261-audi-rs4-avant-4-2fsi');

delete from public.fitment_factory_baselines
where make='Audi' and (
  (model='B8' and trim in ('S4','S5')) or
  (model='B8.5' and trim in ('S4','RS4'))
);

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_b8_b85_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and (
  (model='B8' and trim in ('S4','S5')) or
  (model='B8.5' and trim in ('S4','RS4'))
) and active
order by model,trim,is_default desc,year_start;
