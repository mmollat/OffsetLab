-- Offset Lab Fitment
-- Pack 118: verified Mercedes-Benz W463A G-Class factory baselines.
-- Covers US-market G550 and AMG G63 for model years 2019-2024.
-- Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='W463A G-Class / AMG',year_start=2019,year_end=2024
where make='Mercedes-Benz' and model='W463';

update public.fitment_presets
set bolt_pattern='5x130',center_bore='84.1mm',
    factory_front='19x8.5 ET52',factory_rear='19x8.5 ET52',
    factory_tire='275/55R19 front / 275/55R19 rear'
where make='Mercedes-Benz' and model='W463' and trim='G550'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x130',center_bore='84.1mm',
    factory_front='20x9.5 ET35',factory_rear='20x9.5 ET35',
    factory_tire='275/50R20 front / 275/50R20 rear'
where make='Mercedes-Benz' and model='W463' and trim='G63 AMG'
  and active is not false;

-- Replace the inherited passenger-car package with Mercedes' approved
-- 20-inch G-Class AMG Line geometry and full-diameter SUV tires.
update public.fitment_presets
set front='20x8.5 ET32',rear='20x8.5 ET32',
    front_tire='275/50R20',rear_tire='275/50R20',
    subtitle='Mercedes 20-inch factory-plus G-Class stance',
    verdict='Factory-plus square G550 fitment using Mercedes-Benz approved W463A AMG Line wheel and SUV tire geometry.',
    warnings=array['Requires AMG Line wheel-arch compatibility where specified by Mercedes-Benz.','Use XL SUV load-rated tires.']::text[]
where make='Mercedes-Benz' and model='W463' and trim='G550'
  and style='oemplus' and active is not false;

-- Keep OEM+ distinct from the standard 20-inch package by using the
-- Mercedes-approved 21-inch AMG package.
update public.fitment_presets
set front='21x10 ET33',rear='21x10 ET33',
    front_tire='285/45R21',rear_tire='285/45R21',
    subtitle='Mercedes 21-inch factory-plus AMG stance',
    verdict='Factory-plus square G63 fitment using Mercedes-Benz approved 21-inch AMG geometry.',
    warnings=array['Use XL AMG-approved tires.','Snow chains are not approved with this summer-tire package.']::text[]
where make='Mercedes-Benz' and model='W463' and trim='G63 AMG'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_w463_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w463_verified_baselines;

insert into mercedes_w463_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W463','G550',2019,2024,'Standard 19-inch G550 package','United States',true,'19x8.5 ET52','19x8.5 ET52','275/55R19 front / 275/55R19 rear','5x130','84.1mm','verified','Mercedes-Benz USA specifies square 19x8.5 wheels and 275/55R19 tires for the 2019 G550. Mercedes-Benz technical data identifies the standard wheel offset as ET52. W463A hardware is 5x130 with an 84.1 mm center bore; the Mercedes-Benz operator manual specifies a 150 Nm (111 lb-ft) wheel-bolt tightening torque. Sources: https://media.mbusa.com/news/2019-mercedes-benz-g550-specifications ; https://media.mbusa.com/news/the-gelandewagen-off-road-unlimited-established-in-1979 ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-g-class-suv-2023-june-463-comand-operators-manual-1.pdf'),
('Mercedes-Benz','W463','G63 AMG',2019,2024,'Standard AMG 20-inch package','United States',true,'20x9.5 ET35','20x9.5 ET35','275/50R20 front / 275/50R20 rear','5x130','84.1mm','verified','Mercedes-Benz USA specifies square 20x9.5 wheels and 275/50R20 tires for the 2019 AMG G63. Mercedes-Benz AMG manufacturer certification identifies the standard wheel offset as ET35 for model 463276. W463A hardware is 5x130 with an 84.1 mm center bore; the Mercedes-Benz operator manual specifies a 150 Nm (111 lb-ft) wheel-bolt tightening torque. Sources: https://media.mbusa.com/news/2019-mercedes-amg-g63-specifications ; https://www.kunzmann.de/produkt/63-amg-22-zoll-felgen-satz-g-klasse-w463-kreuzspeichen-rad-schwarz-original-mercedes-benz%2C16774%2CG463-AMG.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-g-class-suv-2023-june-463-comand-operators-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w463_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w463_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='W463' and active
order by trim,is_default desc,year_start;
