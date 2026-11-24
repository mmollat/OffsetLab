-- Offset Lab Fitment
-- Pack 119: verified Mercedes-Benz X167 GLS factory baselines.
-- Covers US-market GLS450 and AMG GLS63 for model years 2020-2026.
-- Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='X167 GLS SUV / AMG',year_start=2020,year_end=2026
where make='Mercedes-Benz' and model='X167';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET62.5',factory_rear='19x8.5 ET62.5',
    factory_tire='275/55R19 front / 275/55R19 rear'
where make='Mercedes-Benz' and model='X167' and trim='GLS450'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='21x9 ET45',factory_rear='21x11.5 ET45',
    factory_tire='275/50R21 front / 315/45R21 rear'
where make='Mercedes-Benz' and model='X167' and trim='GLS63 AMG'
  and active is not false;

-- Replace the inherited passenger-car package with the Mercedes-approved
-- 20-inch GLS package and full-diameter SUV tires.
update public.fitment_presets
set front='20x8.5 ET62.5',rear='20x8.5 ET62.5',
    front_tire='275/50R20',rear_tire='275/50R20',
    subtitle='Mercedes 20-inch factory-plus GLS stance',
    verdict='Factory-plus square GLS450 fitment using Mercedes-Benz approved 20-inch X167 wheel and SUV tire geometry.',
    warnings=array['Use XL SUV load-rated tires.','Confirm wheel-arch cladding option compatibility for the selected Mercedes wheel.']::text[]
where make='Mercedes-Benz' and model='X167' and trim='GLS450'
  and style='oemplus' and active is not false;

-- Correct the rear tire diameter and offsets to Mercedes' approved
-- 22-inch AMG package while retaining a distinct OEM+ step above stock.
update public.fitment_presets
set front='22x10 ET45',rear='22x11.5 ET47',
    front_tire='285/45R22',rear_tire='325/40R22',
    subtitle='Mercedes 22-inch factory-plus AMG stance',
    verdict='Factory-plus staggered GLS63 fitment using Mercedes-Benz approved 22-inch AMG geometry.',
    warnings=array['Use XL AMG-approved tires.','Confirm brake and wheel-option compatibility for the exact model year.']::text[]
where make='Mercedes-Benz' and model='X167' and trim='GLS63 AMG'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_x167_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_x167_verified_baselines;

insert into mercedes_x167_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','X167','GLS450',2020,2026,'Standard 19-inch GLS450 package','United States',true,'19x8.5 ET62.5','19x8.5 ET62.5','275/55R19 front / 275/55R19 rear','5x112','66.6mm','verified','Mercedes-Benz factory homologation and accessory documentation identifies the X167 GLS450 standard 19-inch square package as 19x8.5 ET62.5 with 275/55R19 tires. Mercedes-Benz USA confirms 19-inch wheels as standard for the launch-year GLS450. X167 hardware is 5x112 with a 66.6 mm center bore; the Mercedes-Benz operator manual specifies a 150 Nm (111 lb-ft) wheel-bolt tightening torque. Sources: https://media.mbusa.com/news/2020-mercedes-benz-gls-suv-quick-reference-guide ; https://mbmauto.hu/storage/link-files/holanckatalogus2024-9.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ab/pdf/mercedes-gls-suv-2020-march-x167-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','X167','GLS63 AMG',2021,2026,'Standard AMG 21-inch package','United States',true,'21x9 ET45','21x11.5 ET45','275/50R21 front / 315/45R21 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 21x9 front and 21x11.5 rear wheels with 275/50R21 and 315/45R21 tires as standard on the X167 AMG GLS63. Mercedes-Benz factory homologation identifies ET45 at both axles for model 167989. X167 hardware is 5x112 with a 66.6 mm center bore; the Mercedes-Benz operator manual specifies a 150 Nm (111 lb-ft) wheel-bolt tightening torque. Sources: https://media.mbusa.com/news/2021-mercedes-amg-gls-63-suv ; https://www.kunzmann.de/produkt/amg-23-zoll-schmiedefelgen-satz-gls-63-amg-x167-5-loch-silber-original-mercedes-amg%2C31936%2CBRX167_08-19.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ab/pdf/mercedes-gls-suv-2020-march-x167-mbux-owners-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_x167_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_x167_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='X167' and active
order by trim,is_default desc,year_start;
