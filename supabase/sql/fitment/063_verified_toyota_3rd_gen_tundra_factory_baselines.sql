-- Offset Lab Fitment
-- Pack 063: verified Toyota 3rd-generation Tundra factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='3rd Gen Tundra',year_start=2022,year_end=null
where make='Toyota' and model='3rd Gen Tundra';

update public.vehicle_trims set active=false
where make='Toyota' and model='3rd Gen Tundra'
  and trim in ('SR5 / Limited','TRD Pro / Capstone');

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','3rd Gen Tundra',source.trim,source.trim,true,source.sort_order
from (values
  ('SR5',1450),('Limited',1451),('TRD Pro',1452),('Capstone',1453)
) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='3rd Gen Tundra'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR5' then 1450 when 'Limited' then 1451
      when 'TRD Pro' then 1452 when 'Capstone' then 1453 else sort_order end
where make='Toyota' and model='3rd Gen Tundra'
  and trim in ('SR5','Limited','TRD Pro','Capstone');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case
    when source.style<>'oemplus' then source.front
    when target.trim='SR5' then '18x8.5 +50'
    when target.trim='Limited' then '20x9 +50'
    when target.trim='TRD Pro' then '18x9 +35'
    else '22x9 +50'
  end,
  case
    when source.style<>'oemplus' then source.rear
    when target.trim='SR5' then '18x8.5 +50'
    when target.trim='Limited' then '20x9 +50'
    when target.trim='TRD Pro' then '18x9 +35'
    else '22x9 +50'
  end,
  case
    when source.style<>'oemplus' then source.front_tire
    when target.trim='SR5' then '285/70R18'
    when target.trim='Limited' then '285/60R20'
    when target.trim='TRD Pro' then '295/65R18'
    else '285/50R22'
  end,
  case
    when source.style<>'oemplus' then source.rear_tire
    when target.trim='SR5' then '285/70R18'
    when target.trim='Limited' then '285/60R20'
    when target.trim='TRD Pro' then '295/65R18'
    else '285/50R22'
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR5' then 0 when 'Limited' then 4
    when 'TRD Pro' then 8 else 12 end,
  '6x139.7','95.1mm',
  case target.trim when 'SR5' then '18x7.5 ET60'
    when 'Limited' then '20x8 ET60' when 'TRD Pro' then '18x8.5 ET47.5'
    else '22x8 ET60' end,
  case target.trim when 'SR5' then '18x7.5 ET60'
    when 'Limited' then '20x8 ET60' when 'TRD Pro' then '18x8.5 ET47.5'
    else '22x8 ET60' end,
  case target.trim when 'SR5' then '265/70R18'
    when 'Limited' then '265/60R20' when 'TRD Pro' then '285/65R18'
    else '265/50R22' end
from public.fitment_presets source
join (values
  ('SR5','SR5 / Limited'),('Limited','SR5 / Limited'),
  ('TRD Pro','TRD Pro / Capstone'),('Capstone','TRD Pro / Capstone')
) as target(trim,source_trim) on target.source_trim=source.trim
where source.make='Toyota' and source.model='3rd Gen Tundra'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='3rd Gen Tundra'
  and trim in ('SR5 / Limited','TRD Pro / Capstone');

update public.fitment_presets
set bolt_pattern='6x139.7',center_bore='95.1mm',
    factory_front=case trim when 'SR5' then '18x7.5 ET60'
      when 'Limited' then '20x8 ET60' when 'TRD Pro' then '18x8.5 ET47.5'
      else '22x8 ET60' end,
    factory_rear=case trim when 'SR5' then '18x7.5 ET60'
      when 'Limited' then '20x8 ET60' when 'TRD Pro' then '18x8.5 ET47.5'
      else '22x8 ET60' end,
    factory_tire=case trim when 'SR5' then '265/70R18'
      when 'Limited' then '265/60R20' when 'TRD Pro' then '285/65R18'
      else '265/50R22' end
where make='Toyota' and model='3rd Gen Tundra'
  and trim in ('SR5','Limited','TRD Pro','Capstone') and active is not false;

create temp table if not exists toyota_3rd_gen_tundra_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_3rd_gen_tundra_verified_baselines;

insert into toyota_3rd_gen_tundra_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','3rd Gen Tundra','SR5',2022,null,'SR5 18-inch production package','US',true,
 '18x7.5 ET60','18x7.5 ET60','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 and 2025 Tundra eBrochures assign 18-inch silver-painted alloy wheels with 265/70R18 tires to SR5. Toyota owner/service data specifies 18x7.5J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tundra_ebrochure.pdf ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2025/tundra_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tundra/2023'),
('Toyota','3rd Gen Tundra','Limited',2022,null,'Limited 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','265/60R20 front / 265/60R20 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 and 2025 Tundra eBrochures assign 20-inch gray machined wheels with 265/60R20 tires to Limited. Toyota owner/service data specifies 20x8J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tundra_ebrochure.pdf ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2025/tundra_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tundra/2023'),
('Toyota','3rd Gen Tundra','TRD Pro',2022,null,'TRD Pro 18-inch BBS production package','US',true,
 '18x8.5 ET47.5','18x8.5 ET47.5','285/65R18 front / 285/65R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official Tundra eBrochures specify TRD Pro 18-inch forged BBS wheels with 285/65R18 Falken WILDPEAK tires. Toyota Genuine Parts PT960-34220-2F documents the 8.5-inch width and offset reduction from ET60 to ET47.5. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2025/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/product/trd-pro-alloy-wheel-flat-black-18-pt960342202f'),
('Toyota','3rd Gen Tundra','Capstone',2022,null,'Capstone 22-inch production package','US',true,
 '22x8 ET60','22x8 ET60','265/50R22 front / 265/50R22 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 and 2025 Tundra eBrochures assign 22-inch chrome machined wheels with 265/50R22 tires to Capstone. Toyota owner/service data specifies 22x8J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tundra_ebrochure.pdf ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2025/tundra_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tundra/2023');

delete from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Tundra';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_3rd_gen_tundra_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Tundra' and active
order by trim;
