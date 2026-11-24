-- Offset Lab Fitment
-- Pack 120: verified factory baselines for the remaining Mercedes-AMG rows.
-- Covers C190 GT S / GT R, C197 SLS AMG, C117 CLA45, W166 GLE63,
-- W222 S63 Sedan, and X290 GT 63 S. Plain SQL and safe to re-run.

update public.vehicle_models set display_name='C190 AMG GT',year_start=2016,year_end=2021
where make='Mercedes-Benz' and model='C190';
update public.vehicle_models set display_name='C197 SLS AMG',year_start=2011,year_end=2014
where make='Mercedes-Benz' and model='C197';
update public.vehicle_models set display_name='C117 AMG CLA45',year_start=2014,year_end=2019
where make='Mercedes-Benz' and model='CLA45';
update public.vehicle_models set display_name='W166 AMG GLE63 SUV',year_start=2016,year_end=2019
where make='Mercedes-Benz' and model='GLE63';
update public.vehicle_models set display_name='W222 AMG S63 Sedan',year_start=2018,year_end=2020
where make='Mercedes-Benz' and model='S63';
update public.vehicle_models set display_name='X290 AMG GT 4-Door',year_start=2019,year_end=2023
where make='Mercedes-Benz' and model='X290';

update public.fitment_presets
set factory_front='19x9 ET61',factory_rear='20x11 ET68',
    factory_tire='265/35R19 front / 295/30R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='C190' and trim='GT S' and active is not false;

update public.fitment_presets
set factory_front='19x10 ET56',factory_rear='20x12 ET52',
    factory_tire='275/35R19 front / 325/30R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='C190' and trim='GT R' and active is not false;

update public.fitment_presets
set factory_front='19x9.5 ET59',factory_rear='20x11 ET68',
    factory_tire='265/35R19 front / 295/30R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='C197' and trim='Base' and active is not false;

update public.fitment_presets
set factory_front='18x8 ET48',factory_rear='18x8 ET48',
    factory_tire='235/40R18 front / 235/40R18 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='CLA45' and trim='Base' and active is not false;

update public.fitment_presets
set factory_front='20x9 ET57',factory_rear='20x9 ET57',
    factory_tire='265/45R20 front / 265/45R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='GLE63' and trim='SUV' and active is not false;

update public.fitment_presets
set factory_front='20x8.5 ET39',factory_rear='20x9.5 ET39',
    factory_tire='255/40R20 front / 285/35R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='S63' and trim='Sedan' and active is not false;

update public.fitment_presets
set factory_front='20x9.5 ET25.1',factory_rear='20x11 ET20',
    factory_tire='265/40R20 front / 295/35R20 rear',bolt_pattern='5x112',center_bore='66.6mm'
where make='Mercedes-Benz' and model='X290' and trim='GT 63 S' and active is not false;

create temp table if not exists mercedes_remaining_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table mercedes_remaining_verified_baselines;

