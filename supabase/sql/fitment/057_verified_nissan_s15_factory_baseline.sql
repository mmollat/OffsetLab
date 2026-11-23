-- Offset Lab Fitment
-- Pack 057: verified Nissan S15 Silvia Spec R factory baseline.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=1999,year_end=2002
where make='Nissan' and model='S15';

update public.fitment_presets
set factory_front='16x6.5 ET45',factory_rear='16x6.5 ET45',
    factory_tire='205/55R16 front / 205/55R16 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='S15' and trim='Spec R' and active is not false;

create temp table if not exists nissan_s15_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_s15_verified_baselines;

insert into nissan_s15_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','S15','Spec R',1999,2002,'Silvia Spec R 16-inch production package','Japan',true,
 '16x6.5 ET45','16x6.5 ET45','205/55R16 front / 205/55R16 rear',
 '5x114.3','66.1mm','verified',
 'Nissan Japanese-market Silvia brochures specify 205/55R16 89V tires with 16x6.5JJ aluminum road wheels for Spec R. Japanese catalog data confirms ET45, 5x114.3 and the 66.1 mm hub; hardware uses M12x1.25 lug nuts. Sources: https://www.nengun.com/oem/nissan/silvia-s15/silvia-december-2000-brochure ; https://www.nengun.com/oem/nissan/silvia-s15/silvia-may-2001-brochure ; https://www.nicoclub.com/service-manual?fsm_download=240sx%2FS15%2Ffwd.pdf');

delete from public.fitment_factory_baselines
where make='Nissan' and model='S15';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_s15_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='S15' and active
order by trim;
