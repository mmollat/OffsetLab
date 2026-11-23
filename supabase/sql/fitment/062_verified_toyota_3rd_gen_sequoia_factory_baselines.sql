-- Offset Lab Fitment
-- Pack 062: verified Toyota 3rd-generation Sequoia factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='3rd Gen Sequoia',year_start=2023,year_end=null
where make='Toyota' and model='3rd Gen Sequoia';

update public.vehicle_trims set active=false
where make='Toyota' and model='3rd Gen Sequoia'
  and trim in ('SR5 / Limited / Platinum','TRD Pro / Capstone');

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','3rd Gen Sequoia',source.trim,source.trim,true,source.sort_order
from (values
  ('SR5',1470),('Limited',1471),('Platinum',1472),
  ('TRD Pro',1473),('Capstone',1474)
) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='3rd Gen Sequoia'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR5' then 1470 when 'Limited' then 1471
      when 'Platinum' then 1472 when 'TRD Pro' then 1473
      when 'Capstone' then 1474 else sort_order end
where make='Toyota' and model='3rd Gen Sequoia'
  and trim in ('SR5','Limited','Platinum','TRD Pro','Capstone');

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
    when target.trim in ('Limited','Platinum') then '20x9 +50'
    when target.trim='TRD Pro' then '18x9 +35'
    else '22x9 +50'
  end,
  case
    when source.style<>'oemplus' then source.rear
    when target.trim='SR5' then '18x8.5 +50'
    when target.trim in ('Limited','Platinum') then '20x9 +50'
    when target.trim='TRD Pro' then '18x9 +35'
    else '22x9 +50'
  end,
  case
    when source.style<>'oemplus' then source.front_tire
    when target.trim='SR5' then '285/70R18'
    when target.trim in ('Limited','Platinum') then '285/60R20'
    when target.trim='TRD Pro' then '295/65R18'
    else '285/50R22'
  end,
  case
    when source.style<>'oemplus' then source.rear_tire
    when target.trim='SR5' then '285/70R18'
    when target.trim in ('Limited','Platinum') then '285/60R20'
    when target.trim='TRD Pro' then '295/65R18'
    else '285/50R22'
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR5' then 0 when 'Limited' then 4
    when 'Platinum' then 8 when 'TRD Pro' then 12 else 16 end,
  '6x139.7','95.1mm',
  case target.trim when 'SR5' then '18x7.5 ET60'
    when 'Limited' then '20x8 ET60' when 'Platinum' then '20x8 ET60'
    when 'TRD Pro' then '18x8.5 ET47.5' else '22x8 ET60' end,
  case target.trim when 'SR5' then '18x7.5 ET60'
    when 'Limited' then '20x8 ET60' when 'Platinum' then '20x8 ET60'
    when 'TRD Pro' then '18x8.5 ET47.5' else '22x8 ET60' end,
  case target.trim when 'SR5' then '265/70R18'
    when 'Limited' then '265/60R20' when 'Platinum' then '265/60R20'
    when 'TRD Pro' then '285/65R18' else '265/50R22' end
from public.fitment_presets source
join (values
  ('SR5','SR5 / Limited / Platinum'),
  ('Limited','SR5 / Limited / Platinum'),
  ('Platinum','SR5 / Limited / Platinum'),
  ('TRD Pro','TRD Pro / Capstone'),
  ('Capstone','TRD Pro / Capstone')
) as target(trim,source_trim) on target.source_trim=source.trim
where source.make='Toyota' and source.model='3rd Gen Sequoia'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='3rd Gen Sequoia'
  and trim in ('SR5 / Limited / Platinum','TRD Pro / Capstone');

update public.fitment_presets
set bolt_pattern='6x139.7',center_bore='95.1mm',
    factory_front=case trim when 'SR5' then '18x7.5 ET60'
      when 'Limited' then '20x8 ET60' when 'Platinum' then '20x8 ET60'
      when 'TRD Pro' then '18x8.5 ET47.5' else '22x8 ET60' end,
    factory_rear=case trim when 'SR5' then '18x7.5 ET60'
      when 'Limited' then '20x8 ET60' when 'Platinum' then '20x8 ET60'
      when 'TRD Pro' then '18x8.5 ET47.5' else '22x8 ET60' end,
    factory_tire=case trim when 'SR5' then '265/70R18'
      when 'Limited' then '265/60R20' when 'Platinum' then '265/60R20'
      when 'TRD Pro' then '285/65R18' else '265/50R22' end
where make='Toyota' and model='3rd Gen Sequoia'
  and trim in ('SR5','Limited','Platinum','TRD Pro','Capstone')
  and active is not false;

create temp table if not exists toyota_3rd_gen_sequoia_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_3rd_gen_sequoia_verified_baselines;

insert into toyota_3rd_gen_sequoia_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','3rd Gen Sequoia','SR5',2023,null,'SR5 18-inch production package','US',true,
 '18x7.5 ET60','18x7.5 ET60','265/70R18 front / 265/70R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 Sequoia eBrochure assigns 18-inch styled-alloy wheels with 265/70R18 tires to SR5. Toyota owner/service data specifies the 18x7.5J wheel; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/sequoia_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/sequoia/2023'),
('Toyota','3rd Gen Sequoia','Limited',2023,null,'Limited 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','265/60R20 front / 265/60R20 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 Sequoia eBrochure assigns 20-inch dark-gray machined wheels with 265/60R20 tires to Limited. Toyota owner/service data specifies 20x8J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/sequoia_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/sequoia/2023'),
('Toyota','3rd Gen Sequoia','Platinum',2023,null,'Platinum 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','265/60R20 front / 265/60R20 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 Sequoia eBrochure assigns 20-inch machined black wheels with 265/60R20 tires to Platinum. Toyota owner/service data specifies 20x8J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/sequoia_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/sequoia/2023'),
('Toyota','3rd Gen Sequoia','TRD Pro',2023,null,'TRD Pro 18-inch BBS production package','US',true,
 '18x8.5 ET47.5','18x8.5 ET47.5','285/65R18 front / 285/65R18 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 Sequoia eBrochure specifies TRD Pro 18-inch forged BBS wheels with 285/65R18 Falken WILDPEAK tires. Toyota Genuine Parts PT960-34220-2F documents the 8.5-inch width and offset reduction from ET60 to ET47.5. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/sequoia_ebrochure.pdf ; https://autoparts.toyota.com/products/product/trd-pro-alloy-wheel-flat-black-18-pt960342202f'),
('Toyota','3rd Gen Sequoia','Capstone',2023,null,'Capstone 22-inch production package','US',true,
 '22x8 ET60','22x8 ET60','265/50R22 front / 265/50R22 rear',
 '6x139.7','95.1mm','verified',
 'Toyota''s official 2023 Sequoia eBrochure assigns 22-inch dark-chrome machined wheels with 265/50R22 tires to Capstone. Toyota owner/service data specifies 22x8J; Toyota EPC service-wheel records specify ET60. Hardware is 6x139.7, 95.1 mm with M14x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/sequoia_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/sequoia/2023');

delete from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Sequoia';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_3rd_gen_sequoia_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Sequoia' and active
order by trim;
