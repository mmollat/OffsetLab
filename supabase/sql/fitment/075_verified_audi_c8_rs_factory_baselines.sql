-- Offset Lab Fitment
-- Pack 075: verified Audi C8 RS 6 Avant and RS 7 Sportback baselines.
-- Uses Audi's documented 22-inch production option and exact Audi application
-- geometry; moves OEM+ 5 mm outward so it remains distinct from factory.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='C8 RS 6 / RS 7',year_start=2020,year_end=2025
where make='Audi' and model='C8';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='22x10.5 ET19',factory_rear='22x10.5 ET19',
    factory_tire='285/30R22 square'
where make='Audi' and model='C8'
  and trim in ('RS6 Avant','RS7') and active is not false;

-- The previous OEM+ rows exactly duplicated the selected factory package.
-- ET14 preserves the same wheel and tire while adding a mild 5 mm outward step.
update public.fitment_presets
set front='22x10.5 ET14',rear='22x10.5 ET14',
    front_tire='285/30R22',rear_tire='285/30R22'
where make='Audi' and model='C8'
  and trim in ('RS6 Avant','RS7') and style='oemplus'
  and active is not false;

create temp table if not exists audi_c8_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_c8_verified_baselines;

insert into audi_c8_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','C8','RS6 Avant',2020,2025,'Audi Sport 22-inch factory option','Europe',true,
 '22x10.5 ET19','22x10.5 ET19','285/30R22 square',
 '5x112','66.6mm','verified',
 'Audi MediaCenter documents the C8 RS 6 Avant 22-inch production option as 10.5Jx22 with 285/30 R22 tires. Audi Genuine Accessories lists the exact C8 RS 6 / RS 7 10.5Jx22 application geometry as ET19 with 285/30 R22 tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. This verified optional package is used as the comparison baseline; the standard European package is 10.5Jx21 with 275/35 R21 tires. Sources: https://uploads.audi-mediacenter.com/system/production/uploaded_files/15950/file/00f52e48ecf386a2df7f60327d91f2e96ce93a50/de_BasisInfo_RS_6_Avant.pdf?1573802095=&disposition=attachment ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf'),
('Audi','C8','RS7',2020,2025,'Audi Sport 22-inch factory option','Europe',true,
 '22x10.5 ET19','22x10.5 ET19','285/30R22 square',
 '5x112','66.6mm','verified',
 'Audi MediaCenter documents the C8 RS 7 Sportback 22-inch production option as 10.5Jx22 with 285/30 R22 tires. Audi Genuine Accessories lists the exact C8 RS 6 / RS 7 10.5Jx22 application geometry as ET19 with 285/30 R22 tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. This verified optional package is used as the comparison baseline; the standard European package is 10.5Jx21 with 275/35 R21 tires. Sources: https://www.audi-mediacenter.com/de/publikationen/preislisten/preisliste-audi-rs-7-sportback-rs-7-sportback-performance-modelljahr-2025-841/download ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and model='C8' and trim in ('RS6 Avant','RS7');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_c8_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='C8' and active
order by trim,is_default desc,year_start;