insert into mercedes_remaining_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('Mercedes-Benz','C190','GT S',2016,2020,'Standard AMG GT S 19/20-inch package','United States',true,'19x9 ET61','20x11 ET68','265/35R19 front / 295/30R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 19x9 front and 20x11 rear wheels with 265/35R19 and 295/30R20 tires for the C190 AMG GT S. Mercedes-AMG manufacturer certification identifies ET61 front and ET68 rear, 5x112 hardware with a 66.6 mm center bore, M14x1.5 ball-seat bolts, and 130 Nm torque. Sources: https://media.mbusa.com/news/2019-mercedes-amg-gt-and-gt-s-coupe-specifications ; https://www.kunzmann.de/produkt/reifen-und-raeder-mercedes-benz-amg-gt-c190-felgen-5-doppelspeichen-felgensatz-19-20-zoll-5-doppelspeiche%2C10241%2CAMG-ABE-GT-190.pdf'),
('Mercedes-Benz','C190','GT R',2018,2021,'Standard AMG GT R forged 19/20-inch package','United States',true,'19x10 ET56','20x12 ET52','275/35R19 front / 325/30R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA identifies 19x10 front and 20x12 rear forged wheels as standard on the C190 AMG GT R. Mercedes-AMG manufacturer certification specifies ET56 front and ET52 rear with 275/35R19 and 325/30R20 XL tires. C190 hardware is 5x112 with a 66.6 mm center bore, M14x1.5 ball-seat bolts, and 130 Nm torque. Sources: https://media.mbusa.com/news/2019-mercedes-amg-gt-coupe-quick-reference-guide ; https://www.kunzmann.de/produkt/19-20-inch-forged-wheels-amg-gtc-c190-r190-cross-spoke-black%2C41482%2CAMGGT_C190_2021_11_02.pdf'),
('Mercedes-Benz','C197','Base',2011,2014,'Standard SLS AMG 19/20-inch package','United States',true,'19x9.5 ET59','20x11 ET68','265/35R19 front / 295/30R20 rear','5x112','66.6mm','verified','The Mercedes-Benz SLS AMG owner manual specifies 19x9.5 ET59 front and 20x11 ET68 rear wheels with 265/35R19 and 295/30R20 tires for the standard 7-spoke package; it also documents an ET60 front alternate. Hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts. Source: https://www.manualslib.com/manual/2468975/Mercedes-Benz-Sls-Amg.html?page=235'),
('Mercedes-Benz','CLA45','Base',2014,2019,'Standard C117 AMG CLA45 18-inch package','United States',true,'18x8 ET48','18x8 ET48','235/40R18 front / 235/40R18 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies square 18x8 wheels and 235/40R18 tires for the C117 AMG CLA45. The Mercedes-AMG CLA price and equipment guide identifies the standard wheel offset as ET48. C117 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts. Sources: https://media.mbusa.com/news/2019-mercedes-amg-cla-45-coupe-specifications ; https://www.kunzmann.de/tiny/Marken/Mercedes_Benz/CLA/Coupe/Preisliste-Mercedes-Benz-CLA-Coup%C3%A9-Shooting-Brake-Kunzmann.pdf'),
('Mercedes-Benz','GLE63','SUV',2016,2019,'Standard W166 AMG GLE63 20-inch package','United States',true,'20x9 ET57','20x9 ET57','265/45R20 front / 265/45R20 rear','5x112','66.6mm','verified','This catalog row represents the W166 AMG GLE63 SUV. Mercedes-Benz USA specifies square 20x9 wheels and 265/45R20 tires for the standard GLE63; Mercedes-AMG manufacturer certification identifies ET57 for model 166074. W166 hardware is 5x112 with a 66.6 mm center bore, M14x1.5 ball-seat bolts, and 150 Nm torque. Sources: https://media.mbusa.com/news/2019-mercedes-amg-gle-63-and-gle-63-s-suv-specifications ; https://www.kunzmann.de/produkt/banden-en-velgen-mercedes-benz-ml-klasse-w166-velgen-amg-19-inch-velgenset%2C5779%2CAMG-ABE-ML-Klasse-166.pdf'),
('Mercedes-Benz','S63','Sedan',2018,2020,'Standard W222 AMG S63 20-inch package','United States',true,'20x8.5 ET39','20x9.5 ET39','255/40R20 front / 285/35R20 rear','5x112','66.6mm','verified','This catalog row represents the facelift W222 AMG S63 Sedan. The Mercedes-Benz USA model-year ordering guide specifies 20x8.5 ET39 front and 20x9.5 ET39 rear wheels with 255/40R20 and 285/35R20 tires. Mercedes-AMG manufacturer certification confirms the offsets, 5x112 hardware with a 66.6 mm center bore, M14x1.5 ball-seat bolts, and 150 Nm torque. Sources: https://manuals.plus/m/a2ec6a9ddcd364d27186b6dbd395a411953b954c150b08f3914ca804dd9a2cba.pdf ; https://www.kunzmann.de/produkt/reifen-und-raeder-mercedes-benz-s-klasse-w222-felgen-amg-20-zoll-felgensatz-night-edition-original%2C14468%2CS222-AMG.pdf'),
('Mercedes-Benz','X290','GT 63 S',2019,2023,'Standard X290 AMG GT63 S 20-inch package','United States',true,'20x9.5 ET25.1','20x11 ET20','265/40R20 front / 295/35R20 rear','5x112','66.6mm','verified','Mercedes-Benz USA specifies 20x9.5 front and 20x11 rear wheels with 265/40R20 and 295/35R20 tires as standard on the X290 AMG GT63 S. Mercedes-AMG wheel documentation identifies ET25.1 front and ET20 rear. X290 hardware is 5x112 with a 66.6 mm center bore and M14x1.5 ball-seat bolts. Sources: https://media.mbusa.com/news/a-new-addition-to-the-family-new-mercedes-amg-gt-4-door-coupe ; https://www.kunzmann.de/shop/de-de/p/amg-winterraeder-komplettradsatz-20-zoll-amg-gt-4-tuerer-x290-glanzgedreht-original-mercedes-benz-27988.htm');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from mercedes_remaining_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from mercedes_remaining_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Mercedes-Benz'
  and (model,trim) in (('C190','GT S'),('C190','GT R'),('C197','Base'),('CLA45','Base'),('GLE63','SUV'),('S63','Sedan'),('X290','GT 63 S'))
  and active
order by model,trim,is_default desc,year_start;
