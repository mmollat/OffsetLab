-- Offset Lab Fitment
-- Pack 077: verified Audi B9/B9.5 S5 factory baseline.
-- The active S5 trim spans the original and facelift B9 platform in this catalog.
-- Plain SQL only and safe to re-run.

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET32',factory_rear='19x8.5 ET32',
    factory_tire='255/35R19 square'
where make='Audi' and model='B9' and trim='S5'
  and active is not false;

create temp table if not exists audi_b9_s5_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_b9_s5_verified_baseline;

insert into audi_b9_s5_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','B9','S5',2017,2024,'S5 19-inch production package','Europe',true,
 '19x8.5 ET32','19x8.5 ET32','255/35R19 square','5x112','66.6mm','verified',
 'Audi official S5 equipment literature identifies the B9 S5 19-inch package as 8.5Jx19 with 255/35 R19 tires. Audi Genuine Accessories lists the exact A5/S5 Coupe, Cabriolet, and Sportback application as 8.5Jx19 ET32 with 255/35 R19 AO tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/nemo/australia/specification_guides/a5/s5_sportback/Audi_A5_S5_Coupe_Sportback_Specification_Guide_MY24.pdf ; https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/a5/my25/A5_S5_Product_Information_241209.pdf ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and model='B9' and trim='S5';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_b9_s5_verified_baseline;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='B9' and trim='S5' and active
order by is_default desc,year_start;
