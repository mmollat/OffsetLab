-- Offset Lab Fitment
-- Pack 065: verified Toyota 4th-generation Tacoma factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='4th Gen Tacoma',year_start=2024,year_end=null
where make='Toyota' and model='4th Gen Tacoma';

update public.vehicle_trims set active=false
where make='Toyota' and model='4th Gen Tacoma'
  and trim in ('SR / SR5','TRD Pro / Trailhunter');

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','4th Gen Tacoma',source.trim,source.trim,true,source.sort_order
from (values
  ('SR',1430),('SR5',1431),('TRD Pro',1434),('Trailhunter',1435)
) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='4th Gen Tacoma'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR' then 1430 when 'SR5' then 1431
      when 'TRD Sport' then 1432 when 'TRD Off-Road' then 1433
      when 'TRD Pro' then 1434 when 'Trailhunter' then 1435 else sort_order end
where make='Toyota' and model='4th Gen Tacoma'
  and trim in ('SR','SR5','TRD Sport','TRD Off-Road','TRD Pro','Trailhunter');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case
    when source.style<>'oemplus' then source.front
    when target.trim in ('SR','SR5') then '17x8 +45'
    else '18x9 +10'
  end,
  case
    when source.style<>'oemplus' then source.rear
    when target.trim in ('SR','SR5') then '17x8 +45'
    else '18x9 +10'
  end,
  case
    when source.style<>'oemplus' then source.front_tire
    when target.trim in ('SR','SR5') then '265/70R17'
    else '275/70R18'
  end,
  case
    when source.style<>'oemplus' then source.rear_tire
    when target.trim in ('SR','SR5') then '265/70R17'
    else '275/70R18'
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR' then 0 when 'SR5' then 4
    when 'TRD Pro' then 8 else 12 end,
  '6x139.7','95.1mm',
  case when target.trim in ('SR','SR5') then '17x7 ET60' else '18x8.5 ET20' end,
  case when target.trim in ('SR','SR5') then '17x7 ET60' else '18x8.5 ET20' end,
  case when target.trim in ('SR','SR5') then '245/70R17' else '265/70R18' end
from public.fitment_presets source
join (values
  ('SR','SR / SR5'),('SR5','SR / SR5'),
  ('TRD Pro','TRD Pro / Trailhunter'),('Trailhunter','TRD Pro / Trailhunter')
) as target(trim,source_trim) on target.source_trim=source.trim
where source.make='Toyota' and source.model='4th Gen Tacoma'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='4th Gen Tacoma'
  and trim in ('SR / SR5','TRD Pro / Trailhunter');

update public.fitment_presets
set bolt_pattern='6x139.7',center_bore='95.1mm',
    factory_front=case trim when 'SR' then '17x7 ET60'
      when 'SR5' then '17x7 ET60' when 'TRD Sport' then '18x7.5 ET55'
      when 'TRD Off-Road' then '17x7.5 ET55' else '18x8.5 ET20' end,
    factory_rear=case trim when 'SR' then '17x7 ET60'
      when 'SR5' then '17x7 ET60' when 'TRD Sport' then '18x7.5 ET55'
      when 'TRD Off-Road' then '17x7.5 ET55' else '18x8.5 ET20' end,
    factory_tire=case trim when 'SR' then '245/70R17'
      when 'SR5' then '245/70R17' when 'TRD Sport' then '265/65R18'
      when 'TRD Off-Road' then '265/70R17' else '265/70R18' end,
    front=case
      when style<>'oemplus' then front
      when trim in ('SR','SR5') then '17x8 +45'
      when trim='TRD Sport' then '18x8 +45'
      when trim='TRD Off-Road' then '17x8 +40'
      else '18x9 +10' end,
    rear=case
      when style<>'oemplus' then rear
      when trim in ('SR','SR5') then '17x8 +45'
      when trim='TRD Sport' then '18x8 +45'
      when trim='TRD Off-Road' then '17x8 +40'
      else '18x9 +10' end,
    front_tire=case
      when style<>'oemplus' then front_tire
      when trim in ('SR','SR5') then '265/70R17'
      when trim='TRD Sport' then '275/65R18'
      when trim='TRD Off-Road' then '275/70R17'
      else '275/70R18' end,
    rear_tire=case
      when style<>'oemplus' then rear_tire
      when trim in ('SR','SR5') then '265/70R17'
      when trim='TRD Sport' then '275/65R18'
      when trim='TRD Off-Road' then '275/70R17'
      else '275/70R18' end
