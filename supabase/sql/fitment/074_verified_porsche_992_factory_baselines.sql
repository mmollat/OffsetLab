-- Offset Lab Fitment
-- Pack 074: verified Porsche 992 Carrera, Carrera S, Turbo, and Turbo S baselines.
-- Splits two combined trims so each distinct factory package is represented.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='992 911',year_start=2020,year_end=2024
where make='Porsche' and model='992';

-- Split Carrera / Carrera S and Turbo / Turbo S into actual factory variants.
insert into public.vehicle_trims
  (make,model,trim,active,sort_order,display_name)
select 'Porsche','992',split.new_trim,true,source.sort_order,split.new_trim
from (
  select combined.trim as source_trim,new_trim
  from (values
    ('Carrera / Carrera S','Carrera'),
    ('Carrera / Carrera S','Carrera S'),
    ('Turbo / Turbo S','Turbo'),
    ('Turbo / Turbo S','Turbo S')
  ) combined(trim,new_trim)
) split
join public.vehicle_trims source
  on source.make='Porsche' and source.model='992'
 and source.trim=split.source_trim
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Porsche' and existing.model='992'
    and existing.trim=split.new_trim
);

update public.vehicle_trims
set active=true,display_name=trim
where make='Porsche' and model='992'
  and trim in ('Carrera','Carrera S','Turbo','Turbo S');

insert into public.fitment_presets
  (make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
   poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
   risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
   center_bore,factory_front,factory_rear,factory_tire)
select source.make,source.model,split.new_trim,source.style,source.title,
       source.subtitle,source.front,source.rear,source.front_tire,
       source.rear_tire,source.poke_front,source.poke_rear,source.inner_front,
       source.inner_rear,source.diameter,source.aggression,source.daily,
       source.risk,source.verdict,source.warnings,source.alternate,true,
       source.sort_order,source.bolt_pattern,source.center_bore,
       source.factory_front,source.factory_rear,source.factory_tire
from public.fitment_presets source
join (values
  ('Carrera / Carrera S','Carrera'),
  ('Carrera / Carrera S','Carrera S'),
  ('Turbo / Turbo S','Turbo'),
  ('Turbo / Turbo S','Turbo S')
) split(source_trim,new_trim)
  on source.trim=split.source_trim
where source.make='Porsche' and source.model='992'
  and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make='Porsche' and existing.model='992'
      and existing.trim=split.new_trim and existing.style=source.style
  );

update public.vehicle_trims
set active=false
where make='Porsche' and model='992'
  and trim in ('Carrera / Carrera S','Turbo / Turbo S');

update public.fitment_presets
set active=false
where make='Porsche' and model='992'
  and trim in ('Carrera / Carrera S','Turbo / Turbo S');

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='19x8.5 ET52',factory_rear='20x11.5 ET67',
    factory_tire='235/40R19 front / 295/35R20 rear'
where make='Porsche' and model='992' and trim='Carrera'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='20x8.5 ET53',factory_rear='21x11.5 ET67',
    factory_tire='245/35R20 front / 305/30R21 rear'
where make='Porsche' and model='992' and trim='Carrera S'
  and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x9 ET41',factory_rear='21x11.5 ET67',
    factory_tire='255/35R20 front / 315/30R21 rear'
where make='Porsche' and model='992' and trim in ('Turbo','Turbo S')
  and active is not false;

-- Complete the display fields for the previously verified 992 GT3 and GTS.
update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='N/A',
    factory_front='20x9.5 ET46',factory_rear='21x12 ET45',
    factory_tire='255/35R20 front / 315/30R21 rear'
where make='Porsche' and model='992' and trim='GT3'
  and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='N/A',
    factory_front='20x8.5 ET50',factory_rear='21x11.5 ET67',
    factory_tire='245/35R20 front / 305/30R21 rear'
where make='Porsche' and model='992' and trim='GTS'
  and active is not false;

-- Move the cloned Turbo OEM+ rows beyond the factory package.
update public.fitment_presets
set front='20x9.5 ET38',rear='21x12 ET62',
    front_tire='265/35R20',rear_tire='325/30R21'
