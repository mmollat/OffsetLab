-- Offset Lab Fitment
-- Pack 068: verified Toyota GR Corolla factory baselines.
-- Splits the combined grade and retires its duplicate trim records.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='E210 GR Corolla',year_start=2023,year_end=null
where make='Toyota' and model='GR Corolla';

update public.vehicle_trims set active=false
where make='Toyota' and model='GR Corolla'
  and trim='Core / Premium / Circuit';

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','GR Corolla',source.trim,source.trim,true,source.sort_order
from (values ('Core',1310),('Premium',1311),('Circuit Edition',1312))
  as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='GR Corolla'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'Core' then 1310 when 'Premium' then 1311
      when 'Circuit Edition' then 1312 else sort_order end
where make='Toyota' and model='GR Corolla'
  and trim in ('Core','Premium','Circuit Edition');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  source.front,source.rear,source.front_tire,source.rear_tire,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'Core' then 0
    when 'Premium' then 4 else 8 end,
  '5x114.3','60.1mm','18x8.5 ET30','18x8.5 ET30','235/40R18'
from public.fitment_presets source
cross join (values ('Core'),('Premium'),('Circuit Edition')) as target(trim)
where source.make='Toyota' and source.model='GR Corolla'
  and source.trim='Core / Premium / Circuit' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='GR Corolla'
  and trim='Core / Premium / Circuit';

update public.fitment_presets
set bolt_pattern='5x114.3',center_bore='60.1mm',
    factory_front='18x8.5 ET30',factory_rear='18x8.5 ET30',
    factory_tire='235/40R18'
where make='Toyota' and model='GR Corolla'
  and trim in ('Core','Premium','Circuit Edition') and active is not false;

create temp table if not exists toyota_gr_corolla_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_gr_corolla_verified_baselines;

insert into toyota_gr_corolla_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','GR Corolla','Core',2023,2025,'Core 18-inch production package','US',true,
 '18x8.5 ET30','18x8.5 ET30','235/40R18 front / 235/40R18 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s official 2023 and 2024 GR Corolla eBrochures specify Core 18-inch gloss-black cast wheels with 235/40R18 Michelin Pilot Sport 4 tires. Toyota EPC/service-wheel records specify 18x8.5J ET30, 5x114.3, a 60.1 mm hub and M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/gr-corolla_ebrochure.pdf ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/grcorolla_ebrochure.pdf'),
('Toyota','GR Corolla','Premium',2024,2025,'Premium 18-inch production package','US',true,
 '18x8.5 ET30','18x8.5 ET30','235/40R18 front / 235/40R18 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s official 2024 GR Corolla eBrochure specifies Premium 18-inch gloss-black cast wheels with 235/40R18 Michelin Pilot Sport 4 tires. Toyota EPC/service-wheel records specify 18x8.5J ET30, 5x114.3, a 60.1 mm hub and M12x1.5 flat-seat lug nuts. Source: https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/grcorolla_ebrochure.pdf'),
('Toyota','GR Corolla','Circuit Edition',2023,2024,
 'Circuit Edition 18-inch forged-wheel package','US',true,
 '18x8.5 ET30','18x8.5 ET30','235/40R18 front / 235/40R18 rear',
 '5x114.3','60.1mm','verified',
 'Toyota''s official 2023 and 2024 GR Corolla material specifies Circuit Edition 18-inch forged-alloy wheels with 235/40R18 Michelin Pilot Sport 4 tires. Toyota EPC/service-wheel records specify 18x8.5J ET30, 5x114.3, a 60.1 mm hub and M12x1.5 flat-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/gr-corolla_ebrochure.pdf ; https://www.toyota.com/content/dam/toyota/brochures/pdf/2024/grcorolla_ebrochure.pdf');

delete from public.fitment_factory_baselines
where make='Toyota' and model='GR Corolla';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_gr_corolla_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='GR Corolla' and active
order by trim;
