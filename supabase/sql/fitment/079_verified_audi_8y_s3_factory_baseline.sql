-- Offset Lab Fitment
-- Pack 079: verified Audi 8Y S3 factory baseline.
-- Audi equipment literature and the Audi AG type-approval wheel schedule agree
-- on the standard 18-inch package geometry.
-- Plain SQL only and safe to re-run.

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='18x8 ET46',factory_rear='18x8 ET46',
    factory_tire='225/40R18 square'
where make='Audi' and model='8Y' and trim='S3'
  and active is not false;

create temp table if not exists audi_8y_s3_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_8y_s3_verified_baseline;

insert into audi_8y_s3_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','8Y','S3',2020,2025,'S3 standard 18-inch production package','Europe/Japan',true,
 '18x8 ET46','18x8 ET46','225/40R18 square','5x112','57.1mm','verified',
 'Audi official S3 product information identifies the standard 8Y S3 wheel and tire package as 8Jx18 with 225/40 R18 tires. The Audi AG GY type-approval wheel schedule lists the corresponding 8Y0-series production wheels as 8Jx18 ET46 with 225/40 R18 tires and factory wheel bolts. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/a3/my25/A3_S3_Product_Information_241010.pdf ; https://www.kunzmann.de/produkt/wheels-audi-a3-8y-18-inch-black-5-twin-spokes-genuine%2C42078%2CABE_8Y0071498__AX1_200605.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and model='8Y' and trim='S3';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_8y_s3_verified_baseline;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='8Y' and trim='S3' and active
order by is_default desc,year_start;
