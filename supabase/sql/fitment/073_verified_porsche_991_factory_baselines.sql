-- Offset Lab Fitment
-- Pack 073: verified Porsche 991, 991.1, and 991.2 factory baselines.
-- Splits the combined Turbo / Turbo S trim because the factory wheels differ.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='991 911',year_start=2012,year_end=2019
where make='Porsche' and model='991';

update public.vehicle_models
set display_name='991.1 911',year_start=2012,year_end=2016
where make='Porsche' and model='991.1';

update public.vehicle_models
set display_name='991.2 911',year_start=2017,year_end=2019
where make='Porsche' and model='991.2';

-- Replace the ambiguous combined Turbo trim with separate factory variants.
insert into public.vehicle_trims
  (make,model,trim,active,sort_order,display_name)
select 'Porsche','991',new_trim,true,source.sort_order,new_trim
from (
  select coalesce(max(sort_order),0) as sort_order
  from public.vehicle_trims
  where make='Porsche' and model='991' and trim='Turbo / Turbo S'
) source
cross join (values ('Turbo'),('Turbo S')) trims(new_trim)
where not exists (
  select 1 from public.vehicle_trims existing
  where existing.make='Porsche' and existing.model='991'
    and existing.trim=trims.new_trim
);

update public.vehicle_trims
set active=true,display_name=trim
where make='Porsche' and model='991' and trim in ('Turbo','Turbo S');

insert into public.fitment_presets
  (make,model,trim,style,title,subtitle,front,rear,front_tire,rear_tire,
   poke_front,poke_rear,inner_front,inner_rear,diameter,aggression,daily,
   risk,verdict,warnings,alternate,active,sort_order,bolt_pattern,
   center_bore,factory_front,factory_rear,factory_tire)
select source.make,source.model,trims.new_trim,source.style,source.title,
       source.subtitle,source.front,source.rear,source.front_tire,
       source.rear_tire,source.poke_front,source.poke_rear,source.inner_front,
       source.inner_rear,source.diameter,source.aggression,source.daily,
       source.risk,source.verdict,source.warnings,source.alternate,true,
       source.sort_order,source.bolt_pattern,source.center_bore,
       source.factory_front,source.factory_rear,source.factory_tire
from public.fitment_presets source
cross join (values ('Turbo'),('Turbo S')) trims(new_trim)
where source.make='Porsche' and source.model='991'
  and source.trim='Turbo / Turbo S' and source.active is not false
  and not exists (
    select 1 from public.fitment_presets existing
    where existing.make='Porsche' and existing.model='991'
      and existing.trim=trims.new_trim and existing.style=source.style
  );

update public.vehicle_trims
set active=false
where make='Porsche' and model='991' and trim='Turbo / Turbo S';

update public.fitment_presets
set active=false
where make='Porsche' and model='991' and trim='Turbo / Turbo S';

-- Attach the verified factory geometry and hardware to every live preset.
update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='19x8.5 ET54',factory_rear='19x11 ET69',
    factory_tire='235/40R19 front / 285/35R19 rear'
where make='Porsche' and model='991' and trim='Carrera' and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='71.6mm',
    factory_front='20x8.5 ET51',factory_rear='20x11 ET70',
    factory_tire='245/35R20 front / 295/30R20 rear'
where make='Porsche' and model='991' and trim='Carrera S' and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x9 ET51',factory_rear='20x11.5 ET48',
    factory_tire='245/35R20 front / 305/30R20 rear'
where make='Porsche' and model='991' and trim='GTS' and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x8.5 ET51',factory_rear='20x11 ET56',
    factory_tire='245/35R20 front / 305/30R20 rear'
where make='Porsche' and model='991' and trim='Turbo' and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x9 ET51',factory_rear='20x11.5 ET56',
    factory_tire='245/35R20 front / 305/30R20 rear'
where make='Porsche' and model='991' and trim='Turbo S' and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x9 ET55',factory_rear='20x12 ET47',
    factory_tire='245/35R20 front / 305/30R20 rear'
where make='Porsche' and model in ('991','991.1','991.2')
  and trim='GT3' and active is not false;

update public.fitment_presets
set bolt_pattern='Center-lock',center_bore='71.6mm',
    factory_front='20x9 ET51',factory_rear='20x11.5 ET56',
    factory_tire='245/35R20 front / 305/30R20 rear'
where make='Porsche' and model='991.2' and trim='Turbo S'
  and active is not false;

-- OEM+ is intentionally a mild step beyond OEM, not a duplicate factory row.
update public.fitment_presets
set front='20x9.5 ET50',rear='20x12 ET44',
    front_tire='255/35R20',rear_tire='315/30R20'
where make='Porsche' and model in ('991','991.1','991.2')
  and trim='GT3' and style='oemplus' and active is not false;

