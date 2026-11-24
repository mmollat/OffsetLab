-- Offset Lab Fitment
-- Pack 110: verified Mercedes-Benz W205 C-Class factory baselines.
-- Covers the core model rows plus the existing C300 Base/Sport package rows.
-- Uses Mercedes-Benz USA specifications, the official W205 operator's manual,
-- and Mercedes-AMG homologation documentation. Plain SQL and safe to re-run.

update public.vehicle_models
set display_name='W205 C-Class / AMG',year_start=2015,year_end=2021
where make='Mercedes-Benz' and model='W205';

update public.vehicle_models
set display_name='W205 C300 Packages',year_start=2015,year_end=2021
where make='Mercedes-Benz' and model='W205 C300';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='17x7 ET48.5',factory_rear='17x7 ET48.5',
    factory_tire='225/50R17 front / 225/50R17 rear'
where make='Mercedes-Benz' and model='W205' and trim='C300' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET33',factory_rear='18x8.5 ET49',
    factory_tire='225/45R18 front / 245/40R18 rear'
where make='Mercedes-Benz' and model='W205' and trim='C43 AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8.5 ET38',factory_rear='18x9.5 ET56',
    factory_tire='245/40R18 front / 265/40R18 rear'
where make='Mercedes-Benz' and model='W205' and trim='C63 AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET38',factory_rear='19x9.5 ET56',
    factory_tire='245/35R19 front / 265/35R19 rear'
where make='Mercedes-Benz' and model='W205' and trim='C63 S AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='17x7 ET48.5',factory_rear='17x7 ET48.5',
    factory_tire='225/50R17 front / 225/50R17 rear'
where make='Mercedes-Benz' and model='W205 C300' and trim='Base' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET44',factory_rear='18x8.5 ET49',
    factory_tire='225/45R18 front / 245/40R18 rear'
where make='Mercedes-Benz' and model='W205 C300' and trim='Sport' and active is not false;

create temp table if not exists mercedes_w205_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w205_verified_baselines;

insert into mercedes_w205_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W205','C300',2015,2021,'Standard sedan 17-inch package','United States',true,'17x7 ET48.5','17x7 ET48.5','225/50R17 front / 225/50R17 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 17x7 wheels with 225/50R17 tires as the standard C300 Sedan package. The official W205 operator manual specifies ET48.5. W205 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/2019-mercedes-benz-c-300-and-c-300-4matic-sedan ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-bh/pdf/mercedes-c-class-saloon-2014-may-w205-comand-owners-manual-1.pdf'),
('Mercedes-Benz','W205','C43 AMG',2017,2021,'Standard AMG 18-inch package','United States',true,'18x7.5 ET33','18x8.5 ET49','225/45R18 front / 245/40R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 18x7.5 front and 18x8.5 rear wheels with 225/45R18 and 245/40R18 tires as standard on the AMG C43 Sedan. Mercedes-AMG homologation documentation specifies ET33 front and ET49 rear and M14x1.5 ball-seat bolts tightened to 130 Nm. Hardware is 5x112 with a 66.6 mm center bore. Sources: https://media.mbusa.com/news/2019-mercedes-amg-c-43-sedan-specifications ; https://www.paul-parts.com/wp-content/uploads/2020/02/W205-S205-C205-A205-AMG.pdf'),
('Mercedes-Benz','W205','C63 AMG',2015,2021,'Standard AMG 18-inch package','United States',true,'18x8.5 ET38','18x9.5 ET56','245/40R18 front / 265/40R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 18-inch staggered wheels with 245/40R18 and 265/40R18 tires as standard on the AMG C63 Sedan. Mercedes-AMG homologation documentation specifies 18x8.5 ET38 front and 18x9.5 ET56 rear and M14x1.5 ball-seat bolts tightened to 130 Nm. Hardware is 5x112 with a 66.6 mm center bore. Sources: https://media.mbusa.com/news/2018-mercedes-amg-c63-sedan-and-c63-s-sedan ; https://www.paul-parts.com/wp-content/uploads/2020/02/W205-S205-C205-A205-AMG.pdf'),
('Mercedes-Benz','W205','C63 S AMG',2015,2021,'Standard AMG 19-inch package','United States',true,'19x8.5 ET38','19x9.5 ET56','245/35R19 front / 265/35R19 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 19-inch staggered wheels with 245/35R19 and 265/35R19 tires as standard on the AMG C63 S Sedan. Mercedes-AMG homologation documentation specifies 19x8.5 ET38 front and 19x9.5 ET56 rear and M14x1.5 ball-seat bolts tightened to 130 Nm. Hardware is 5x112 with a 66.6 mm center bore. Sources: https://media.mbusa.com/news/2018-mercedes-amg-c63-sedan-and-c63-s-sedan ; https://www.paul-parts.com/wp-content/uploads/2020/02/W205-S205-C205-A205-AMG.pdf'),
('Mercedes-Benz','W205 C300','Base',2015,2021,'Base sedan 17-inch package','United States',true,'17x7 ET48.5','17x7 ET48.5','225/50R17 front / 225/50R17 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 17x7 wheels with 225/50R17 tires as the standard C300 Sedan package. The official W205 operator manual specifies ET48.5. W205 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/2017-mercedes-benz-c300-sedan-and-c300-4matic-sedan-specifications ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-bh/pdf/mercedes-c-class-saloon-2014-may-w205-comand-owners-manual-1.pdf'),
('Mercedes-Benz','W205 C300','Sport',2015,2021,'AMG Line/Sport 18-inch package','United States',true,'18x7.5 ET44','18x8.5 ET49','225/45R18 front / 245/40R18 rear','5x112','66.6mm','verified','The Mercedes-Benz W205 operator manual identifies the staggered 18-inch package as 18x7.5 ET44 front and 18x8.5 ET49 rear with 225/45R18 and 245/40R18 tires. Mercedes-Benz USA identifies 18-inch AMG wheels as part of the C300 AMG Line/Sport package. W205 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://static.oneweb.mercedes-benz.com/css-oom-assets/en-bh/pdf/mercedes-c-class-saloon-2014-may-w205-comand-owners-manual-1.pdf ; https://media.mbusa.com/news/2017-c-class-coupe-quick-reference-guide');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w205_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w205_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model in ('W205','W205 C300') and active
order by model,trim,is_default desc,year_start;
