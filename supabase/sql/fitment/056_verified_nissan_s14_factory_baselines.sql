-- Offset Lab Fitment
-- Pack 056: verified Nissan S14 factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=1993,year_end=1998
where make='Nissan' and model='S14';

update public.fitment_presets
set factory_front='16x6.5 ET40',factory_rear='16x6.5 ET40',
    factory_tire='205/55R16 front / 205/55R16 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='S14' and trim='240SX' and active is not false;

update public.fitment_presets
set factory_front='16x6.5 ET45',factory_rear='16x6.5 ET45',
    factory_tire='205/55R16 front / 205/55R16 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='S14' and trim='Silvia' and active is not false;

create temp table if not exists nissan_s14_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_s14_verified_baselines;

insert into nissan_s14_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','S14','240SX',1995,1998,'240SX SE/LE 16-inch production package','US',true,
 '16x6.5 ET40','16x6.5 ET40','205/55R16 front / 205/55R16 rear',
 '5x114.3','66.1mm','verified',
 'Nissan 1995 and 1998 240SX factory service manuals specify the 16x6.5JJ road wheel at ET40 with 205/55R16 tires; Nissan North America specifications identify this five-lug package with SE/LE. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nicoclub.com/service-manual?fsm=240sx%2F1995%2FPD.pdf ; https://www.nicoclub.com/tech/240sx/97-240sx-specs.pdf'),
('Nissan','S14','240SX',1995,1998,'240SX Base 15-inch production package','US',false,
 '15x6 ET40','15x6 ET40','195/60R15 front / 195/60R15 rear',
 '4x114.3','66.1mm','verified',
 'Nissan 1995 and 1998 240SX factory service manuals specify the Base 15x6JJ road wheel at ET40 with 195/60R15 tires; Nissan North America specifications identify the steel-wheel package with the Base trim. Hardware is 4x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nicoclub.com/service-manual?fsm=240sx%2F1995%2FPD.pdf ; https://www.nicoclub.com/tech/240sx/97-240sx-specs.pdf'),
('Nissan','S14','Silvia',1993,1998,'Silvia K''s Type S 16-inch production package','Japan',true,
 '16x6.5 ET45','16x6.5 ET45','205/55R16 front / 205/55R16 rear',
 '5x114.3','66.1mm','verified',
 'Nissan Heritage identifies the 1994 S14 Silvia K''s Type S production car with 205/55R16 tires. Japanese-market catalog data identifies its 16x6.5JJ production wheel at ET45. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nissan-global.com/EN/HERITAGE_COLLECTION/silvia_ks_s14.html ; https://img1.wsimg.com/blobby/go/c0bc7f33-b709-4f00-adb8-f84c27da1409/downloads/23698bf3-f2eb-4807-98f9-e88915d0c852/1994%20Nissan%20S14%20Silvia.pdf?ver=1737591199651');

delete from public.fitment_factory_baselines
where make='Nissan' and model='S14';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_s14_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='S14' and active
order by trim,is_default desc,year_start;
