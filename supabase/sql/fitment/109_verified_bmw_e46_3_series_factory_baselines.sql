-- Offset Lab Fitment
-- Pack 109: verified BMW E46 330i/330Ci, M3, and M3 CSL factory baselines.
-- Uses BMW press documentation and BMW OEM parts data.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='E46 3 Series / M3',year_start=2001,year_end=2006
where make='BMW' and model='E46';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='17x7 ET47',factory_rear='17x7 ET47',
    factory_tire='205/50R17 front / 205/50R17 rear'
where make='BMW' and model='E46' and trim='330i / 330Ci' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='18x8 ET47',factory_rear='18x9 ET26',
    factory_tire='225/45R18 front / 255/40R18 rear'
where make='BMW' and model='E46' and trim='M3' and active is not false;

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x8.5 ET44',factory_rear='19x9.5 ET27',
    factory_tire='235/35R19 front / 265/30R19 rear'
where make='BMW' and model='E46' and trim='M3 CSL' and active is not false;

-- The old CSL OEM+ row duplicated the factory package exactly. Keep the original
-- tire sizes but use subtly wider wheels and a modestly more outward position.
update public.fitment_presets
set front='19x9 ET40',rear='19x10 ET25',
    front_tire='235/35R19',rear_tire='265/30R19'
where make='BMW' and model='E46' and trim='M3 CSL'
  and style='oemplus' and active is not false;

-- Retain the M3 factory tire diameter while making OEM+ measurably wider/outward.
update public.fitment_presets
set front='18x8.5 ET40',rear='18x9.5 ET23',
    front_tire='225/45R18',rear_tire='255/40R18'
where make='BMW' and model='E46' and trim='M3'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_e46_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_e46_verified_baselines;

insert into bmw_e46_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','E46','330i / 330Ci',2001,2006,'Standard 17-inch package','United States',true,'17x7 ET47','17x7 ET47','205/50R17 front / 205/50R17 rear','5x120','72.6mm','verified','BMW North America lists 17x7 wheels with 205/50R17 all-season tires as standard on the E46 330i and 330Ci. BMW OEM parts data identifies the 7Jx17 wheel as ET47 and specifies M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0021977EN_US/press-kit-my-2001%3A-bmw-3-series%3A-new-engines-available-all-wheel-drive-and-an-expanded-model-range-enhance-a-unique-award-winning-line ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_0605&id=AV53-USA---E46-BMW-330i ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_0432&id=BD53-USA-02-2003-E46-BMW-330Ci'),
('BMW','E46','M3',2001,2006,'Standard style 67 18-inch package','United States',true,'18x8 ET47','18x9 ET26','225/45R18 front / 255/40R18 rear','5x120','72.6mm','verified','BMW North America lists the E46 M3 standard package as 18x8 front and 18x9 rear with 225/45ZR18 and 255/40ZR18 performance tires. BMW OEM parts data identifies style 67 as ET47 front and ET26 rear and specifies M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0022127EN_US/41384 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_0426&id=BR93-USA---E46-BMW-M3'),
('BMW','E46','M3 CSL',2003,2004,'Standard style 163M CSL package','Europe',true,'19x8.5 ET44','19x9.5 ET27','235/35R19 front / 265/30R19 rear','5x120','72.6mm','verified','BMW identifies the E46 M3 CSL package as 8.5Jx19 front and 9.5Jx19 rear with model-specific Michelin Pilot Sport Cup tires sized 235/35ZR19 and 265/30ZR19. BMW OEM parts data identifies style 163M as ET44 front and ET27 rear and specifies M12x1.5 wheel bolts. Hardware is 5x120 with a 72.6 mm center bore and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0022168EN_US/41493/AG030228_M3_CSL_Press_Kit_GB_finalversion.pdf ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_0698&id=BL95-EUR-12-2003-E46-BMW-M3_CSL');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_e46_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_e46_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='E46' and active
order by trim,is_default desc,year_start;
