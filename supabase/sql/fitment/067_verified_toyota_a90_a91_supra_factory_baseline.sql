-- Offset Lab Fitment
-- Pack 067: verified Toyota A90/A91 GR Supra 3.0 factory baseline.
-- Also retires the orphaned duplicate "Supra" catalog entry.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='A90/A91 GR Supra',year_start=2020,year_end=null
where make='Toyota' and model='A90 / A91';

update public.vehicle_trims set active=false
where make='Toyota' and model='Supra';

update public.fitment_presets set active=false
where make='Toyota' and model='Supra';

update public.vehicle_trims
set active=true,display_name='Supra 3.0'
where make='Toyota' and model='A90 / A91' and trim='Supra 3.0';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9 ET32',factory_rear='19x10 ET40',
    factory_tire='255/35R19 front / 275/35R19 rear'
where make='Toyota' and model='A90 / A91' and trim='Supra 3.0'
  and active is not false;

create temp table if not exists toyota_a90_a91_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_a90_a91_verified_baseline;

insert into toyota_a90_a91_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','A90 / A91','Supra 3.0',2020,null,
 '3.0 / 3.0 Premium / A91 19-inch forged-wheel package','US',true,
 '19x9 ET32','19x10 ET40','255/35R19 front / 275/35R19 rear',
 '5x112','66.6mm','verified',
 'Toyota''s official GR Supra product information and 2021 eBrochure specify the staggered forged-aluminum production package: 19x9 front with 255/35ZR19 and 19x10 rear with 275/35ZR19. Toyota''s GR wheel installation specification identifies IN32 front and IN40 rear with 5x112 PCD. Toyota parts/service records specify a 66.6 mm hub and M14x1.25 conical-seat wheel bolts. Sources: https://pressroom.toyota.com/2020-supra-product-supra/ ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/gr-supra_ebrochure.pdf ; https://www.trdparts.jp/manual_pdf/supra/MS213-14001-2.pdf');

delete from public.fitment_factory_baselines
where make='Toyota' and model in ('A90 / A91','Supra');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_a90_a91_verified_baseline;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='A90 / A91' and active
order by trim;
