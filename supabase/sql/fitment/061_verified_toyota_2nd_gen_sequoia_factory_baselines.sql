-- Offset Lab Fitment
-- Pack 061: verified Toyota 2nd-generation Sequoia factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='2nd Gen Sequoia',year_start=2008,year_end=2022
where make='Toyota' and model='2nd Gen Sequoia';

-- The combined choice masks the SR5 18-inch and Limited/Platinum 20-inch
-- production packages, so expose each grade separately.
update public.vehicle_trims
set active=false
where make='Toyota' and model='2nd Gen Sequoia'
  and trim='SR5 / Limited / Platinum';

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','2nd Gen Sequoia',source.trim,source.display_name,true,source.sort_order
from (values
  ('SR5','SR5',1460),
  ('Limited','Limited',1461),
  ('Platinum','Platinum',1462)
) as source(trim,display_name,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='2nd Gen Sequoia'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR5' then 1460 when 'Limited' then 1461
                             when 'Platinum' then 1462 else sort_order end
where make='Toyota' and model='2nd Gen Sequoia'
  and trim in ('SR5','Limited','Platinum');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select
  source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case
    when source.style='oemplus' and target.trim in ('Limited','Platinum') then '20x9 +50'
    when source.style='oemplus' then '18x9 +50'
    else source.front
  end,
  case
    when source.style='oemplus' and target.trim in ('Limited','Platinum') then '20x9 +50'
    when source.style='oemplus' then '18x9 +50'
    else source.rear
  end,
  case
    when source.style='oemplus' and target.trim in ('Limited','Platinum') then '285/55R20'
    when source.style='oemplus' then '285/65R18'
    else source.front_tire
  end,
  case
    when source.style='oemplus' and target.trim in ('Limited','Platinum') then '285/55R20'
    when source.style='oemplus' then '285/65R18'
    else source.rear_tire
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR5' then 0 when 'Limited' then 4 else 8 end,
  '5x150','110.0mm',
  case target.trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
  case target.trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
  case target.trim when 'SR5' then '275/65R18' else '275/55R20' end
from public.fitment_presets source
cross join (values ('SR5'),('Limited'),('Platinum')) as target(trim)
where source.make='Toyota' and source.model='2nd Gen Sequoia'
  and source.trim='SR5 / Limited / Platinum' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets
set active=false
where make='Toyota' and model='2nd Gen Sequoia'
  and trim='SR5 / Limited / Platinum';

update public.fitment_presets
set bolt_pattern='5x150',center_bore='110.0mm',
    factory_front=case trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
    factory_rear=case trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
    factory_tire=case trim when 'SR5' then '275/65R18' else '275/55R20' end,
    front=case
      when style='oemplus' and trim in ('Limited','Platinum') then '20x9 +50'
      when style='oemplus' and trim='SR5' then '18x9 +50'
      else front
    end,
    rear=case
      when style='oemplus' and trim in ('Limited','Platinum') then '20x9 +50'
      when style='oemplus' and trim='SR5' then '18x9 +50'
      else rear
    end,
    front_tire=case
      when style='oemplus' and trim in ('Limited','Platinum') then '285/55R20'
      when style='oemplus' and trim='SR5' then '285/65R18'
      else front_tire
    end,
    rear_tire=case
      when style='oemplus' and trim in ('Limited','Platinum') then '285/55R20'
      when style='oemplus' and trim='SR5' then '285/65R18'
      else rear_tire
    end
where make='Toyota' and model='2nd Gen Sequoia'
  and trim in ('SR5','Limited','Platinum') and active is not false;

create temp table if not exists toyota_2nd_gen_sequoia_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_2nd_gen_sequoia_verified_baselines;

insert into toyota_2nd_gen_sequoia_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','2nd Gen Sequoia','SR5',2008,2022,
 'SR5 18-inch production package','US',true,
 '18x8 ET60','18x8 ET60','275/65R18 front / 275/65R18 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Sequoia eBrochure and sourcebook specify the SR5 18-inch 5-spoke alloy wheel with P275/65R18 tires. Toyota EPC service-wheel records identify 18x8 ET60; the platform uses 5x150, a 110 mm hub, and M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/sequoia_ebrochure.pdf ; https://engage.toyota.com/static/sourcebooks/2021_sequoia_en_SourceBook.pdf'),
('Toyota','2nd Gen Sequoia','Limited',2008,2022,
 'Limited 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','275/55R20 front / 275/55R20 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Sequoia eBrochure and sourcebook assign the Limited 20-inch machined split-spoke wheel with P275/55R20 tires. Toyota EPC service-wheel records identify 20x8 ET60; hardware is 5x150, 110 mm with M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/sequoia_ebrochure.pdf ; https://engage.toyota.com/static/sourcebooks/2021_sequoia_en_SourceBook.pdf'),
('Toyota','2nd Gen Sequoia','Platinum',2008,2022,
 'Platinum 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','275/55R20 front / 275/55R20 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Sequoia eBrochure and sourcebook assign the Platinum 20-inch machined split-spoke wheel with P275/55R20 tires. Toyota EPC service-wheel records identify 20x8 ET60; hardware is 5x150, 110 mm with M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/sequoia_ebrochure.pdf ; https://engage.toyota.com/static/sourcebooks/2021_sequoia_en_SourceBook.pdf');

delete from public.fitment_factory_baselines
where make='Toyota' and model='2nd Gen Sequoia';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_2nd_gen_sequoia_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='2nd Gen Sequoia' and active
order by trim;
