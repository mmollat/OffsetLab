-- Offset Lab Fitment
-- Pack 115: verified Mercedes-Benz C257 CLS factory baselines.
-- Covers CLS450/CLS450 4MATIC and AMG CLS53. Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='C257 CLS / AMG',year_start=2019,year_end=2023
where make='Mercedes-Benz' and model='C257';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8 ET33',factory_rear='19x9 ET33',
    factory_tire='245/40R19 front / 275/35R19 rear'
where make='Mercedes-Benz' and model='C257' and trim='CLS450'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8 ET10',factory_rear='19x9 ET28',
    factory_tire='245/40R19 front / 275/35R19 rear'
where make='Mercedes-Benz' and model='C257' and trim='CLS53 AMG'
  and active is not false;

-- Correct the undersized legacy CLS450 OEM+ setup with the Mercedes-Benz
-- optional 20-inch staggered envelope.
update public.fitment_presets
set front='20x8 ET10',rear='20x9 ET28',
    front_tire='245/35R20',rear_tire='275/30R20',
    subtitle='Mercedes 20-inch factory-plus stance',
    verdict='Factory-plus C257 fitment using the Mercedes-Benz optional 20-inch wheel and tire envelope.',
    warnings=array['Verify the selected wheel is approved for the exact drivetrain.','Use the specified XL load-rated tires.']::text[]
where make='Mercedes-Benz' and model='C257' and trim='CLS450'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_c257_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_c257_verified_baselines;

insert into mercedes_c257_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','C257','CLS450',2019,2023,'Standard 19-inch package','United States',true,'19x8 ET33','19x9 ET33','245/40R19 front / 275/35R19 rear','5x112','66.6mm','verified','This catalog row covers the US-market C257 CLS450 and CLS450 4MATIC. Mercedes-Benz USA specifies 19x8 front and 19x9 rear wheels with 245/40R19 and 275/35R19 tires. Mercedes-Benz factory wheel documentation identifies the corresponding standard C257 wheel geometry as ET33 front and rear. C257 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-mercedes-benz-cls-450-coupe-and-cls-450-4matic-coupe ; https://www.kunzmann.de/produkt/rims-19-inch-rim-set-cls-c257-5-spoke-wheel-black-genuine-mercedes-benz%2C16498%2CCLS257Coupe.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-lk/pdf/mercedes-cls-coupe-2019-august-c257-comand-owners-manual-1.pdf'),
('Mercedes-Benz','C257','CLS53 AMG',2019,2023,'Standard AMG 19-inch package','United States',true,'19x8 ET10','19x9 ET28','245/40R19 front / 275/35R19 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies the C257 AMG CLS53 standard 19-inch package as 19x8 front and 19x9 rear with 245/40R19 and 275/35R19 tires. Mercedes-Benz factory homologation documentation and the genuine AMG complete-wheel listing identify ET10 front and ET28 rear for the CLS53-specific package. C257 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-mercedes-amg-cls-53-coupe ; https://www.kunzmann.de/produkt/felgen-53-amg-20-zoll-felgen-satz-cls-c257-5-doppel-speichen-rad-schwarz-original-mercedes-benz%2C16477%2CCLS257-AMG.pdf ; https://www.kunzmann.de/shop/de-de/p/komplettraeder-winter-amg-cls-53-winterraeder-19-zoll-cls-c257-original-mercedes-benz-16270.htm ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-lk/pdf/mercedes-cls-coupe-2019-august-c257-comand-owners-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_c257_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_c257_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='C257' and active
order by trim,is_default desc,year_start;
