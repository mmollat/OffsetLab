-- Offset Lab Fitment
-- Pack 117: verified Mercedes-Benz V167 GLE factory baselines.
-- Covers GLE350/GLE450, AMG GLE53, and current AMG GLE63 S represented by
-- the catalog's GLE63 AMG row. Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='V167 GLE SUV / AMG',year_start=2020,year_end=2026
where make='Mercedes-Benz' and model='V167';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8 ET61',factory_rear='19x8 ET61',
    factory_tire='255/50R19 front / 255/50R19 rear'
where make='Mercedes-Benz' and model='V167' and trim='GLE350 / 450'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET57',factory_rear='20x9.5 ET45',
    factory_tire='275/50R20 front / 275/50R20 rear'
where make='Mercedes-Benz' and model='V167' and trim='GLE53 AMG'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='21x10 ET54',factory_rear='21x11 ET49',
    factory_tire='275/45R21 front / 315/40R21 rear'
where make='Mercedes-Benz' and model='V167' and trim='GLE63 AMG'
  and active is not false;

-- Replace legacy sedan-diameter tires with Mercedes' approved GLE 20-inch
-- package while keeping OEM+ distinct from the square 19-inch baseline.
update public.fitment_presets
set front='20x9 ET57',rear='20x9 ET45',
    front_tire='275/50R20',rear_tire='275/50R20',
    subtitle='Mercedes 20-inch factory-plus SUV stance',
    verdict='Factory-plus V167 fitment using Mercedes-Benz approved 20-inch GLE geometry and SUV tire diameter.',
    warnings=array['Use XL SUV load-rated tires.','Confirm the selected wheel is approved for the exact drivetrain and cladding code.']::text[]
where make='Mercedes-Benz' and model='V167' and trim='GLE350 / 450'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='21x10 ET51',rear='21x11 ET47',
    front_tire='275/45R21',rear_tire='315/40R21',
    subtitle='Mercedes 21-inch factory-plus AMG stance',
    verdict='Factory-plus GLE53 fitment using Mercedes-Benz approved 21-inch AMG geometry.',
    warnings=array['Use XL AMG-approved tires.','Verify cladding code and brake-package compatibility.']::text[]
where make='Mercedes-Benz' and model='V167' and trim='GLE53 AMG'
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='22x10 ET56.1',rear='22x11 ET50',
    front_tire='285/40R22',rear_tire='325/35R22',
    subtitle='Mercedes 22-inch factory-plus AMG stance',
    verdict='Factory-plus GLE63 fitment using Mercedes-Benz approved 22-inch AMG geometry.',
    warnings=array['Requires AIRMATIC or E-ACTIVE BODY CONTROL where specified by Mercedes-Benz.','Use XL AMG-approved tires and confirm brake clearance.']::text[]
where make='Mercedes-Benz' and model='V167' and trim='GLE63 AMG'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_v167_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_v167_verified_baselines;

insert into mercedes_v167_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','V167','GLE350 / 450',2020,2026,'Standard 19-inch SUV package','United States',true,'19x8 ET61','19x8 ET61','255/50R19 front / 255/50R19 rear','5x112','66.6mm','verified','This combined catalog row represents US-market V167 GLE350/GLE350 4MATIC and GLE450 4MATIC models. Mercedes-Benz USA specifies 19x8 wheels and 255/50R19 tires front and rear for the GLE350; Mercedes-Benz factory homologation documentation identifies the square package as ET61 and approves it for the GLE450 4MATIC. V167 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-mercedes-benz-gle-350-and-gle-350-4matic-suv ; https://www.kunzmann.de/produkt/summer-wheels-21-inch-gle-v167-black-gle-v167-complete-wheel-set-genuine-mercedes-amg%2C30561%2CBR167_08-18.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-gle-suv-2020-march-v167-mbux-operators-manual-1.pdf'),
('Mercedes-Benz','V167','GLE53 AMG',2021,2026,'Standard AMG 20-inch package','United States',true,'20x9.5 ET57','20x9.5 ET45','275/50R20 front / 275/50R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 20-inch AMG wheels as standard on the V167 AMG GLE53 SUV. Mercedes-Benz factory homologation documentation specifies the GLE53-only package as 20x9.5 ET57 front and 20x9.5 ET45 rear with 275/50R20 tires. V167 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-gle-53-suv-quick-reference-guide ; https://www.kunzmann.de/produkt/amg-21-zoll-felgensatz-gle-v167-vielspeichen-rad-schwarz-glanzgedreht%2C18799%2CGLE167-AMG.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-gle-suv-2020-march-v167-mbux-operators-manual-1.pdf'),
('Mercedes-Benz','V167','GLE63 AMG',2021,2026,'Standard AMG GLE63 S 21-inch package','United States',true,'21x10 ET54','21x11 ET49','275/45R21 front / 315/40R21 rear','5x112','66.6mm','verified','The current US-market V167 high-performance SUV is the AMG GLE63 S, represented by this catalog row. Mercedes-Benz USA specifies 21x10 front and 21x11 rear wheels with 275/45R21 and 315/40R21 tires as standard. Mercedes-Benz factory homologation documentation identifies the non-GLE53 21-inch AMG offsets as ET54 front and ET49 rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-mercedes-amg-gle-63-s-suv ; https://www.kunzmann.de/produkt/amg-21-zoll-felgensatz-gle-v167-vielspeichen-rad-schwarz-glanzgedreht%2C18799%2CGLE167-AMG.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-gle-suv-2020-march-v167-mbux-operators-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_v167_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_v167_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='V167' and active
order by trim,is_default desc,year_start;
