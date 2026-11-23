-- Offset Lab Fitment
-- Pack 060: verified Toyota 2nd-generation Tundra factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='2nd Gen Tundra',year_start=2007,year_end=2021
where make='Toyota' and model='2nd Gen Tundra';

-- SR5 and Limited use different production wheel/tire packages, so the old
-- combined trim cannot present one accurate factory baseline.
update public.vehicle_trims
set active=false
where make='Toyota' and model='2nd Gen Tundra' and trim='SR5 / Limited';

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','2nd Gen Tundra',source.trim,source.display_name,true,source.sort_order
from (values
  ('SR5','SR5',14400),
  ('Limited','Limited',14401)
) as source(trim,display_name,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='2nd Gen Tundra'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR5' then 14400 when 'Limited' then 14401 else sort_order end
where make='Toyota' and model='2nd Gen Tundra' and trim in ('SR5','Limited');

-- Preserve the existing truck-oriented recommendations, but separate the
-- restrained OEM+ step from the actual production package.
insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select
  source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case
    when source.style='oemplus' and target.trim='Limited' then '20x9 +50'
    when source.style='oemplus' then '18x9 +50'
    else source.front
  end,
  case
    when source.style='oemplus' and target.trim='Limited' then '20x9 +50'
    when source.style='oemplus' then '18x9 +50'
    else source.rear
  end,
  case
    when source.style='oemplus' and target.trim='Limited' then '285/55R20'
    when source.style='oemplus' then '285/65R18'
    else source.front_tire
  end,
  case
    when source.style='oemplus' and target.trim='Limited' then '285/55R20'
    when source.style='oemplus' then '285/65R18'
    else source.rear_tire
  end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  case target.trim when 'SR5' then source.sort_order else source.sort_order+4 end,
  '5x150','110.0mm',
  case target.trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
  case target.trim when 'SR5' then '18x8 ET60' else '20x8 ET60' end,
  case target.trim when 'SR5' then '255/70R18' else '275/55R20' end
from public.fitment_presets source
cross join (values ('SR5'),('Limited')) as target(trim)
where source.make='Toyota' and source.model='2nd Gen Tundra'
  and source.trim='SR5 / Limited' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets
set active=false
where make='Toyota' and model='2nd Gen Tundra' and trim='SR5 / Limited';

update public.fitment_presets
set bolt_pattern='5x150',center_bore='110.0mm',
    factory_front=case trim
      when 'SR5' then '18x8 ET60'
      when 'Limited' then '20x8 ET60'
      when 'TRD Pro' then '18x8 ET60'
    end,
    factory_rear=case trim
      when 'SR5' then '18x8 ET60'
      when 'Limited' then '20x8 ET60'
      when 'TRD Pro' then '18x8 ET60'
    end,
    factory_tire=case trim
      when 'SR5' then '255/70R18'
      when 'Limited' then '275/55R20'
      when 'TRD Pro' then '275/65R18'
    end,
    front=case
      when style='oemplus' and trim='Limited' then '20x9 +50'
      when style='oemplus' and trim in ('SR5','TRD Pro') then '18x9 +50'
      else front
    end,
    rear=case
      when style='oemplus' and trim='Limited' then '20x9 +50'
      when style='oemplus' and trim in ('SR5','TRD Pro') then '18x9 +50'
      else rear
    end,
    front_tire=case
      when style='oemplus' and trim='Limited' then '285/55R20'
      when style='oemplus' and trim in ('SR5','TRD Pro') then '285/65R18'
      else front_tire
    end,
    rear_tire=case
      when style='oemplus' and trim='Limited' then '285/55R20'
      when style='oemplus' and trim in ('SR5','TRD Pro') then '285/65R18'
      else rear_tire
    end
where make='Toyota' and model='2nd Gen Tundra'
  and trim in ('SR5','Limited','TRD Pro') and active is not false;

create temp table if not exists toyota_2nd_gen_tundra_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_2nd_gen_tundra_verified_baselines;

insert into toyota_2nd_gen_tundra_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','2nd Gen Tundra','SR5',2014,2021,
 'SR5 18-inch styled-steel production package','US',true,
 '18x8 ET60','18x8 ET60','255/70R18 front / 255/70R18 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Tundra eBrochure assigns 18-inch styled-steel wheels with P255/70R18 tires to SR5. Toyota EPC identifies the production wheel as 18x8; OEM service wheel 42611-0C160 is stamped ET60. The platform uses 5x150, a 110 mm hub, and M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/product/wheel-disc-426110c160'),
('Toyota','2nd Gen Tundra','SR5',2014,2021,
 'SR5 18-inch alloy / TRD Off-Road package','US',false,
 '18x8 ET60','18x8 ET60','275/65R18 front / 275/65R18 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 eBrochure lists the optional SR5 18-inch 5-spoke alloy and TRD Off-Road wheels with P275/65R18 tires. Toyota EPC identifies the wheel as 18x8 ET60; hardware is 5x150, 110 mm with M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/product/wheel-disc-426110c160'),
('Toyota','2nd Gen Tundra','Limited',2014,2021,
 'Limited 20-inch production package','US',true,
 '20x8 ET60','20x8 ET60','275/55R20 front / 275/55R20 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Tundra eBrochure specifies the Limited-grade 20-inch split 5-spoke wheel with P275/55R20 tires. Toyota EPC identifies the production wheel as 20x8 ET60; hardware is 5x150, 110 mm with M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/category/wheels-related-parts-wheels?model_year=2021&series_name=TUNDRA'),
('Toyota','2nd Gen Tundra','Limited',2014,2021,
 'Limited TRD Off-Road 18-inch package','US',false,
 '18x8 ET60','18x8 ET60','275/65R18 front / 275/65R18 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Tundra eBrochure lists the TRD Off-Road package for Limited and specifies its 18-inch split 5-spoke wheels with P275/65R18 tires. Toyota EPC records the production wheel as 18x8 ET60; hardware is 5x150, 110 mm with M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/product/wheel-disc-426110c160'),
('Toyota','2nd Gen Tundra','TRD Pro',2015,2021,
 'TRD Pro 18-inch BBS forged production package','US',true,
 '18x8 ET60','18x8 ET60','275/65R18 front / 275/65R18 rear',
 '5x150','110.0mm','verified',
 'Toyota''s official 2021 Tundra eBrochure specifies 18-inch BBS forged wheels with Michelin P275/65R18 tires for TRD Pro. Toyota Genuine Parts service wheel PT960-34190-F2 specifies 18x8 ET60 and 5x150; the hub is 110 mm and uses M14x1.5 washer-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2021/tundra_ebrochure.pdf ; https://autoparts.toyota.com/products/product/tndra-seq-pro-whl-pt96034190f2');

delete from public.fitment_factory_baselines
where make='Toyota' and model='2nd Gen Tundra';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_2nd_gen_tundra_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='2nd Gen Tundra' and active
order by trim,is_default desc,package_name;