where make='Porsche' and model='992' and trim in ('Turbo','Turbo S')
  and style='oemplus' and active is not false;

create temp table if not exists porsche_992_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table porsche_992_verified_baselines;

insert into porsche_992_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Porsche','992','Carrera',2020,2024,'992.1 Carrera standard 19/20-inch package','US',true,
 '19x8.5 ET52','20x11.5 ET67','235/40R19 front / 295/35R20 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 992 Carrera brochure specifies the standard mixed-diameter package as 8.5Jx19 ET52 front and 11.5Jx20 ET67 rear with 235/40ZR19 and 295/35ZR20 tires. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat wheel bolts. Sources: https://files.porsche.com/filestore/download/international/en/modelseries-911carrera992-downloads-catalogue/default/64090fb6-12a5-11ea-80c6-005056bbdc38/911-Carrera-Brochure.pdf ; https://download.newsroom.porsche.com/dam/jcr:683ce58d-5a57-4bd0-bf5f-b1bf5fe1931d/2020_911_Carrera_and_911_Carrera_Cabriolet_US_specifications.pdf'),
('Porsche','992','Carrera S',2020,2024,'992.1 Carrera S standard 20/21-inch package','US',true,
 '20x8.5 ET53','21x11.5 ET67','245/35R20 front / 305/30R21 rear',
 '5x130','71.6mm','verified',
 'Porsche''s official 992 Carrera brochure specifies the Carrera S standard mixed-diameter package as 8.5Jx20 ET53 front and 11.5Jx21 ET67 rear with 245/35ZR20 and 305/30ZR21 tires. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat wheel bolts. Sources: https://files.porsche.com/filestore/download/uk/en/modelseries-911carrera992-downloads-catalogue/default/3fcd036e-8220-11e9-80c4-005056bbdc38/911-Brochure.pdf ; https://newsroom.porsche.com/dam/jcr:d5712d5c-b376-41d9-8201-09731162e143/2020_911_Carrera_S_and_911_Carrera_4S_US_specifications.pdf.PDF'),
('Porsche','992','Turbo',2021,2024,'992.1 Turbo standard 20/21-inch package','US',true,
 '20x9 ET41','21x11.5 ET67','255/35R20 front / 315/30R21 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s official 992 Turbo brochure specifies 9Jx20 ET41 front and 11.5Jx21 ET67 rear wheels with 255/35ZR20 and 315/30ZR21 tires. The standard 20/21-inch Turbo wheel uses Porsche center-lock hardware. Sources: https://files.porsche.com/filestore/download/germany/de/model-series-911-turbo-downloads-catalogue/default/27322d7e-c768-11ea-80ca-005056bbdc38/911-Turbo-Brosch%C3%BCre.pdf ; https://newsroom.porsche.com/dam/jcr:059b218d-bf41-4508-ae8f-d9d634e4f280/2021%20911%20Turbo%20Technical%20Specifications.pdf'),
('Porsche','992','Turbo S',2021,2024,'992.1 Turbo S standard 20/21-inch package','US',true,
 '20x9 ET41','21x11.5 ET67','255/35R20 front / 315/30R21 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s official 992 Turbo S brochure specifies 9Jx20 ET41 front and 11.5Jx21 ET67 rear wheels with 255/35ZR20 and 315/30ZR21 tires. Porsche identifies the Turbo S package as a center-lock wheel design. Sources: https://files.porsche.com/filestore/download/international/en/model-series-911-turbo-downloads-catalogue-opf/default/9e5f7775-7e4f-11ea-80c9-005056bbdc38/911-Turbo-S-brochure.pdf ; https://newsroom.porsche.com/dam/jcr:887d7189-958d-4946-a189-e170e87b13e7/U.S.%20Technical%20Specifications%202021%20911%20Turbo%20S%20Coupe%20and%20Cabriolet.pdf');

delete from public.fitment_factory_baselines
where make='Porsche' and model='992'
  and trim in ('Carrera / Carrera S','Turbo / Turbo S','Carrera','Carrera S','Turbo','Turbo S');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from porsche_992_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Porsche' and model='992' and active
order by trim,is_default desc,year_start;
