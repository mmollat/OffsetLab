-- Offset Lab Fitment
-- Pack 066: verified Toyota 6th-generation 4Runner factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='6th Gen 4Runner',year_start=2025,year_end=null
where make='Toyota' and model='6th Gen';

update public.vehicle_trims set active=false
where make='Toyota' and model='6th Gen'
  and trim in ('SR5 / Limited','TRD Pro / Trailhunter');

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','6th Gen',source.trim,source.trim,true,source.sort_order
from (values
  ('SR5',1410),('Limited',1411),('TRD Pro',1413),('Trailhunter',1414)
) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='6th Gen'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR5' then 1410 when 'Limited' then 1411
      when 'TRD Off-Road' then 1412 when 'TRD Pro' then 1413
      when 'Trailhunter' then 1414 else sort_order end
where make='Toyota' and model='6th Gen'
  and trim in ('SR5','Limited','TRD Off-Road','TRD Pro','Trailhunter');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case
    when source.style<>'oemplus' then source.front
    when target.trim='SR5' then '17x8 +45'
    when target.trim='Limited' then '20x9 +45'
    else '18x8.5 +10'
  end,
  case
    when source.style<>'oemplus' then source.rear
    when target.trim='SR5' then '17x8 +45'
    when target.trim='Limited' then '20x9 +45'
    else '18x8.5 +10'
  end,
  case
    when source.style<>'oemplus' then source.front_tire
    when target.trim='SR5' then '275/70R17'
    when target.trim='Limited' then '275/55R20'
    else '275/70R18'
  end,
  case
    when source.style<>'oemplus' then source.rear_tire
    when target.trim='SR5' then '275/70R17'
    when target.trim='Limited' then '275/55R20'
    else '275/70R18'
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR5' then 0 when 'Limited' then 4
    when 'TRD Pro' then 8 else 12 end,
  '6x139.7','95.1mm',
  case target.trim when 'SR5' then '17x7 ET55'
    when 'Limited' then '20x8 ET55' else '18x7.5 ET20' end,
  case target.trim when 'SR5' then '17x7 ET55'
    when 'Limited' then '20x8 ET55' else '18x7.5 ET20' end,
  case target.trim when 'SR5' then '265/70R17'
    when 'Limited' then '265/55R20' else '265/70R18' end
from public.fitment_presets source
join (values
  ('SR5','SR5 / Limited'),('Limited','SR5 / Limited'),
  ('TRD Pro','TRD Pro / Trailhunter'),('Trailhunter','TRD Pro / Trailhunter')
) as target(trim,source_trim) on target.source_trim=source.trim
where source.make='Toyota' and source.model='6th Gen'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='6th Gen'
  and trim in ('SR5 / Limited','TRD Pro / Trailhunter');

update public.fitment_presets
set bolt_pattern='6x139.7',center_bore='95.1mm',
    factory_front=case trim when 'SR5' then '17x7 ET55'
      when 'Limited' then '20x8 ET55' when 'TRD Off-Road' then '18x7.5 ET55'
      else '18x7.5 ET20' end,
    factory_rear=case trim when 'SR5' then '17x7 ET55'
      when 'Limited' then '20x8 ET55' when 'TRD Off-Road' then '18x7.5 ET55'
      else '18x7.5 ET20' end,
    factory_tire=case trim when 'SR5' then '265/70R17'
      when 'Limited' then '265/55R20' else '265/70R18' end,
    front=case
      when style<>'oemplus' then front
      when trim='SR5' then '17x8 +45'
      when trim='Limited' then '20x9 +45'
      when trim='TRD Off-Road' then '18x8 +45'
      else '18x8.5 +10' end,
    rear=case
      when style<>'oemplus' then rear
      when trim='SR5' then '17x8 +45'
      when trim='Limited' then '20x9 +45'
      when trim='TRD Off-Road' then '18x8 +45'
      else '18x8.5 +10' end,
    front_tire=case
      when style<>'oemplus' then front_tire
      when trim='SR5' then '275/70R17'
      when trim='Limited' then '275/55R20'
      else '275/70R18' end,
    rear_tire=case
      when style<>'oemplus' then rear_tire
      when trim='SR5' then '275/70R17'
      when trim='Limited' then '275/55R20'
      else '275/70R18' end
where make='Toyota' and model='6th Gen'
  and trim in ('SR5','Limited','TRD Off-Road','TRD Pro','Trailhunter')
  and active is not false;

create temp table if not exists toyota_6th_gen_4runner_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_6th_gen_4runner_verified_baselines;

insert into toyota_6th_gen_4runner_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','6th Gen','SR5',2025,null,'SR5 17-inch production package','US',true,
 '17x7 ET55','17x7 ET55','265/70R17 front / 265/70R17 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2025 4Runner sales guide specifies SR5 17-inch alloy wheels with 265/70R17 tires. Toyota Genuine Parts identifies SR5 wheel 42611-35640; Toyota EPC/service-wheel records specify 17x7J ET55. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://engage.toyota.com/static/articles/2025_4runner_sales_consultant_guide/2025_4Runner_Sales_Consultant_Guide.pdf ; https://autoparts.toyota.com/products/product/wheel-disc-4261135640'),
('Toyota','6th Gen','Limited',2025,null,'Limited 20-inch production package','US',true,
 '20x8 ET55','20x8 ET55','265/55R20 front / 265/55R20 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2025 4Runner sales guide specifies Limited 20-inch alloy wheels with 265/55R20 tires. Toyota Genuine Parts identifies Limited wheel 42611-35690; Toyota EPC/service-wheel records specify 20x8J ET55. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Sources: https://engage.toyota.com/static/articles/2025_4runner_sales_consultant_guide/2025_4Runner_Sales_Consultant_Guide.pdf ; https://parts.olathetoyota.com/oem-parts/toyota-wheel-alloy-4261135690'),
('Toyota','6th Gen','TRD Off-Road',2025,null,'TRD Off-Road 18-inch production package','US',true,
 '18x7.5 ET55','18x7.5 ET55','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2025 4Runner sales guide specifies TRD Off-Road 18-inch alloy wheels with 265/70R18 all-terrain tires. Toyota EPC/service-wheel records specify 18x7.5J ET55. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Source: https://engage.toyota.com/static/articles/2025_4runner_sales_consultant_guide/2025_4Runner_Sales_Consultant_Guide.pdf'),
('Toyota','6th Gen','TRD Pro',2025,null,'TRD Pro 18-inch production package','US',true,
 '18x7.5 ET20','18x7.5 ET20','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2025 4Runner sales guide specifies TRD Pro 18-inch black alloy wheels with 265/70R18 Toyo Open Country A/T III tires. Toyota EPC/service-wheel records specify 18x7.5J ET20. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Source: https://engage.toyota.com/static/articles/2025_4runner_sales_consultant_guide/2025_4Runner_Sales_Consultant_Guide.pdf'),
('Toyota','6th Gen','Trailhunter',2025,null,'Trailhunter 18-inch production package','US',true,
 '18x7.5 ET20','18x7.5 ET20','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2025 4Runner sales guide specifies Trailhunter 18-inch bronze alloy wheels with 265/70R18 Toyo Open Country A/T III tires. Toyota EPC/service-wheel records specify 18x7.5J ET20. Hardware is 6x139.7, 95.1 mm with M14x1.5 flat-seat lug nuts. Source: https://engage.toyota.com/static/articles/2025_4runner_sales_consultant_guide/2025_4Runner_Sales_Consultant_Guide.pdf');

delete from public.fitment_factory_baselines
where make='Toyota' and model='6th Gen';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_6th_gen_4runner_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='6th Gen' and active
order by trim;
