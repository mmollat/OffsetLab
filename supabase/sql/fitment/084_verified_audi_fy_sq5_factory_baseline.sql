-- Offset Lab Fitment
-- Pack 084: verified Audi FY SQ5 factory baseline.
-- The SQ5 remains on the performance-SUV recommendation ladder.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='FY SQ5',year_start=2018,year_end=2025
where make='Audi' and model='FY';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x8 ET39',factory_rear='20x8 ET39',
    factory_tire='255/45R20 square'
where make='Audi' and model='FY' and trim='SQ5'
  and active is not false;

create temp table if not exists audi_fy_sq5_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_fy_sq5_verified_baseline;

insert into audi_fy_sq5_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','FY','SQ5',2018,2025,'SQ5 standard 20-inch production package','Japan/Europe',true,
 '20x8 ET39','20x8 ET39','255/45R20 square','5x112','66.6mm','verified',
 'Audi official Q5/SQ5 product information identifies the FY SQ5 standard package as 8Jx20 with 255/45 R20 tires. Audi original 80A-series production wheels establish the exact geometry as 8Jx20 ET39. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/q5/my25/Q5_SQ5_Product_Information_250402.pdf ; https://felge24.ru/kolesa-v-sbore/originalnye-kolesa-r20-dlya-audi-q5-fy/');

delete from public.fitment_factory_baselines
where make='Audi' and model='FY' and trim='SQ5';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_fy_sq5_verified_baseline;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='FY' and trim='SQ5' and active
order by is_default desc,year_start;
