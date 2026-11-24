-- Offset Lab Fitment
-- Pack 116: verified Mercedes-Benz X253 GLC factory baselines.
-- Covers GLC300, AMG GLC43, and AMG GLC63. Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='X253 GLC SUV / AMG',year_start=2016,year_end=2022
where make='Mercedes-Benz' and model='X253';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET38',factory_rear='18x8 ET38',
    factory_tire='235/60R18 front / 235/60R18 rear'
where make='Mercedes-Benz' and model='X253' and trim='GLC300'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x8.5 ET40',factory_rear='20x9.5 ET22',
    factory_tire='255/45R20 front / 285/40R20 rear'
where make='Mercedes-Benz' and model='X253' and trim='GLC43 AMG'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET30',factory_rear='20x10 ET28',
    factory_tire='265/45R20 front / 295/40R20 rear'
where make='Mercedes-Benz' and model='X253' and trim='GLC63 AMG'
  and active is not false;

-- Replace the undersized legacy GLC300 OEM+ setup with Mercedes' approved
-- square 19-inch package.
update public.fitment_presets
set front='19x8 ET38',rear='19x8 ET38',
    front_tire='235/55R19',rear_tire='235/55R19',
    subtitle='Mercedes 19-inch factory-plus stance',
    verdict='Factory-plus X253 fitment using the Mercedes-Benz approved square 19-inch package with near-stock diameter.',
    warnings=array['Use SUV load-rated tires.','Verify the wheel part number is approved for the exact drivetrain and brake package.']::text[]
where make='Mercedes-Benz' and model='X253' and trim='GLC300'
  and style='oemplus' and active is not false;

-- Use Mercedes' approved 21-inch AMG package instead of the legacy rear
-- offset that moved the wheel 17 mm unnecessarily inward.
update public.fitment_presets
set front='21x9.5 ET30',rear='21x10 ET28',
    front_tire='265/40R21',rear_tire='295/35R21',
    subtitle='Mercedes 21-inch factory-plus AMG stance',
    verdict='Factory-plus GLC63 fitment using Mercedes-Benz approved 21-inch AMG geometry.',
    warnings=array['Use MO/MO1-equivalent XL load-rated tires.','Confirm the selected wheel clears the AMG brake package.']::text[]
where make='Mercedes-Benz' and model='X253' and trim='GLC63 AMG'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_x253_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_x253_verified_baselines;

insert into mercedes_x253_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','X253','GLC300',2016,2022,'Standard SUV 18-inch package','United States',true,'18x8 ET38','18x8 ET38','235/60R18 front / 235/60R18 rear','5x112','66.6mm','verified','This row represents the US-market X253 GLC300/GLC300 4MATIC SUV standard package. Mercedes-Benz USA identifies 18-inch wheels as standard; Mercedes-Benz factory homologation documentation specifies the square 18x8 ET38 package with 235/60R18 tires for the GLC300 4MATIC. X253 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-glc-suv-quick-reference-guide ; https://www.kunzmann.de/produkt/63-amg-summer-wheels-21-inch-glc-suv-x253-continental-genuine-mercedes-benz%2C44089%2CGLC_X253_2022_01_12.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-glc-suv-2021-january-x253-mbux-operators-manual-1.pdf'),
('Mercedes-Benz','X253','GLC43 AMG',2017,2022,'Standard AMG 20-inch package','United States',true,'20x8.5 ET40','20x9.5 ET22','255/45R20 front / 285/40R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 20x8.5 front and 20x9.5 rear wheels with 255/45R20 and 285/40R20 tires as standard on the X253 AMG GLC43 SUV. Mercedes-Benz factory homologation documentation specifies ET40 front and ET22 rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-mercedes-amg-glc-43-suv-specifications ; https://www.kunzmann.de/produkt/63-amg-summer-wheels-21-inch-glc-suv-x253-continental-genuine-mercedes-benz%2C44089%2CGLC_X253_2022_01_12.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-glc-suv-2021-january-x253-mbux-operators-manual-1.pdf'),
('Mercedes-Benz','X253','GLC63 AMG',2018,2022,'Standard AMG 20-inch package','United States',true,'20x9.5 ET30','20x10 ET28','265/45R20 front / 295/40R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 20x9.5 front and 20x10 rear wheels with 265/45R20 and 295/40R20 tires as standard on the X253 AMG GLC63 SUV. Mercedes-Benz factory homologation documentation specifies ET30 front and ET28 rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2020-mercedes-amg-glc-63-suv-specifications ; https://www.kunzmann.de/produkt/63-amg-summer-wheels-21-inch-glc-suv-x253-continental-genuine-mercedes-benz%2C44089%2CGLC_X253_2022_01_12.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-glc-suv-2021-january-x253-mbux-operators-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_x253_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_x253_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='X253' and active
order by trim,is_default desc,year_start;
