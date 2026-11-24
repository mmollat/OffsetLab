-- Offset Lab Fitment
-- Pack 112: verified Mercedes-Benz W206 C-Class factory baselines.
-- Covers C300, AMG C43, AMG C63 S E Performance, and the existing C300
-- Premium/AMG Line package rows. Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='W206 C-Class / AMG',year_start=2022,year_end=2026
where make='Mercedes-Benz' and model='W206';

update public.vehicle_models
set display_name='W206 C300 Packages',year_start=2022,year_end=2026
where make='Mercedes-Benz' and model='W206 C300';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET40',factory_rear='18x7.5 ET40',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='Mercedes-Benz' and model='W206' and trim='C300' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET43.1',factory_rear='18x8 ET43.1',
    factory_tire='245/45R18 front / 245/45R18 rear'
where make='Mercedes-Benz' and model='W206' and trim='C43 AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x9.5 ET25.1',factory_rear='19x9.5 ET61',
    factory_tire='265/40R19 front / 275/40R19 rear'
where make='Mercedes-Benz' and model='W206' and trim='C63 AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET40',factory_rear='18x7.5 ET40',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='Mercedes-Benz' and model='W206 C300' and trim='Premium' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x7.5 ET40',factory_rear='18x8.5 ET52',
    factory_tire='225/45R18 front / 245/40R18 rear'
where make='Mercedes-Benz' and model='W206 C300' and trim='AMG Line' and active is not false;

create temp table if not exists mercedes_w206_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w206_verified_baselines;

insert into mercedes_w206_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W206','C300',2022,2026,'Standard sedan 18-inch package','United States',true,'18x7.5 ET40','18x7.5 ET40','225/45R18 front / 225/45R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA lists 18-inch wheels as standard on the W206 C300 Sedan. Mercedes-Benz factory homologation documentation identifies the square package as 18x7.5 ET40 with 225/45R18 tires. W206 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/2022-mercedes-benz-c-class-sedan-quick-reference-guide ; https://www.kunzmann.de/produkt/wheels-c-class-w206-17-inch-silver-genuine-mercedes-benz%2C41805%2CC-Klasse_W206_2025_06_19.pdf'),
('Mercedes-Benz','W206','C43 AMG',2023,2026,'Standard AMG 18-inch package','United States',true,'18x8 ET43.1','18x8 ET43.1','245/45R18 front / 245/45R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies the W206 AMG C43 standard package as 18x8 front and rear with 245/45ZR18 tires. Mercedes-Benz factory homologation documentation specifies ET43.1. W206 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/the-new-mercedes-amg-c-43-sedan-more-power-greater-efficiency ; https://www.kunzmann.de/produkt/wheels-c-class-w206-17-inch-silver-genuine-mercedes-benz%2C41805%2CC-Klasse_W206_2025_06_19.pdf'),
('Mercedes-Benz','W206','C63 AMG',2024,2026,'Standard AMG C63 S E Performance 19-inch package','United States',true,'19x9.5 ET25.1','19x9.5 ET61','265/40R19 front / 275/40R19 rear','5x112','66.6mm','verified','The current W206 high-performance sedan is the AMG C63 S E Performance. Mercedes-Benz USA identifies its standard package as 19x9.5 front and rear with 265/40R19 and 275/40R19 tires. Mercedes-Benz factory homologation documentation specifies ET25.1 front and ET61 rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/the-new-mercedes-amg-c-63-s-e-performance-the-dawn-of-a-new-era ; https://www.kunzmann.de/produkt/wheels-c-class-w206-17-inch-silver-genuine-mercedes-benz%2C41805%2CC-Klasse_W206_2025_06_19.pdf'),
('Mercedes-Benz','W206 C300','Premium',2022,2026,'Premium standard 18-inch package','United States',true,'18x7.5 ET40','18x7.5 ET40','225/45R18 front / 225/45R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA lists 18-inch wheels as standard on the W206 C300 Sedan. Mercedes-Benz factory homologation documentation identifies the square package as 18x7.5 ET40 with 225/45R18 tires. W206 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/2022-mercedes-benz-c-class-sedan-quick-reference-guide ; https://www.kunzmann.de/produkt/wheels-c-class-w206-17-inch-silver-genuine-mercedes-benz%2C41805%2CC-Klasse_W206_2025_06_19.pdf'),
('Mercedes-Benz','W206 C300','AMG Line',2022,2026,'AMG Line staggered 18-inch package','United States',true,'18x7.5 ET40','18x8.5 ET52','225/45R18 front / 245/40R18 rear','5x112','66.6mm','verified','Mercedes-Benz factory homologation documentation identifies the W206 staggered 18-inch package as 18x7.5 ET40 front and 18x8.5 ET52 rear with 225/45R18 and 245/40R18 tires. Mercedes-Benz USA lists the AMG Line as an available C300 package. W206 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 130 Nm. Sources: https://media.mbusa.com/news/2022-mercedes-benz-c-class-sedan-quick-reference-guide ; https://www.kunzmann.de/produkt/wheels-c-class-w206-17-inch-silver-genuine-mercedes-benz%2C41805%2CC-Klasse_W206_2025_06_19.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w206_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w206_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model in ('W206','W206 C300') and active
order by model,trim,is_default desc,year_start;
