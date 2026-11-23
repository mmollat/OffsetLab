-- Offset Lab Fitment
-- Pack 053: verified Nissan R35 GT-R factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2009,year_end=2024
where make='Nissan' and model='R35';

update public.fitment_presets
set factory_front='20x9.5 ET45',factory_rear='20x10.5 ET25',
    factory_tire='255/40R20 front / 285/35R20 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='R35' and trim='Premium' and active is not false;

update public.fitment_presets
set factory_front='20x10 ET41',factory_rear='20x10.5 ET25',
    factory_tire='255/40R20 front / 285/35R20 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='R35' and trim in ('Nismo','NISMO')
  and active is not false;

create temp table if not exists nissan_r35_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_r35_verified_baselines;

insert into nissan_r35_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','R35','Premium',2009,2024,'GT-R Premium production package','US',true,
 '20x9.5 ET45','20x10.5 ET25','255/40R20 front / 285/35R20 rear',
 '5x114.3','66.1mm','verified',
 'Official Nissan GT-R owner manuals specify 20x9.5J ET45 front and 20x10.5J ET25 rear wheels with 255/40ZRF20 and 285/35ZRF20 tires for the Premium/non-NISMO model. The 2024 Nissan brochure confirms the same wheel widths and tire sizes. Hardware is 5x114.3, 66.1 mm with M14x1.5 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/GTR/2010/2010-GTR-owner-manual.pdf ; https://www.nissan-cdn.net/content/dam/Nissan/pr/Owners-manuals/gt-r/2019-GTR-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-gt-r-brochure-en.pdf'),
('Nissan','R35','Nismo',2015,2024,'GT-R NISMO production package','US',true,
 '20x10 ET41','20x10.5 ET25','255/40R20 front / 285/35R20 rear',
 '5x114.3','66.1mm','verified',
 'The official 2019 Nissan GT-R owner manual specifies the NISMO front wheel as 20x10J ET41 and the rear as 20x10.5J ET25, with 255/40ZRF20 and 285/35ZRF20 tires. Nissan brochures and press material confirm the 20x10/20x10.5 NISMO package. Hardware is 5x114.3, 66.1 mm with M14x1.5 lug nuts. Sources: https://www.nissan-cdn.net/content/dam/Nissan/pr/Owners-manuals/gt-r/2019-GTR-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-gt-r-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/2023-nissan-gt-r-press-kit'),
('Nissan','R35','NISMO',2015,2024,'GT-R NISMO production package','US',true,
 '20x10 ET41','20x10.5 ET25','255/40R20 front / 285/35R20 rear',
 '5x114.3','66.1mm','verified',
 'The official 2019 Nissan GT-R owner manual specifies the NISMO front wheel as 20x10J ET41 and the rear as 20x10.5J ET25, with 255/40ZRF20 and 285/35ZRF20 tires. Nissan brochures and press material confirm the 20x10/20x10.5 NISMO package. Hardware is 5x114.3, 66.1 mm with M14x1.5 lug nuts. Sources: https://www.nissan-cdn.net/content/dam/Nissan/pr/Owners-manuals/gt-r/2019-GTR-owner-manual.pdf ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-gt-r-brochure-en.pdf ; https://usa.nissannews.com/en-US/releases/2023-nissan-gt-r-press-kit');

delete from public.fitment_factory_baselines
where make='Nissan' and model='R35';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_r35_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='R35' and active
order by trim;
