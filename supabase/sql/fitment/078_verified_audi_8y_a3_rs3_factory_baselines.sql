-- Offset Lab Fitment
-- Pack 078: verified Audi 8Y A3 and RS 3 factory baselines.
-- Preserves the RS 3's factory reverse-staggered wheel and tire geometry.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='8Y A3 / S3 / RS 3',year_start=2020,year_end=2025
where make='Audi' and model='8Y';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='18x8 ET46',factory_rear='18x8 ET46',
    factory_tire='225/40R18 square'
where make='Audi' and model='8Y' and trim='A3'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='57.1mm',
    factory_front='19x9 ET25',factory_rear='19x8 ET46',
    factory_tire='265/30R19 front / 245/35R19 rear'
where make='Audi' and model='8Y' and trim='RS3'
  and active is not false;

-- Keep OEM+ reverse-staggered and move each axle mildly outward from factory.
update public.fitment_presets
set front='19x9 ET20',rear='19x8.5 ET42',
    front_tire='265/30R19',rear_tire='245/35R19'
where make='Audi' and model='8Y' and trim='RS3' and style='oemplus'
  and active is not false;

create temp table if not exists audi_8y_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_8y_verified_baselines;

insert into audi_8y_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','8Y','A3',2020,2025,'A3 S line 18-inch production package','Europe/Japan',true,
 '18x8 ET46','18x8 ET46','225/40R18 square','5x112','57.1mm','verified',
 'Audi official A3 price and product guides specify the 8Y A3 18-inch production package as 8Jx18 with 225/40 R18 tires. Audi Genuine Accessories lists the exact A3 Sedan / Sportback application as 8Jx18 ET46 with 225/40 R18 AO tires. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/country/de/de/neuwagen/preislisten/my-2025/preislisten/preisliste_a3-sportback_a3-allstreet_a3-limousine_a3-sportback-tfsi-e_s3-sportback_s3-limousine.pdf ; https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/a3/my25/A3_Product_Information_241205.pdf ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf'),
('Audi','8Y','RS3',2021,2025,'RS 3 reverse-staggered 19-inch production package','Europe',true,
 '19x9 ET25','19x8 ET46','265/30R19 front / 245/35R19 rear','5x112','57.1mm','verified',
 'Audi MediaCenter technical data specifies the 8Y RS 3 factory reverse-staggered package as 9Jx19 front and 8Jx19 rear with 265/30 ZR19 front and 245/35 ZR19 rear tires. Audi Genuine Accessories identifies the exact RS 3 application offsets as ET25 front and ET46 rear. Hardware is 5x112 with a 57.1 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://uploads.audi-mediacenter.com/system/production/car_motorizations/241/file_en/28776b93cf213d6a3c2e4336e62484200208389e/eTD-Audi-RS3-Sportback-TFSI_240829.pdf?disposition=attachment ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and model='8Y' and trim in ('A3','RS3');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_8y_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='8Y' and trim in ('A3','RS3') and active
order by trim,is_default desc,year_start;
