-- Offset Lab Fitment
-- Pack 055: verified Nissan S13 factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=1988,year_end=1994
where make='Nissan' and model='S13';

update public.fitment_presets
set factory_front='15x6 ET40',factory_rear='15x6 ET40',
    factory_tire='195/60R15 front / 195/60R15 rear',
    bolt_pattern='4x114.3',center_bore='66.1mm'
where make='Nissan' and model='S13' and trim in ('240SX','Silvia')
  and active is not false;

create temp table if not exists nissan_s13_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_s13_verified_baselines;

insert into nissan_s13_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','S13','240SX',1989,1994,'240SX standard 15-inch production package','US',true,
 '15x6 ET40','15x6 ET40','195/60R15 front / 195/60R15 rear',
 '4x114.3','66.1mm','verified',
 'The Nissan 1989 and 1991 240SX factory service manuals specify 15x6JJ road wheels at ET40 with 195/60R15 tires; 205/60R15 is listed as an optional tire package. Hardware is 4x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://gomotorsusa.com/docs/13/1989_nissan_240sx_service_manual.pdf ; https://legacynissantechinfo.tweddletech.net/nmatechinfo/deptog.aspx?dept_id=98'),
('Nissan','S13','240SX',1989,1994,'240SX optional 205-width tire package','US',false,
 '15x6 ET40','15x6 ET40','205/60R15 front / 205/60R15 rear',
 '4x114.3','66.1mm','verified',
 'The Nissan 1989 and 1991 240SX factory service manuals specify 15x6JJ road wheels at ET40 and list 205/60R15 as an optional tire size. Hardware is 4x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://gomotorsusa.com/docs/13/1989_nissan_240sx_service_manual.pdf ; https://legacynissantechinfo.tweddletech.net/nmatechinfo/deptog.aspx?dept_id=98'),
('Nissan','S13','Silvia',1988,1993,'Silvia K''s S-pack 15-inch production package','Japan',true,
 '15x6 ET40','15x6 ET40','195/60R15 front / 195/60R15 rear',
 '4x114.3','66.1mm','verified',
 'Nissan Heritage identifies the 1989 S13 Silvia K''s S-pack production car with 195/60R15 tires front and rear. Nissan S13 factory service documentation specifies the matching 15x6JJ road wheel at ET40. Hardware is 4x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://www.nissan-global.com/EN/HERITAGE_COLLECTION/silvia_ks.html ; https://gomotorsusa.com/docs/13/1989_nissan_240sx_service_manual.pdf');

delete from public.fitment_factory_baselines
where make='Nissan' and model='S13';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_s13_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='S13' and active
order by trim,is_default desc,year_start;
