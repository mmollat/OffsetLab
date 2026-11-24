-- Offset Lab Fitment
-- Pack 113: verified Mercedes-Benz W213/S213 E-Class factory baselines.
-- Covers the standard E-Class sedan, AMG E53, AMG E63, and the US-market
-- AMG E63 S sedan/wagon rows. Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='W213 / S213 E-Class / AMG',year_start=2017,year_end=2023
where make='Mercedes-Benz' and model='W213';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='18x8 ET43',factory_rear='18x8 ET43',
    factory_tire='245/45R18 front / 245/45R18 rear'
where make='Mercedes-Benz' and model='W213' and trim='E350 / E450' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8 ET20',factory_rear='19x9 ET49',
    factory_tire='245/40R19 front / 275/35R19 rear'
where make='Mercedes-Benz' and model='W213' and trim='E53 AMG' and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9.5 ET25',factory_rear='20x10 ET55',
    factory_tire='265/35R20 front / 295/30R20 rear'
where make='Mercedes-Benz' and model='W213'
  and trim in ('E63 AMG','E63 S Sedan','E63 S Wagon') and active is not false;

-- Keep OEM+ visibly distinct from the verified factory package: retain the
-- factory widths/tires while moving the wheel faces outward only 3 mm front
-- and 5 mm rear. This is the conservative factory-plus step, not an OEM alias.
update public.fitment_presets
set front='20x9.5 ET22',rear='20x10 ET50',
    front_tire='265/35R20',rear_tire='295/30R20',
    subtitle='Subtle factory-plus E63 stance',
    verdict='Conservative E63 OEM+ fitment with a 3 mm front and 5 mm rear outward change from the verified factory package.',
    warnings=array['Verify brake clearance.','Confirm tire-to-fender clearance at full compression.']::text[]
where make='Mercedes-Benz' and model='W213'
  and trim in ('E63 AMG','E63 S Sedan','E63 S Wagon')
  and style='oemplus' and active is not false;

create temp table if not exists mercedes_w213_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_w213_verified_baselines;

insert into mercedes_w213_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','W213','E350 / E450',2017,2023,'Standard sedan 18-inch package','United States',true,'18x8 ET43','18x8 ET43','245/45R18 front / 245/45R18 rear','5x112','66.6mm','verified','This combined catalog row uses the US-market W213 E350/E450 standard 18-inch sedan package. Mercedes-Benz USA specifies 18x8 wheels and 245/45R18 tires front and rear for the E450 4MATIC Sedan; Mercedes-Benz factory wheel documentation identifies the W213 18x8 wheel as ET43. W213 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-mercedes-benz-e-450-4matic-sedan ; https://www.kunzmann.de/produkt/amg-19-zoll-felgen-satz-e-klasse-limousine-w213-genuine-mercedes-amg%2C27795%2CBR213LimoN2.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-qa/pdf/mercedes-e-class-saloon-2022-july-w213-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','W213','E53 AMG',2019,2023,'Standard AMG 19-inch package','United States',true,'19x8 ET20','19x9 ET49','245/40R19 front / 275/35R19 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies the W213 AMG E53 standard package as 19x8 front and 19x9 rear with 245/40R19 and 275/35R19 tires. Mercedes-Benz factory wheel documentation identifies the AMG axle offsets as ET20 front and ET49 rear. W213 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-mercedes-amg-e-53-sedan-specifications ; https://www.kunzmann.de/produkt/amg-19-inch-wheels-e-class-sedan-w213-black-genuine-mercedes-amg%2C27821%2CBR213LimoN2.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-qa/pdf/mercedes-e-class-saloon-2022-july-w213-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','W213','E63 AMG',2017,2018,'Standard AMG E63 20-inch package','Global',true,'20x9.5 ET25','20x10 ET55','265/35R20 front / 295/30R20 rear','5x112','66.6mm','verified','The W213 AMG E63 factory homologation lists the same 20-inch axle package used by the E63 S: 20x9.5 ET25 front and 20x10 ET55 rear with 265/35R20 and 295/30R20 tires. This row represents the non-S E63 offered outside the US market. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://www.kunzmann.de/produkt/amg-19-inch-wheels-e-class-sedan-w213-black-genuine-mercedes-amg%2C27821%2CBR213LimoN2.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-qa/pdf/mercedes-e-class-saloon-2022-july-w213-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','W213','E63 S Sedan',2018,2023,'Standard AMG E63 S 20-inch package','United States',true,'20x9.5 ET25','20x10 ET55','265/35R20 front / 295/30R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 20x9.5 front and 20x10 rear wheels with 265/35ZR20 and 295/30ZR20 tires as standard on the W213 AMG E63 S Sedan. Mercedes-Benz factory homologation documentation specifies ET25 front and ET55 rear. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-mercedes-amg-e-63-s-sedan-specifications ; https://www.kunzmann.de/produkt/amg-19-inch-wheels-e-class-sedan-w213-black-genuine-mercedes-amg%2C27821%2CBR213LimoN2.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-qa/pdf/mercedes-e-class-saloon-2022-july-w213-mbux-owners-manual-1.pdf'),
('Mercedes-Benz','W213','E63 S Wagon',2018,2023,'Standard AMG E63 S wagon 20-inch package','United States',true,'20x9.5 ET25','20x10 ET55','265/35R20 front / 295/30R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 20x9.5 front and 20x10 rear wheels with 265/35ZR20 and 295/30ZR20 tires as standard on the S213 AMG E63 S Wagon. Mercedes-Benz factory homologation documentation specifies ET25 front and ET55 rear for the corresponding AMG package. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts tightened to 150 Nm. Sources: https://media.mbusa.com/news/2021-mercedes-amg-e-63-s-wagon-specifications ; https://www.kunzmann.de/produkt/amg-19-inch-wheels-e-class-sedan-w213-black-genuine-mercedes-amg%2C27821%2CBR213LimoN2.pdf ; https://static.oneweb.mercedes-benz.com/css-oom-assets/en-qa/pdf/mercedes-e-class-saloon-2022-july-w213-mbux-owners-manual-1.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_w213_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_w213_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz' and model='W213' and active
order by trim,is_default desc,year_start;
