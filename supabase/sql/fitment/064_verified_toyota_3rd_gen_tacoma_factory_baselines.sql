-- Offset Lab Fitment
-- Pack 064: verified Toyota 3rd-generation Tacoma factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='3rd Gen Tacoma',year_start=2016,year_end=2023
where make='Toyota' and model='3rd Gen Tacoma';

update public.vehicle_trims set active=false
where make='Toyota' and model='3rd Gen Tacoma' and trim='SR / SR5';

insert into public.vehicle_trims
  (make,model,trim,display_name,active,sort_order)
select 'Toyota','3rd Gen Tacoma',source.trim,source.trim,true,source.sort_order
from (values ('SR',1420),('SR5',1421)) as source(trim,sort_order)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Toyota' and existing.model='3rd Gen Tacoma'
    and existing.trim=source.trim
);

update public.vehicle_trims
set active=true,
    sort_order=case trim when 'SR' then 1420 when 'SR5' then 1421
      when 'TRD Sport' then 1422 when 'TRD Off-Road' then 1423
      when 'TRD Pro' then 1424 else sort_order end
where make='Toyota' and model='3rd Gen Tacoma'
  and trim in ('SR','SR5','TRD Sport','TRD Off-Road','TRD Pro');

insert into public.fitment_presets (
  make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
  poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
  risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
  center_bore,factory_front,factory_rear,factory_tire
)
select source.make,source.model,target.trim,source.style,source.title,source.subtitle,
  case when source.style='oemplus' then '16x8 +15' else source.front end,
  case when source.style='oemplus' then '16x8 +15' else source.rear end,
  case when source.style='oemplus' then '265/70R16' else source.front_tire end,
  case when source.style='oemplus' then '265/70R16' else source.rear_tire end,
  source.poke_front,source.poke_rear,source.inner_front,source.inner_rear,
  source.diameter,source.aggression,source.daily,source.risk,source.verdict,
  source.warnings,source.alternate,true,
  source.sort_order+case target.trim when 'SR' then 0 else 4 end,
  '6x139.7','106.1mm','16x7 ET25','16x7 ET25','245/75R16'
from public.fitment_presets source
cross join (values ('SR'),('SR5')) as target(trim)
where source.make='Toyota' and source.model='3rd Gen Tacoma'
  and source.trim='SR / SR5' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make=source.make and existing.model=source.model
      and existing.trim=target.trim and existing.style=source.style
  );

update public.fitment_presets set active=false
where make='Toyota' and model='3rd Gen Tacoma' and trim='SR / SR5';

update public.fitment_presets
set bolt_pattern='6x139.7',center_bore='106.1mm',
    factory_front=case trim when 'SR' then '16x7 ET25'
      when 'SR5' then '16x7 ET25' when 'TRD Sport' then '17x7.5 ET30'
      when 'TRD Off-Road' then '16x7 ET25' else '16x7 ET13' end,
    factory_rear=case trim when 'SR' then '16x7 ET25'
      when 'SR5' then '16x7 ET25' when 'TRD Sport' then '17x7.5 ET30'
      when 'TRD Off-Road' then '16x7 ET25' else '16x7 ET13' end,
    factory_tire=case trim when 'SR' then '245/75R16'
      when 'SR5' then '245/75R16' when 'TRD Sport' then '265/65R17'
      else '265/70R16' end,
    front=case
      when style<>'oemplus' then front
      when trim in ('SR','SR5') then '16x8 +15'
      when trim='TRD Sport' then '17x8 +20'
      when trim='TRD Off-Road' then '16x8 +15'
      else '16x8 +5' end,
    rear=case
      when style<>'oemplus' then rear
      when trim in ('SR','SR5') then '16x8 +15'
      when trim='TRD Sport' then '17x8 +20'
      when trim='TRD Off-Road' then '16x8 +15'
      else '16x8 +5' end,
    front_tire=case
      when style<>'oemplus' then front_tire
      when trim in ('SR','SR5') then '265/70R16'
      when trim='TRD Sport' then '265/70R17'
      else '275/70R16' end,
    rear_tire=case
      when style<>'oemplus' then rear_tire
      when trim in ('SR','SR5') then '265/70R16'
      when trim='TRD Sport' then '265/70R17'
      else '275/70R16' end
