-- Offset Lab Fitment
-- Pack 058: verified Nissan Z33 350Z factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2003,year_end=2008
where make='Nissan' and model='Z33';

update public.fitment_presets
set factory_front='18x8 ET30',factory_rear='18x8.5 ET33',
    factory_tire='225/45R18 front / 245/45R18 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='Z33'
  and trim in ('350Z Touring','Base','Base / Touring') and active is not false;

update public.fitment_presets
set factory_front='18x9 ET30',factory_rear='19x10 ET30',
    factory_tire='245/40R18 front / 265/35R19 rear',
    bolt_pattern='5x114.3',center_bore='66.1mm'
where make='Nissan' and model='Z33' and trim='Track' and active is not false;

create temp table if not exists nissan_z33_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table nissan_z33_verified_baselines;

insert into nissan_z33_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select 'Nissan','Z33',trim_name,2006,2008,
       '350Z standard 18-inch production package','US',true,
       '18x8 ET30','18x8.5 ET33','225/45R18 front / 245/45R18 rear',
       '5x114.3','66.1mm','verified',
       'The official 2008 Nissan 350Z owner manual specifies 18x8JJ ET30 front and 18x8.5JJ ET33 rear wheels with 225/45R18 and 245/45R18 tires. Nissan''s 2006 press kit states that this 18-inch package became standard for 2006. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2008/2008-ZCoupe-owner-manual.pdf ; https://usa.nissannews.com/en-US/releases/2006-nissan-350z-coupe-and-roadster-press-kit'
from (values ('350Z Touring'),('Base'),('Base / Touring')) trims(trim_name);

insert into nissan_z33_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select 'Nissan','Z33',trim_name,2003,2005,
       '350Z early 17-inch production package','US',false,
       '17x7.5 ET30','17x8 ET33','225/50R17 front / 235/50R17 rear',
       '5x114.3','66.1mm','verified',
       'The official 2003 Nissan 350Z owner manual specifies 17x7.5JJ ET30 front and 17x8JJ ET33 rear wheels with 225/50R17 and 235/50R17 tires. Nissan''s 2005 press kit identifies the 17-inch package on the base 350Z and applicable Touring automatic models. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://manuals.plus/m/baff60a32f21cc6d79b80b04d85c53ef0e9aa57d1f12b6e9bf839fd0e56189c3 ; https://usa.nissannews.com/en-US/releases/2005-nissan-350z-coupe-press-kit'
from (values ('350Z Touring'),('Base'),('Base / Touring')) trims(trim_name);

insert into nissan_z33_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Nissan','Z33','Track',2006,2006,'350Z Track RAYS staggered-diameter package','US',true,
 '18x9 ET30','19x10 ET30','245/40R18 front / 265/35R19 rear',
 '5x114.3','66.1mm','verified',
 'The official 2008 Nissan 350Z owner manual specifies the optional staggered package as 18x9JJ ET30 front and 19x10JJ ET30 rear with 245/40R18 and 265/35R19 tires. Nissan''s 2006 press kit identifies these RAYS forged wheels as standard on Track. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://owners.nissanusa.com/content/techpub/ManualsAndGuides/ZCoupe/2008/2008-ZCoupe-owner-manual.pdf ; https://usa.nissannews.com/en-US/releases/2006-nissan-350z-coupe-and-roadster-press-kit'),
('Nissan','Z33','Track',2003,2005,'350Z Track 18-inch forged production package','US',false,
 '18x8 ET30','18x8.5 ET33','225/45R18 front / 245/45R18 rear',
 '5x114.3','66.1mm','verified',
 'The official 2003 Nissan 350Z owner manual specifies the optional 18x8JJ ET30 front and 18x8.5JJ ET33 rear package with 225/45R18 and 245/45R18 tires. Nissan press material identifies the lightweight forged 18-inch package with Track. Hardware is 5x114.3, 66.1 mm with M12x1.25 lug nuts. Sources: https://manuals.plus/m/baff60a32f21cc6d79b80b04d85c53ef0e9aa57d1f12b6e9bf839fd0e56189c3 ; https://usa.nissannews.com/en-US/releases/2005-nissan-350z-coupe-press-kit');

delete from public.fitment_factory_baselines
where make='Nissan' and model='Z33';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from nissan_z33_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Nissan' and model='Z33' and active
order by trim,is_default desc,year_start;