update public.fitment_presets
set front='20x9 ET48',rear='20x11.5 ET53',
    front_tire='245/35R20',rear_tire='305/30R20'
where make='Porsche' and model='991' and trim='Turbo'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='20x9.5 ET48',rear='20x12 ET52',
    front_tire='255/35R20',rear_tire='315/30R20'
where make='Porsche' and model in ('991','991.2') and trim='Turbo S'
  and style='oemplus' and active is not false;

create temp table if not exists porsche_991_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table porsche_991_verified_baselines;

insert into porsche_991_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Porsche','991','Carrera',2012,2016,'991.1 Carrera standard 19-inch package','US',true,
 '19x8.5 ET54','19x11 ET69','235/40R19 front / 285/35R19 rear',
 '5x130','71.6mm','verified',
 'Porsche''s 2013 US technical specification identifies the Carrera standard package as 8.5Jx19 front and 11Jx19 rear with 235/40ZR19 and 285/35ZR19 tires. Porsche''s approved-summer-tire documentation supplies the corresponding ET54 front and ET69 rear offsets for model years 2012-2016. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat bolts. Sources: https://newsroom.porsche.com/dam/jcr:e1638451-d7dc-4f0e-a00d-b169cf342b86/2013_911_Technical_Specifications.pdf ; https://files.porsche.com/filestore/download/netherlands/nl/porscheservice-tire-currentsummertires/default/d45a356b-4b7d-11e7-bfe2-0019999cd470/Overzicht-zomerbanden-huidige-modellen.pdf'),
('Porsche','991','Carrera S',2012,2016,'991.1 Carrera S standard 20-inch package','US',true,
 '20x8.5 ET51','20x11 ET70','245/35R20 front / 295/30R20 rear',
 '5x130','71.6mm','verified',
 'Porsche''s 2013 US technical specification identifies the Carrera S standard package as 8.5Jx20 front and 11Jx20 rear with 245/35ZR20 and 295/30ZR20 tires. Porsche''s approved-summer-tire and Tequipment documentation supplies ET51 front and ET70 rear for the narrow-body Carrera S package. Hardware is 5x130, 71.6 mm with M14x1.5 R14 ball-seat bolts. Sources: https://newsroom.porsche.com/dam/jcr:e1638451-d7dc-4f0e-a00d-b169cf342b86/2013_911_Technical_Specifications.pdf ; https://files.porsche.com/filestore/download/norway/no/991-2nd-catalogue-tequipment/default/4c6146c6-4c07-11e5-8c32-0019999cd470/Tequipment-911.pdf'),
('Porsche','991','GTS',2015,2016,'991.1 Carrera GTS standard 20-inch Turbo S package','US',true,
 '20x9 ET51','20x11.5 ET48','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 2015 US Carrera GTS technical specification lists the standard 20-inch 911 Turbo S wheel package as 9Jx20 ET51 front and 11.5Jx20 ET48 rear with 245/35ZR20 and 305/30ZR20 tires. Porsche''s GTS history confirms the 991 GTS retained center-lock wheels. Sources: https://newsroom.porsche.com/dam/jcr:c944dc62-e433-4c19-b452-436054dcf22a/2015_911_Carrera_GTS_Technical_Specs.pdf ; https://newsroom.porsche.com/en/press-kits/911/History-of-the-911-Carrera-GTS.html'),
('Porsche','991','Turbo',2014,2016,'991.1 Turbo standard 20-inch package','US',true,
 '20x8.5 ET51','20x11 ET56','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 2014 US Turbo technical specification lists 8.5Jx20 front and 11Jx20 rear wheels with 245/35ZR20 and 305/30ZR20 tires. Porsche''s approved-summer-tire document supplies ET51 front and ET56 rear, and the 991 Turbo driver manual documents the production central-lock system. Sources: https://newsroom.porsche.com/dam/jcr:c8180368-6470-4846-8350-38aee7990971/2014_911_Turbo_and_Turbo_S_Technical_Specifications_Final_Aug_2013.pdf ; https://files.porsche.com/filestore/download/netherlands/nl/porscheservice-tire-currentsummertires/default/d45a356b-4b7d-11e7-bfe2-0019999cd470/Overzicht-zomerbanden-huidige-modellen.pdf ; https://files.porsche.com/filestore/download/china/zh/911turbodriversmanual11-15/default/2c49d554-264c-11e6-9225-0019999cd470/911-Turbo-%E9%A9%BE%E9%A9%B6%E6%89%8B%E5%86%8C-%2811-15%29.pdf'),
