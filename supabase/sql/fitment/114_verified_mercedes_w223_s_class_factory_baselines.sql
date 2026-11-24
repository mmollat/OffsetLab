-- Offset Lab Fitment
-- Pack 114: verified Mercedes-Benz W223 S-Class factory baselines.
-- Covers the combined S500/S580 catalog row and current AMG S63 E Performance.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='W223 S-Class / AMG',year_start=2021,year_end=2026
where make='Mercedes-Benz' and model='W223';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET31.5',factory_rear='19x8.5 ET31.5',
    factory_tire='255/45R19 front / 255/45R19 rear'
where make='Mercedes-Benz' and model='W223' and trim='S500 / S580'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET33.5',factory_rear='20x9.5 ET48.1',
    factory_tire='255/45R20 front / 255/45R20 rear'
where make='Mercedes-Benz' and model='W223' and trim='S63 AMG'
  and active is not false;

-- Replace the undersized legacy S500/S580 OEM+ tires with a verified
-- Mercedes-Benz 20-inch staggered wheel envelope. It remains distinct from
-- the square 19-inch factory baseline while preserving near-stock diameter.
update public.fitment_presets
set front='20x9 ET34',rear='20x10 ET48.1',
    front_tire='255/40R20',rear_tire='285/35R20',
    subtitle='Mercedes 20-inch factory-plus stance',
    verdict='Factory-plus W223 fitment using Mercedes-Benz 20-inch wheel geometry with near-stock tire diameter.',
    warnings=array['Use W223 load-rated tires.','Confirm brake and suspension clearance for the selected wheel design.']::text[]
where make='Mercedes-Benz' and model='W223' and trim='S500 / S580'
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_w223_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w223_verified_baselines;

insert into mercedes_w223_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W223','S500 / S580',2021,2026,'Standard 19-inch package','United States',true,'19x8.5 ET31.5','19x8.5 ET31.5','255/45R19 front / 255/45R19 rear','5x112','66.6mm','verified','This combined catalog row represents the US-market W223 S500 4MATIC and S580 4MATIC standard wheel package. Mercedes-Benz USA specifies 19x8.5 ET31.5 wheels and 255/45R19 tires front and rear for both models. W223 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/the-new-mercedes-benz-s-class-refined-in-every-detail ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-lb/pdf/mercedes-s-class-saloon-2021-march-w223-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','W223','S63 AMG',2024,2026,'Standard AMG 20-inch package','United States',true,'20x9.5 ET33.5','20x9.5 ET48.1','255/45R20 front / 255/45R20 rear','5x112','66.6mm','verified','The current W223 performance sedan is the AMG S63 E Performance. Mercedes-Benz USA identifies 20-inch AMG wheels as standard. Mercedes-Benz Originalteile documents the corresponding front and rear AMG 20-inch geometry as 20x9.5 ET33.5 and 20x9.5 ET48.1 with 255/45R20 tires; the complete-wheel listing uses the approved winter tire variant while confirming the factory wheel and tire envelope. W223 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2025-mercedes-amg-s-63-e-performance-quick-reference-guide ; https://www.originalteile.mercedes-benz.de/20-zoll-winterrad-vorderachse-fuer-w223-s63-e-amg/q440141113800 ; https://www.originalteile.mercedes-benz.de/20-zoll-winterrad-hinterachse-fuer-w223-s63-e-amg/q440141113810 ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-lb/pdf/mercedes-s-class-saloon-2021-march-w223-mbux-owners-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w223_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w223_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='W223' and active
order by trim,is_default desc,year_start;
