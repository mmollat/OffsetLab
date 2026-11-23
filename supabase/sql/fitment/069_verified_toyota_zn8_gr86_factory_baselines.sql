-- Offset Lab Fitment
-- Pack 069: verified Toyota ZN8 GR86 factory baselines.
-- Splits Base and Premium and retires the orphaned duplicate "GR86" model.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='ZN8 GR86',year_start=2022,year_end=null
where make='Toyota' and model='ZN8';

update public.vehicle_trims set active=false
where make='Toyota' and model='GR86';

update public.fitment_presets set active=false
where make='Toyota' and model='GR86';

update public.vehicle_trims set active=false
where make='Toyota' and model='ZN8' and trim='GR86';

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','ZN8',source.trim,source.trim,true,source.sort_order
from (values ('Base',1320),('Premium',1321)) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='ZN8'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,sort_order=case trim when 'Base' then 1320 else 1321 end
where make='Toyota' and model='ZN8' and trim in ('Base','Premium');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case when source.style='oemplus' and target.trim='Base' then '17x8 +40'
    else source.front end,
  case when source.style='oemplus' and target.trim='Base' then '17x8 +40'
    else source.rear end,
  case when source.style='oemplus' and target.trim='Base' then '225/45R17'
    else source.front_tire end,
  case when source.style='oemplus' and target.trim='Base' then '225/45R17'
    else source.rear_tire end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'Base' then 0 else 4 end,
  '5x100','56.1mm',
  case target.trim when 'Base' then '17x7.5 ET48' else '18x7.5 ET48' end,
  case target.trim when 'Base' then '17x7.5 ET48' else '18x7.5 ET48' end,
  case target.trim when 'Base' then '215/45R17' else '215/40R18' end
from public.fitment_presets source
cross join (values ('Base'),('Premium')) as target(trim)
where source.make='Toyota' and source.model='ZN8' and source.trim='GR86'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='ZN8' and trim='GR86';

update public.fitment_presets
set bolt_pattern='5x100',center_bore='56.1mm',
    factory_front=case trim when 'Base' then '17x7.5 ET48' else '18x7.5 ET48' end,
    factory_rear=case trim when 'Base' then '17x7.5 ET48' else '18x7.5 ET48' end,
    factory_tire=case trim when 'Base' then '215/45R17' else '215/40R18' end
where make='Toyota' and model='ZN8' and trim in ('Base','Premium')
  and active is not false;

create temp table if not exists toyota_zn8_gr86_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_zn8_gr86_verified_baselines;

insert into toyota_zn8_gr86_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','ZN8','Base',2022,null,'GR86 Base 17-inch production package','US',true,
 '17x7.5 ET48','17x7.5 ET48','215/45R17 front / 215/45R17 rear',
 '5x100','56.1mm','verified',
 'Toyota''s official 2022 GR86 eBrochure specifies the Base grade with 17x7.5J wheels and 215/45R17 Michelin Primacy HP tires. Toyota EPC/service-wheel records specify ET48, 5x100, a 56.1 mm hub and M12x1.25 conical-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2022/gr86_ebrochure.pdf ; https://pressroom.toyota.com/toyota-announces-pricing-on-all-new-2022-gr86/'),
('Toyota','ZN8','Premium',2022,null,'GR86 Premium 18-inch production package','US',true,
 '18x7.5 ET48','18x7.5 ET48','215/40R18 front / 215/40R18 rear',
 '5x100','56.1mm','verified',
 'Toyota''s official 2022 GR86 eBrochure specifies the Premium grade with 18x7.5J wheels and 215/40R18 Michelin Pilot Sport 4 tires. Toyota TRD''s wheel specification confirms the platform''s 18x7.5J ET48 and 5x100 geometry; Toyota service records specify a 56.1 mm hub and M12x1.25 conical-seat lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2022/gr86_ebrochure.pdf ; https://www.trdparts.jp/product/wheel/tf9.html');

delete from public.fitment_factory_baselines
where make='Toyota' and model in ('ZN8','GR86');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_zn8_gr86_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='ZN8' and active
order by trim;