('Porsche','991','Turbo S',2014,2016,'991.1 Turbo S standard 20-inch package','US',true,
 '20x9 ET51','20x11.5 ET56','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 2014 US Turbo S technical specification lists 9Jx20 front and 11.5Jx20 rear wheels with 245/35ZR20 and 305/30ZR20 tires. Porsche''s approved-summer-tire document supplies ET51 front and ET56 rear, and the 991 Turbo driver manual documents the production central-lock system. Sources: https://newsroom.porsche.com/dam/jcr:c8180368-6470-4846-8350-38aee7990971/2014_911_Turbo_and_Turbo_S_Technical_Specifications_Final_Aug_2013.pdf ; https://files.porsche.com/filestore/download/netherlands/nl/porscheservice-tire-currentsummertires/default/d45a356b-4b7d-11e7-bfe2-0019999cd470/Overzicht-zomerbanden-huidige-modellen.pdf ; https://files.porsche.com/filestore/download/china/zh/911turbodriversmanual11-15/default/2c49d554-264c-11e6-9225-0019999cd470/911-Turbo-%E9%A9%BE%E9%A9%B6%E6%89%8B%E5%86%8C-%2811-15%29.pdf'),
('Porsche','991','GT3',2014,2016,'991.1 GT3 standard 20-inch package','US',true,
 '20x9 ET55','20x12 ET47','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 991 GT3 driver manual and official Tequipment catalog specify 9Jx20 ET55 front and 12Jx20 ET47 rear wheels with 245/35ZR20 and 305/30ZR20 tires. The production GT3 wheels use Porsche''s center-lock system. Sources: https://files.porsche.com/filestore/download/china/en/911gt3driversmanual04-13/default/dc7d3865-2645-11e6-9225-0019999cd470/911-GT3-Driver%27s-Manual-%2804-13%29.pdf ; https://files.porsche.com/filestore/download/norway/no/991-2nd-catalogue-tequipment/default/4c6146c6-4c07-11e5-8c32-0019999cd470/Tequipment-911.pdf'),
('Porsche','991.1','GT3',2014,2016,'991.1 GT3 standard 20-inch package','US',true,
 '20x9 ET55','20x12 ET47','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 991 GT3 driver manual and official Tequipment catalog specify 9Jx20 ET55 front and 12Jx20 ET47 rear wheels with 245/35ZR20 and 305/30ZR20 tires. The production GT3 wheels use Porsche''s center-lock system. Sources: https://files.porsche.com/filestore/download/china/en/911gt3driversmanual04-13/default/dc7d3865-2645-11e6-9225-0019999cd470/911-GT3-Driver%27s-Manual-%2804-13%29.pdf ; https://files.porsche.com/filestore/download/norway/no/991-2nd-catalogue-tequipment/default/4c6146c6-4c07-11e5-8c32-0019999cd470/Tequipment-911.pdf'),
('Porsche','991.2','GT3',2018,2019,'991.2 GT3 standard 20-inch package','US',true,
 '20x9 ET55','20x12 ET47','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s official GT3 Tequipment listing specifies 9Jx20 ET55 front and 12Jx20 ET47 rear wheels with 245/35ZR20 and 305/30ZR20 tires. Porsche''s 2017 GT3 release confirms the same production tire sizes, and the GT3 package uses center-lock hardware. Sources: https://files.porsche.com/filestore/download/norway/no/991-2nd-catalogue-tequipment/default/4c6146c6-4c07-11e5-8c32-0019999cd470/Tequipment-911.pdf ; https://newsroom.porsche.com/en/products/porsche-iaa-2017-911-gt3-touring-package-world-premiere-manual-transmission-rear-spoiler-14133.html'),
('Porsche','991.2','Turbo S',2017,2019,'991.2 Turbo S standard 20-inch package','US',true,
 '20x9 ET51','20x11.5 ET56','245/35R20 front / 305/30R20 rear',
 'Center-lock','71.6mm','verified',
 'Porsche''s 2017 US Turbo S technical specification and approved-tire documentation identify the standard package as 9Jx20 ET51 front and 11.5Jx20 ET56 rear with 245/35ZR20 and 305/30ZR20 tires. Porsche documents the Turbo S wheel as a center-lock design. Sources: https://newsroom.porsche.com/dam/jcr:71ee7b5f-5fe9-4f45-bc6a-3cfdf18b51d5/2017_911_Turbo_Technical_Specifications.pdf ; https://files.porsche.com/filestore/download/netherlands/nl/porscheservice-tire-currentsummertires/default/d45a356b-4b7d-11e7-bfe2-0019999cd470/Overzicht-zomerbanden-huidige-modellen.pdf ; https://newsroom.porsche.com/en/products/porsche-911-turbo-911-turbo-s-sportscar-12061.html');

delete from public.fitment_factory_baselines
where make='Porsche' and model in ('991','991.1','991.2');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from porsche_991_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Porsche' and model in ('991','991.1','991.2') and active
order by model,trim,is_default desc,year_start;
