-- Offset Lab Fitment
-- Pack 082: verified Audi B9/B9.5 A4 and S4 factory baselines.
-- Uses documented production packages and Audi original wheel geometry.
-- Plain SQL only and safe to re-run.

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET40',factory_rear='18x8 ET40',
    factory_tire='245/40R18 square'
where make='Audi' and model='B9' and trim='A4'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET40',factory_rear='19x8.5 ET40',
    factory_tire='245/35R19 square'
where make='Audi' and model='B9' and trim='S4'
  and active is not false;

create temp table if not exists audi_b9_a4_s4_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_b9_a4_s4_verified_baselines;

insert into audi_b9_a4_s4_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','B9','A4',2016,2024,'A4 S line 18-inch production package','Europe/Japan',true,
 '18x8 ET40','18x8 ET40','245/40R18 square','5x112','66.6mm','verified',
 'Audi official A4 price and product literature identifies the B9/B9.5 A4 18-inch production package as 8Jx18 with 245/40 R18 tires. Audi original wheel part 8W0 601 025 HM establishes the exact application geometry as 8Jx18 ET40. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/country/de/de/neuwagen/preislisten/my-2025/preislisten/preisliste_a4-limousine_a4-avant.pdf ; https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/a4/my25/A4_S4_Product_Information_241209.pdf ; https://audi.steingruppe.de/raeder/gebrauchte-raeder/a4/a-2419/audi-a4/s4-sommer-komplettraeder-8jx18-et40-245/40-r18-93y-a-2419'),
('Audi','B9','S4',2017,2024,'S4 standard 19-inch production package','Japan/Europe',true,
 '19x8.5 ET40','19x8.5 ET40','245/35R19 square','5x112','66.6mm','verified',
 'Audi official A4/S4 product literature identifies the standard S4 package as 8.5Jx19 with 245/35 R19 tires. Audi original 8W0-series production wheels establish the exact geometry as 8.5Jx19 ET40. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://media.audi.com/is/content/audi/country/jp/ja/assets/catalogue/a4/my25/A4_S4_Product_Information_241209.pdf ; https://www.online-teile.com/volkswagen-ersatzteile/en/8W0601025GJ_spare-part.html');

delete from public.fitment_factory_baselines
where make='Audi' and model='B9' and trim in ('A4','S4');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_b9_a4_s4_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and model='B9' and trim in ('A4','S4') and active
order by trim,is_default desc,year_start;
