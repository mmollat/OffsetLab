-- Offset Lab Fitment
-- Pack 105: verified BMW F30 3 Series and F32 4 Series factory baselines.
-- Uses BMW North America pricing guides and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set display_name='F30 3 Series Sedan',year_start=2012,year_end=2018
where make='BMW' and model='F30';
update public.vehicle_models set display_name='F32 4 Series Coupe',year_start=2014,year_end=2020
where make='BMW' and model='F32';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='17x7.5 ET37',factory_rear='17x7.5 ET37',
    factory_tire='225/50R17 front / 225/50R17 rear'
where make='BMW' and model='F30' and trim='330i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET34',factory_rear='18x8 ET34',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='BMW' and model='F30' and trim='335i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET34',factory_rear='18x8.5 ET47',
    factory_tire='225/45R18 front / 255/40R18 rear'
where make='BMW' and model='F30' and trim='340i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET34',factory_rear='18x8 ET34',
    factory_tire='225/45R18 front / 225/45R18 rear'
where make='BMW' and model='F32' and trim='440i' and active is not false;

-- OEM+ keeps the 340i factory rear tire width and moves both axles outward.
update public.fitment_presets
set front='18x8.5 ET29',rear='18x9 ET42',front_tire='235/40R18',rear_tire='255/40R18'
where make='BMW' and model='F30' and trim='340i'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f30_f32_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f30_f32_verified_baselines;

insert into bmw_f30_f32_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F30','330i',2017,2018,'Standard 392 17-inch all-season package','United States',true,'17x7.5 ET37','17x7.5 ET37','225/50R17 front / 225/50R17 rear','5x120','72.6mm','verified','BMW North America identifies the 2018 F30 330i standard style 392 package as 17x7.5 front and rear with 225/50R17 all-season tires. The BMW OEM parts catalog identifies style 392 as 7.5Jx17 ET37 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0258500EN_US/391763 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1967&id=8B97-USA---F30N-BMW-330i'),
('BMW','F30','335i',2012,2015,'Standard 397 18-inch all-season package','Canada',true,'18x8 ET34','18x8 ET34','225/45R18 front / 225/45R18 rear','5x120','72.6mm','verified','BMW Canada identifies the F30 335i standard style 397 package as 18x8 front and rear with 225/45R18 all-season run-flat tires. The BMW OEM parts catalog identifies style 397 as 8Jx18 ET34 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0124697EN/183659 ; https://www.realoem.com/bmw/enUS/options?code=S2A5A&series=F30'),
('BMW','F30','340i',2016,2018,'Standard 400M 18-inch performance package','United States',true,'18x8 ET34','18x8.5 ET47','225/45R18 front / 255/40R18 rear','5x120','72.6mm','verified','BMW North America identifies the 2018 F30 340i standard style 400M package as 18x8 front and 18x8.5 rear with 225/45R18 and 255/40R18 performance tires. The BMW OEM parts catalog identifies the corresponding F30 wheel geometry as 8Jx18 ET34 front and 8.5Jx18 ET47 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0258500EN_US/391763 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1988&id=8B32-EUR-10-2018-F30N-BMW-340i'),
('BMW','F32','440i',2017,2020,'Standard 397 18-inch all-season package','United States',true,'18x8 ET34','18x8 ET34','225/45R18 front / 225/45R18 rear','5x120','72.6mm','verified','BMW North America identifies the 2018 F32 440i standard style 397 package as 18x8 front and rear with 225/45R18 all-season run-flat tires. The BMW OEM parts catalog identifies style 397 as 8Jx18 ET34 and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0267513EN_US/403275 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1974&id=4J52-EUR-12_2016_F36N_BMW-440i'),
('BMW','F32','440i',2017,2020,'400M 18-inch M Sport package','United States',false,'18x8 ET34','18x8.5 ET47','225/45R18 front / 255/40R18 rear','5x120','72.6mm','verified','BMW North America identifies the F32 440i M Sport style 400M package as 18x8 front and 18x8.5 rear with 225/45R18 and 255/40R18 performance tires. The BMW OEM parts catalog identifies style 400M as 8Jx18 ET34 front and 8.5Jx18 ET47 rear and lists M14x1.25 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0267513EN_US/403275 ; https://www.realoem.com/bmw/pl/showparts?diagId=36_1985&id=4J73-USA-07_2016_F36N_BMW_440iX');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_f30_f32_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_f30_f32_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('F30','F32') and active
order by model,trim,is_default desc,year_start;
