-- Offset Lab Fitment
-- Pack 102: verified BMW F06/F12/F13 6 Series and M6 baselines.
-- Uses BMW North America pricing guides and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set display_name='F06 6 Series Gran Coupe',year_start=2013,year_end=2019
where make='BMW' and model='F06';
update public.vehicle_models set display_name='F12 6 Series Convertible',year_start=2012,year_end=2018
where make='BMW' and model='F12';
update public.vehicle_models set display_name='F13 6 Series Coupe',year_start=2012,year_end=2018
where make='BMW' and model='F13';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET30',factory_rear='18x8 ET30',
    factory_tire='245/45R18 front / 245/45R18 rear'
where make='BMW' and model in ('F06','F12','F13')
  and trim in ('640i Gran Coupe','640i Convertible','640i Coupe') and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x8.5 ET33',factory_rear='19x8.5 ET33',
    factory_tire='245/40R19 front / 245/40R19 rear'
where make='BMW' and model in ('F06','F12','F13')
  and trim in ('650i Gran Coupe','650i Convertible','650i Coupe') and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x9.5 ET31',factory_rear='19x10.5 ET19',
    factory_tire='265/40R19 front / 295/35R19 rear'
where make='BMW' and model in ('F12','F13')
  and trim in ('M6 Convertible','M6 Coupe') and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='20x9.5 ET31',factory_rear='20x10.5 ET19',
    factory_tire='265/35R20 front / 295/30R20 rear'
where make='BMW' and model='F06' and trim='M6 Gran Coupe' and active is not false;

-- OEM+ retains the factory tire package and moves the wheels outward 5 mm.
update public.fitment_presets
set front='18x8.5 ET25',rear='18x8.5 ET25',front_tire='245/45R18',rear_tire='245/45R18'
where make='BMW' and model in ('F06','F12','F13')
  and trim in ('640i Gran Coupe','640i Convertible','640i Coupe')
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x8.5 ET28',rear='19x8.5 ET28',front_tire='245/40R19',rear_tire='245/40R19'
where make='BMW' and model in ('F06','F12','F13')
  and trim in ('650i Gran Coupe','650i Convertible','650i Coupe')
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='19x9.5 ET26',rear='19x10.5 ET14',front_tire='265/40R19',rear_tire='295/35R19'
where make='BMW' and model in ('F12','F13') and trim in ('M6 Convertible','M6 Coupe')
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='20x9.5 ET26',rear='20x10.5 ET14',front_tire='265/35R20',rear_tire='295/30R20'
where make='BMW' and model='F06' and trim='M6 Gran Coupe'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f06_f12_f13_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f06_f12_f13_verified_baselines;

