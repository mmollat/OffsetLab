-- Offset Lab Fitment
-- Pack 080: verified Audi 8V A3, S3, and RS 3 factory baselines.
-- Uses documented production wheel packages and corrects the 8V hub bore.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='8V A3 / S3 / RS 3',year_start=2012,year_end=2020
where make='Audi' and model='8V';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='18x8 ET46',factory_rear='18x8 ET46',
    factory_tire='225/40R18 square'
where make='Audi' and model='8V' and trim in ('A3','S3')
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='19x8 ET49',factory_rear='19x8 ET49',
    factory_tire='235/35R19 square'
where make='Audi' and model='8V' and trim='RS3'
  and active is not false;

create temp table if not exists audi_8v_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_8v_verified_baselines;

insert into audi_8v_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','8V','A3',2017,2020,'A3 S line 18-inch production package','Europe/Japan',true,
 '18x8 ET46','18x8 ET46','225/40R18 square','5x112','57.1mm','verified',
 'Audi official facelift A3 equipment literature identifies the A3 S line 18-inch production package as 8Jx18 with 225/40 R18 tires. The Audi/VAG original-parts catalog lists the matching 8V0-series complete-wheel application as 8Jx18 ET46 with 225/40 R18 tires. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://www.audi-press.jp/press-releases/2017/01/20170126_PressRelease_008_Audi_A3_S3_PI.pdf ; https://nemigaparts.com/cat_spares/etka/audi/a3/890/073300/'),
('Audi','8V','S3',2017,2020,'S3 standard 18-inch production package','Europe/Japan',true,
 '18x8 ET46','18x8 ET46','225/40R18 square','5x112','57.1mm','verified',
 'Audi official facelift S3 equipment literature identifies the standard wheel and tire package as 8Jx18 with 225/40 R18 tires. The Audi/VAG original-parts catalog lists the matching 8V0-series complete-wheel application as 8Jx18 ET46 with 225/40 R18 tires. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://www.audi-press.jp/press-releases/2017/01/20170126_PressRelease_008_Audi_A3_S3_PI.pdf ; https://www.audi-press.jp/presskits/b7rqqm000001a8ff-att/025_Audi_A3_S3_DataInformation.pdf ; https://nemigaparts.com/cat_spares/etka/audi/a3/890/073300/'),
('Audi','8V','RS3',2015,2020,'RS 3 standard 19-inch production package','Japan/Europe',true,
 '19x8 ET49','19x8 ET49','235/35R19 square','5x112','57.1mm','verified',
 'Audi Japan official RS 3 equipment data identifies the standard production package as 8Jx19 with 235/35 R19 tires. The vehicle type-approval wheel schedule records the 8V RS 3 8Jx19 wheel at ET49; it separately records the optional 8.5Jx19 ET53 front wheel. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://www.audi-press.jp/press-releases/2015/10/DataInformartion_RS3SB.pdf ; https://www.dmsb.de/de/automobilsport/file/279788');

delete from public.fitment_factory_baselines
where make='Audi' and model='8V' and trim in ('A3','S3','RS3');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_8v_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='8V' and trim in ('A3','S3','RS3') and active
order by trim,is_default desc,year_start;
