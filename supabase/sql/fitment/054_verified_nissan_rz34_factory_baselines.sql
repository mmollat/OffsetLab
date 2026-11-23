-- Offset Lab Fitment
-- Pack 054: verified Nissan RZ34 Z factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2023,year_end=2026
where make='Nissan' and model='RZ34';

update public.fitment_presets
set factory_front='18x9 ET34',factory_rear='18x9 ET15',
    factory_tire='245/45R18 front / 245/45R18 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='RZ34' and trim='Sport' and active is not false;

update public.fitment_presets
set factory_front='19x9.5 ET40',factory_rear='19x10 ET30',
    factory_tire='255/40R19 front / 275/35R19 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='RZ34' and trim='Performance' and active is not false;

update public.fitment_presets
set factory_front='19x10 ET33',factory_rear='19x10.5 ET23',
    factory_tire='255/40R19 front / 285/35R19 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='RZ34' and trim='NISMO' and active is not false;

create temp table if not exists nissan_rz34_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_rz34_verified_baselines;

insert into nissan_rz34_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','RZ34','Sport',2023,2026,'Z Sport 18-inch production package','US',true,
 '18x9 ET34','18x9 ET15','245/45R18 front / 245/45R18 rear',
 '5x114.3','66.1mm','verified',
 'The official 2024 Nissan Z owner manual specifies 18x9J wheels at ET34 front and ET15 rear with 245/45R18 tires. Nissan press-kit and brochure specifications identify this as the Sport-grade production package. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nissanusa.com/content/dam/Nissan/us/manuals-and-guides/nissan-z/2024/2024-nissan-z-owner-manual.pdf ; https://usa.nissannews.com/en-US/releases/2024-nissan-z-press-kit ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-nissan-z-brochure-en.pdf'),
('Nissan','RZ34','Performance',2023,2026,'Z Performance 19-inch RAYS production package','US',true,
 '19x9.5 ET40','19x10 ET30','255/40R19 front / 275/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2024 Nissan Z owner manual specifies 19x9.5J ET40 front and 19x10J ET30 rear wheels with 255/40R19 and 275/35R19 tires. Nissan press-kit and brochure specifications identify this RAYS forged package as standard on Performance. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nissanusa.com/content/dam/Nissan/us/manuals-and-guides/nissan-z/2024/2024-nissan-z-owner-manual.pdf ; https://usa.nissannews.com/en-US/releases/2024-nissan-z-press-kit ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-nissan-z-brochure-en.pdf'),
('Nissan','RZ34','NISMO',2024,2026,'Z NISMO 19-inch RAYS production package','US',true,
 '19x10 ET33','19x10.5 ET23','255/40R19 front / 285/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2024 Nissan Z owner manual specifies NISMO wheels at 19x10J ET33 front and 19x10.5J ET23 rear, with 255/40R19 and 285/35R19 tires. Nissan press-kit and brochure specifications confirm the NISMO-specific RAYS package. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nissanusa.com/content/dam/Nissan/us/manuals-and-guides/nissan-z/2024/2024-nissan-z-owner-manual.pdf ; https://usa.nissannews.com/en-US/releases/2024-nissan-z-press-kit ; https://www.nissanusa.com/content/dam/Nissan/us/vehicle-brochures/2024/2024-nissan-nissan-z-brochure-en.pdf');

delete from public.fitment_factory_baselines
where make='Nissan' and model='RZ34';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_rz34_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='RZ34' and active
order by trim;