where make='Toyota' and model='4th Gen Tacoma'
  and trim in ('SR','SR5','TRD Sport','TRD Off-Road','TRD Pro','Trailhunter')
  and active is not false;

create temp table if not exists toyota_4th_gen_tacoma_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_4th_gen_tacoma_verified_baselines;

insert into toyota_4th_gen_tacoma_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','4th Gen Tacoma','SR',2024,null,'SR 17-inch production package','US',true,
 '17x7 ET60','17x7 ET60','245/70R17 front / 245/70R17 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure specifies SR 17-inch steel wheels with 245/70R17 tires. Toyota owner/service and EPC records identify 17x7J ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2024'),
('Toyota','4th Gen Tacoma','SR5',2024,null,'SR5 17-inch production package','US',true,
 '17x7 ET60','17x7 ET60','245/70R17 front / 245/70R17 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure specifies SR5 17-inch styled-alloy wheels with 245/70R17 tires. Toyota owner/service and EPC records identify 17x7J ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2024'),
('Toyota','4th Gen Tacoma','TRD Sport',2024,null,'TRD Sport 18-inch production package','US',true,
 '18x7.5 ET55','18x7.5 ET55','265/65R18 front / 265/65R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure specifies TRD Sport 18-inch alloy wheels with 265/65R18 tires. Toyota service-wheel records identify 18x7.5J ET55. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://autoparts.toyota.com/products/product/alloy-wheel-ptr56352402f'),
('Toyota','4th Gen Tacoma','TRD Off-Road',2024,null,'TRD Off-Road 17-inch i-FORCE package','US',true,
 '17x7.5 ET55','17x7.5 ET55','265/70R17 front / 265/70R17 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure specifies the i-FORCE TRD Off-Road wheel/tire package with 265/70R17 tires. Toyota service-wheel records identify 17x7.5J ET55. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2024'),
('Toyota','4th Gen Tacoma','TRD Pro',2024,null,'TRD Pro 18-inch production package','US',true,
 '18x8.5 ET20','18x8.5 ET20','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure and newsroom specify TRD Pro 18-inch black wheels with 33-inch Goodyear Territory R/T tires. Toyota Genuine Parts PT946-35240-2F specifies 18x8.5J ET20, 6x139.7 and a 95 mm hub. The production tire size is 265/70R18 and hardware is M14x1.5. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://autoparts.toyota.com/products/product/alloy-wheel-pt946352402f'),
('Toyota','4th Gen Tacoma','Trailhunter',2024,null,'Trailhunter 18-inch production package','US',true,
 '18x8.5 ET20','18x8.5 ET20','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2024 Tacoma eBrochure and newsroom specify Trailhunter 18-inch bronze wheels with 33-inch Goodyear Territory R/T tires. Toyota Genuine Parts PTR56-35240-5F specifies 18x8.5J ET20, 6x139.7 and a 95 mm hub. The production tire size is 265/70R18 and hardware is M14x1.5. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/tacoma_ebrochure.pdf ; https://autoparts.toyota.com/products/product/alloy-wheel-ptr56352405f');

delete from public.fitment_factory_baselines
where make='Toyota' and model='4th Gen Tacoma';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_4th_gen_tacoma_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='4th Gen Tacoma' and active
order by trim;
