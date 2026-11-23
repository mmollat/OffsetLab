-- Offset Lab Fitment
-- Pack 081: verified Audi 8S TT, TTS, and TT RS factory baselines.
-- Uses each trim's documented basic production wheel package.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='8S TT / TTS / TT RS',year_start=2014,year_end=2023
where make='Audi' and model='8S';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='17x8 ET47',factory_rear='17x8 ET47',
    factory_tire='225/50R17 square'
where make='Audi' and model='8S' and trim='TT'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='18x8.5 ET50',factory_rear='18x8.5 ET50',
    factory_tire='245/40R18 square'
where make='Audi' and model='8S' and trim='TTS'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='19x9 ET52',factory_rear='19x9 ET52',
    factory_tire='245/35R19 square'
where make='Audi' and model='8S' and trim='TT RS'
  and active is not false;

create temp table if not exists audi_8s_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_8s_verified_baselines;

insert into audi_8s_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','8S','TT',2014,2023,'TT basic 17-inch production package','Europe',true,
 '17x8 ET47','17x8 ET47','225/50R17 square','5x112','57.1mm','verified',
 'Audi MediaCenter technical data identifies the 8S TT basic production package as 8Jx17 with 225/50 R17 tires. European vehicle type-approval data records that package at ET47. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://uploads.audi-mediacenter.com/system/production/car_motorizations/1243/file_en/0963f4ffa97bc4da673e65ee635a8d8df16b1481/eTD_Audi_TT_Coupe_45_TFSI_quattro_S_tronic_180kW_230113.pdf?1698933948=&disposition=attachment ; https://www.dauto.ch/fr/typenscheine/1ac374-audi-tt-2-0t-coupe'),
('Audi','8S','TTS',2014,2023,'TTS basic 18-inch production package','Europe',true,
 '18x8.5 ET50','18x8.5 ET50','245/40R18 square','5x112','57.1mm','verified',
 'Audi MediaCenter technical data identifies the 8S TTS basic production package as 8.5Jx18 with 245/40 R18 tires. The vehicle type-approval wheel schedule records the TTS 8.5Jx18 wheel at ET50. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://uploads.audi-mediacenter.com/system/production/car_motorizations/117/file_en/47310967d3234d1373d6646cf8bcab32998f3b5b/eTD_Audi_TTS_Coupe_TFSI_230113.pdf?1698933679=&disposition=attachment ; https://www.dmsb.de/de/automobilsport/file/279788'),
('Audi','8S','TT RS',2016,2023,'TT RS basic 19-inch production package','Europe',true,
 '19x9 ET52','19x9 ET52','245/35R19 square','5x112','57.1mm','verified',
 'Audi MediaCenter technical data identifies the 8S TT RS basic production package as 9Jx19 with 245/35 R19 tires. The vehicle type-approval wheel schedule records the TT RS 9Jx19 wheel at ET52. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://uploads.audi-mediacenter.com/system/production/car_motorizations/837/file_en/ab1a688414eda4f444a9a7fad976f57fbe0061a8/eTD_Audi_TTRS_Coupe_TFSI_221102.pdf?1698933785= ; https://www.dmsb.de/de/automobilsport/file/279788');

delete from public.fitment_factory_baselines
where make='Audi' and model='8S' and trim in ('TT','TTS','TT RS');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_8s_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='8S' and trim in ('TT','TTS','TT RS') and active
order by trim,is_default desc,year_start;