insert into bmw_f06_f12_f13_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F06','640i Gran Coupe',2013,2019,'Standard 365 18-inch all-season package','United States',true,'18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x120','72.6mm','verified','BMW USA pricing documentation identifies the F06 640i Gran Coupe standard 365 package as 18x8 front and rear with 245/45R18 all-season run-flat tires. The BMW OEM parts catalog identifies style 365 as 8Jx18 ET30 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403282 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1596&id=LW31-EUR---F13-BMW-640i'),
('BMW','F12','640i Convertible',2012,2018,'Standard 365 18-inch all-season package','United States',true,'18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x120','72.6mm','verified','BMW USA pricing documentation identifies the F12 640i Convertible standard 365 package as 18x8 front and rear with 245/45R18 all-season run-flat tires. The BMW OEM parts catalog identifies style 365 as 8Jx18 ET30 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403281 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1596&id=LW31-EUR---F13-BMW-640i'),
('BMW','F13','640i Coupe',2012,2018,'Standard 365 18-inch all-season package','United States',true,'18x8 ET30','18x8 ET30','245/45R18 front / 245/45R18 rear','5x120','72.6mm','verified','BMW USA pricing documentation identifies the F13 640i Coupe standard 365 package as 18x8 front and rear with 245/45R18 all-season run-flat tires. The BMW OEM parts catalog identifies style 365 as 8Jx18 ET30 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403281 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1596&id=LW31-EUR---F13-BMW-640i'),
('BMW','F06','650i Gran Coupe',2013,2019,'Standard 423/367 19-inch all-season package','United States',true,'19x8.5 ET33','19x8.5 ET33','245/40R19 front / 245/40R19 rear','5x120','72.6mm','verified','BMW USA pricing documentation identifies the F06 650i Gran Coupe standard all-season package as 19x8.5 front and rear with 245/40R19 tires. The BMW OEM parts catalog identifies the corresponding 367 geometry as 8.5Jx19 ET33 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403289 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1603&id=LZ32-EUR-05_2010_F12-BMW-650i'),
('BMW','F12','650i Convertible',2012,2018,'Standard 367 19-inch all-season package','United States',true,'19x8.5 ET33','19x8.5 ET33','245/40R19 front / 245/40R19 rear','5x120','72.6mm','verified','BMW USA documentation identifies the F12 650i Convertible standard package as 19x8.5 front and rear with 245/40R19 all-season run-flat tires. The BMW OEM parts catalog identifies style 367 as 8.5Jx19 ET33 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403291 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1603&id=LZ32-EUR-05_2010_F12-BMW-650i'),
('BMW','F13','650i Coupe',2012,2018,'Standard 367 19-inch all-season package','United States',true,'19x8.5 ET33','19x8.5 ET33','245/40R19 front / 245/40R19 rear','5x120','72.6mm','verified','BMW USA documentation identifies the F13 650i Coupe standard package as 19x8.5 front and rear with 245/40R19 all-season run-flat tires. The BMW OEM parts catalog identifies style 367 as 8.5Jx19 ET33 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0099934EN_US/the-all-new-bmw-650i-coupe ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1603&id=LZ32-EUR-05_2010_F12-BMW-650i'),
('BMW','F12','M6 Convertible',2013,2018,'Standard 344M 19-inch package','United States',true,'19x9.5 ET31','19x10.5 ET19','265/40R19 front / 295/35R19 rear','5x120','72.6mm','verified','BMW USA documentation identifies the F12 M6 Convertible standard 344M package as 19x9.5 front and 19x10.5 rear with 265/40R19 and 295/35R19 tires. The BMW OEM parts catalog identifies the 344M wheels as 9.5Jx19 ET31 front and 10.5Jx19 ET19 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403283 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1731&id=LZ92-EUR-03_2011_F12-BMW-M6'),
('BMW','F13','M6 Coupe',2013,2018,'Standard 344M 19-inch package','United States',true,'19x9.5 ET31','19x10.5 ET19','265/40R19 front / 295/35R19 rear','5x120','72.6mm','verified','BMW USA documentation identifies the F13 M6 Coupe standard 344M package as 19x9.5 front and 19x10.5 rear with 265/40R19 and 295/35R19 tires. The BMW OEM parts catalog identifies the 344M wheels as 9.5Jx19 ET31 front and 10.5Jx19 ET19 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403283 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1731&id=LZ92-EUR-03_2011_F12-BMW-M6'),
('BMW','F06','M6 Gran Coupe',2014,2018,'Standard 433M 20-inch package','United States',true,'20x9.5 ET31','20x10.5 ET19','265/35R20 front / 295/30R20 rear','5x120','72.6mm','verified','BMW USA documentation identifies the F06 M6 Gran Coupe standard 433M package as 20x9.5 front and 20x10.5 rear with 265/35R20 and 295/30R20 tires. The BMW OEM parts catalog identifies the 433M wheels as 9.5Jx20 ET31 front and 10.5Jx20 ET19 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0198105EN_US/403283 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1809&id=6E92-EUR-02_2015_F06N-BMW-M6');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_f06_f12_f13_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_f06_f12_f13_verified_baselines source
where not exists (select 1 from public.fitment_factory_baselines target where target.make=source.make and target.model=source.model and target.trim=source.trim and target.package_name=source.package_name);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('F06','F12','F13') and active
order by model,trim,is_default desc,year_start;
