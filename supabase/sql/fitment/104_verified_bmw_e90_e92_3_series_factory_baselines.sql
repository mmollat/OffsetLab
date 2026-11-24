-- Offset Lab Fitment
-- Pack 104: verified BMW E90 Sedan and E92 Coupe factory baselines.
-- Uses BMW product guides and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set display_name='E90 3 Series Sedan',year_start=2006,year_end=2011
where make='BMW' and model='E90';
update public.vehicle_models set display_name='E92 3 Series Coupe',year_start=2007,year_end=2013
where make='BMW' and model='E92';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='17x8 ET34',factory_rear='17x8 ET34',
    factory_tire='225/45R17 front / 225/45R17 rear'
where make='BMW' and model='E90' and trim='328i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET34',factory_rear='18x8.5 ET39',
    factory_tire='225/40R18 front / 255/35R18 rear'
where make='BMW' and model='E90' and trim='335i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='17x8 ET34',factory_rear='17x8 ET34',
    factory_tire='225/45R17 front / 225/45R17 rear'
where make='BMW' and model='E92' and trim='328i' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET34',factory_rear='18x8.5 ET37',
    factory_tire='225/40R18 front / 255/35R18 rear'
where make='BMW' and model='E92' and trim in ('335i','328i / 335i') and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8.5 ET29',factory_rear='18x9.5 ET23',
    factory_tire='245/40R18 front / 265/40R18 rear'
where make='BMW' and model='E92' and trim='M3' and active is not false;

-- Keep the combined-trim OEM+ package wider than its shared factory package.
update public.fitment_presets
set front='18x8.5 ET29',rear='18x9 ET32',front_tire='235/40R18',rear_tire='255/35R18'
where make='BMW' and model='E92' and trim='328i / 335i'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_e90_e92_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_e90_e92_verified_baselines;

insert into bmw_e90_e92_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','E90','328i',2007,2011,'Standard 284 17-inch all-season package','Canada',true,'17x8 ET34','17x8 ET34','225/45R17 front / 225/45R17 rear','5x120','72.6mm','verified','BMW Canada identifies the 2011 E90 328i standard style 284 package as 17x8 front and rear with 225/45R17 all-season run-flat tires. The BMW OEM parts catalog identifies style 284 as 8Jx17 ET34 and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0081855EN/123793 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1288&id=PH53-USA---E90N-BMW-328i'),
('BMW','E90','335i',2007,2011,'Standard 287 18-inch performance package','Canada',true,'18x8 ET34','18x8.5 ET39','225/40R18 front / 255/35R18 rear','5x120','72.6mm','verified','BMW Canada identifies the 2011 E90 335i standard style 287 package as 18x8 front and 18x8.5 rear with 225/40R18 and 255/35R18 performance run-flat tires. The BMW OEM parts catalog identifies style 287 as 8Jx18 ET34 front and 8.5Jx18 ET39 rear and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0081855EN/123793 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1291&id=PM71-EUR---E90N-BMW-335i'),
('BMW','E92','328i',2007,2013,'Standard 338 17-inch all-season package','Canada',true,'17x8 ET34','17x8 ET34','225/45R17 front / 225/45R17 rear','5x120','72.6mm','verified','BMW Canada identifies the 2011 E92 328i standard style 338 package as 17x8 front and rear with 225/45R17 all-season run-flat tires. The BMW OEM parts catalog identifies style 338 as 8Jx17 ET34 and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0081854EN/123791 ; https://www.realoem.com/bmw/en/options?code=S2K5A&series=E92'),
('BMW','E92','335i',2007,2013,'Standard 342 18-inch performance package','Canada',true,'18x8 ET34','18x8.5 ET37','225/40R18 front / 255/35R18 rear','5x120','72.6mm','verified','BMW Canada identifies the 2011 E92 335i standard style 342 package as 18x8 front and 18x8.5 rear with 225/40R18 and 255/35R18 performance run-flat tires. The BMW OEM parts catalog identifies style 342 as 8Jx18 ET34 front and 8.5Jx18 ET37 rear and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0081854EN/123791 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1467&id=KG73-USA-12_2008_E92N_BMW-335i'),
('BMW','E92','328i / 335i',2007,2013,'Shared 189 18-inch performance package','Canada',true,'18x8 ET34','18x8.5 ET37','225/40R18 front / 255/35R18 rear','5x120','72.6mm','verified','BMW Canada identifies style 189 in 2010 as the E92 328i Sport package and the E92 335i standard package, both using 18x8 front and 18x8.5 rear wheels with 225/40R18 and 255/35R18 performance run-flat tires. The BMW OEM parts catalog identifies style 189 as 8Jx18 ET34 front and 8.5Jx18 ET37 rear and lists M12x1.5 wheel bolts. This shared active trim therefore uses a package verified for both named variants. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/canada/article/attachment/T0037174EN/105889 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_0976&id=KG72-EUR-09_2009_E92N_BMW-335i'),
('BMW','E92','M3',2008,2013,'Standard 219M 18-inch package','United States',true,'18x8.5 ET29','18x9.5 ET23','245/40R18 front / 265/40R18 rear','5x120','72.6mm','verified','BMW technical documentation identifies the E92 M3 standard package as 18x8.5 front and 18x9.5 rear with 245/40R18 and 265/40R18 performance tires. The BMW OEM parts catalog identifies style 219M as 8.5Jx18 ET29 front and 9.5Jx18 ET23 rear and lists M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0018129EN_US/56932 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_1150&id=KG93-USA---E92N-BMW-M3');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_e90_e92_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_e90_e92_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('E90','E92') and active
order by model,trim,is_default desc,year_start;