where make='Toyota' and model='3rd Gen Tacoma'
  and trim in ('SR','SR5','TRD Sport','TRD Off-Road','TRD Pro')
  and active is not false;

create temp table if not exists toyota_3rd_gen_tacoma_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table toyota_3rd_gen_tacoma_verified_baselines;

insert into toyota_3rd_gen_tacoma_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Toyota','3rd Gen Tacoma','SR',2016,2023,'SR 16-inch production package','US',true,
 '16x7 ET25','16x7 ET25','245/75R16 front / 245/75R16 rear',
 '6x139.7','106.1mm','verified',
 'Toyota''s official 2023 Tacoma eBrochure specifies SR 16-inch styled-steel wheels with P245/75R16 tires. Toyota EPC service-wheel records identify 16x7J ET25. Hardware is 6x139.7, 106.1 mm with M12x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2023'),
('Toyota','3rd Gen Tacoma','SR5',2016,2023,'SR5 16-inch V6 production package','US',true,
 '16x7 ET25','16x7 ET25','245/75R16 front / 245/75R16 rear',
 '6x139.7','106.1mm','verified',
 'Toyota''s official 2023 Tacoma eBrochure specifies SR5 V6 16-inch dark-gray/black alloy wheels with P245/75R16 tires. Toyota EPC service-wheel records identify 16x7J ET25. Hardware is 6x139.7, 106.1 mm with M12x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2023'),
('Toyota','3rd Gen Tacoma','TRD Sport',2016,2023,'TRD Sport 17-inch production package','US',true,
 '17x7.5 ET30','17x7.5 ET30','265/65R17 front / 265/65R17 rear',
 '6x139.7','106.1mm','verified',
 'Toyota''s official 2023 Tacoma eBrochure specifies TRD Sport 17-inch machined alloy wheels with P265/65R17 tires. Toyota EPC service-wheel records identify 17x7.5J ET30. Hardware is 6x139.7, 106.1 mm with M12x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2023'),
('Toyota','3rd Gen Tacoma','TRD Off-Road',2016,2023,'TRD Off-Road 16-inch production package','US',true,
 '16x7 ET25','16x7 ET25','265/70R16 front / 265/70R16 rear',
 '6x139.7','106.1mm','verified',
 'Toyota''s official 2023 Tacoma eBrochure specifies TRD Off-Road 16-inch machined-contrast wheels with P265/70R16 tires. Toyota EPC service-wheel records identify 16x7J ET25. Hardware is 6x139.7, 106.1 mm with M12x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tacoma_ebrochure.pdf ; https://www.toyota.com/owners/warranty-owners-manuals/vehicle/tacoma/2023'),
('Toyota','3rd Gen Tacoma','TRD Pro',2017,2023,'TRD Pro 16-inch production package','US',true,
 '16x7 ET13','16x7 ET13','265/70R16 front / 265/70R16 rear',
 '6x139.7','106.1mm','verified',
 'Toyota''s official 2023 Tacoma eBrochure specifies TRD Pro 16-inch black alloy wheels with P265/70R16 all-terrain tires. Toyota Genuine Parts PT758-35170-02 specifies 16x7J and ET13. Hardware is 6x139.7, 106.1 mm with M12x1.5 lug nuts. Sources: https://www.toyota.com/content/dam/toyota/brochures/pdf/2023/tacoma_ebrochure.pdf ; https://autoparts.toyota.com/products/product/16-wheel-trd-gloss-black-alloy-pt7583517002');

delete from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Tacoma';

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from toyota_3rd_gen_tacoma_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Toyota' and model='3rd Gen Tacoma' and active
order by trim;
