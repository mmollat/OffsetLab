-- Offset Lab Fitment
-- Pack 076: verified Audi B9 and B9.5 RS 5 factory baselines.
-- Audi production literature establishes the 9Jx20 / 275/30R20 package;
-- Audi Genuine Accessories establishes the exact RS 5 ET22 application.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='B9.5 RS 5',year_start=2020,year_end=2024
where make='Audi' and model='B9.5';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9 ET22',factory_rear='20x9 ET22',
    factory_tire='275/30R20 square'
where make='Audi' and (
  (model='B9' and trim='RS5') or
  (model='B9.5' and trim in ('RS5 Coupe','RS5 Sportback'))
) and active is not false;

-- ET17 retains the factory wheel and tire while adding a mild 5 mm outward step.
update public.fitment_presets
set front='20x9 ET17',rear='20x9 ET17',
    front_tire='275/30R20',rear_tire='275/30R20'
where make='Audi' and style='oemplus' and (
  (model='B9' and trim='RS5') or
  (model='B9.5' and trim in ('RS5 Coupe','RS5 Sportback'))
) and active is not false;

create temp table if not exists audi_b9_rs5_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table audi_b9_rs5_verified_baselines;

insert into audi_b9_rs5_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Audi','B9','RS5',2017,2019,'Audi Sport 20-inch RS 5 package','Europe',true,
 '20x9 ET22','20x9 ET22','275/30R20 square','5x112','66.6mm','verified',
 'Audi production and equipment literature identifies the original B9 RS 5 20-inch option as 9Jx20 with 275/30 R20 tires. Audi Genuine Accessories lists the exact RS 5 Coupe / Sportback application as 9Jx20 ET22 with 275/30 R20 AO tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://audi.media-corner.ch/sites/default/files/media/pdf/2017-08/Audi_RS_5_Coupe_062017_de.pdf ; https://audi-mediacenter.pl/pliki_audi/6726/Cennik_RS_5_Coupe_RM_2018_od_01.12.2017.pdf ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf'),
('Audi','B9.5','RS5 Coupe',2020,2024,'Audi Sport 20-inch RS 5 package','Europe',true,
 '20x9 ET22','20x9 ET22','275/30R20 square','5x112','66.6mm','verified',
 'Audi official RS 5 equipment guides specify 9Jx20 wheels with 275/30 R20 tires for the facelift RS 5 Coupe. Audi Genuine Accessories lists the exact RS 5 Coupe / Sportback application as 9Jx20 ET22 with 275/30 R20 AO tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://www.audi.com/en/the-sporty-spearhead-of-the-product-line-with-a-new-look-the-rs-5-coupe-and-rs-5-sportback-2020-12728/ ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A408441b5-9af1-44b0-9808-91b0d161cfe4/original/as/RS5_CL_LT2024.01.01.pdf ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf'),
('Audi','B9.5','RS5 Sportback',2020,2024,'Audi Sport 20-inch RS 5 package','Europe',true,
 '20x9 ET22','20x9 ET22','275/30R20 square','5x112','66.6mm','verified',
 'Audi official RS 5 equipment guides specify 9Jx20 wheels with 275/30 R20 tires for the facelift RS 5 Sportback. Audi Genuine Accessories lists the exact RS 5 Coupe / Sportback application as 9Jx20 ET22 with 275/30 R20 AO tires. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat wheel bolts. Sources: https://www.audi.com/en/the-sporty-spearhead-of-the-product-line-with-a-new-look-the-rs-5-coupe-and-rs-5-sportback-2020-12728/ ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A408441b5-9af1-44b0-9808-91b0d161cfe4/original/as/RS5_CL_LT2024.01.01.pdf ; https://emea-dam.audi.com/adobe/assets/urn%3Aaaid%3Aaem%3A9abb3f79-96a9-4bca-9c8a-20f2dcdd98bd/original/as/Audi_Ruote-Complete-invernali.pdf');

delete from public.fitment_factory_baselines
where make='Audi' and (
  (model='B9' and trim='RS5') or
  (model='B9.5' and trim in ('RS5 Coupe','RS5 Sportback'))
);

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from audi_b9_rs5_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Audi' and active and (
  (model='B9' and trim='RS5') or
  (model='B9.5' and trim in ('RS5 Coupe','RS5 Sportback'))
)
order by model,trim,is_default desc,year_start;
