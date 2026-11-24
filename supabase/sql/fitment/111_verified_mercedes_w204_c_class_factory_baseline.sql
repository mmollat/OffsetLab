-- Offset Lab Fitment
-- Pack 111: verified Mercedes-Benz W204 C-Class factory baseline.
-- Uses the official Mercedes-Benz W204 operator's manual.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='W204 C-Class',year_start=2008,year_end=2014
where make='Mercedes-Benz' and model='W204';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='17x7.5 ET47',factory_rear='17x7.5 ET47',
    factory_tire='225/45R17 front / 225/45R17 rear'
where make='Mercedes-Benz' and model='W204' and trim='Base' and active is not false;

create temp table if not exists mercedes_w204_verified_baseline (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w204_verified_baseline;

insert into mercedes_w204_verified_baseline
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W204','Base',2012,2014,'C300/C300 4MATIC standard 17-inch package','United States',true,'17x7.5 ET47','17x7.5 ET47','225/45R17 front / 225/45R17 rear','5x112','66.6mm','verified','The official Mercedes-Benz W204 operator manual identifies the C300/C300 4MATIC 17-inch all-season combination as 17x7.5 ET47 front and rear with 225/45R17 tires. W204 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Source: https://static.oneweb.mercedes-benz.com/css-oom-assets/en-ca/pdf/mercedes-c-class-sedan-2013-w204-operators-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w204_verified_baseline source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w204_verified_baseline source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='W204' and active
order by trim,is_default desc,year_start;
