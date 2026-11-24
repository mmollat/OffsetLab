-- Offset Lab Fitment
-- Pack 095: verified BMW F97 X3 M and X3 M Competition baselines.
-- Uses BMW USA specifications and the BMW OEM parts catalog.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F97 X3 M',year_start=2020,year_end=2024
where make='BMW' and model='F97';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9 ET28',factory_rear='20x10 ET39',
    factory_tire='255/45R20 front / 265/45R20 rear'
where make='BMW' and model='F97' and trim='X3M'
  and active is not false;

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='21x9.5 ET31',factory_rear='21x10 ET39',
    factory_tire='255/40R21 front / 265/40R21 rear'
where make='BMW' and model='F97' and trim='X3M Competition'
  and active is not false;

-- Competition OEM+ previously duplicated its factory setup exactly.
update public.fitment_presets
set front='21x9.5 ET26',rear='21x10 ET34',
    front_tire='255/40R21',rear_tire='265/40R21'
where make='BMW' and model='F97' and trim='X3M Competition'
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f97_x3m_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f97_x3m_verified_baselines;

insert into bmw_f97_x3m_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F97','X3M',2020,2024,'Standard 764M 20-inch package','United States',true,
 '20x9 ET28','20x10 ET39','255/45R20 front / 265/45R20 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the F97 X3 M standard package as staggered 20-inch wheels with 255/45ZR20 front and 265/45ZR20 rear tires. The BMW OEM parts catalog identifies the 764M wheels as 9Jx20 ET28 front and 10Jx20 ET39 rear and lists M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0291875EN_US/the-first-ever-2020-bmw-x3-m-and-bmw-x4-m ; https://www.press.bmwgroup.com/usa/article/detail/T0334899EN_US/the-new-bmw-x3-m-competition-and-the-new-bmw-x4-m-competition ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2587&id=13EC-USA-07-2024-F97N-BMW-X3_M'),
('BMW','F97','X3M Competition',2020,2024,'Standard 765M/892M 21-inch package','United States',true,
 '21x9.5 ET31','21x10 ET39','255/40R21 front / 265/40R21 rear','5x112','66.6mm','verified',
 'BMW USA specifications identify the F97 X3 M Competition standard package as 9.5Jx21 front and 10Jx21 rear with 255/40ZR21 and 265/40ZR21 tires. BMW Group product documentation identifies the 765M and 892M packages, and the BMW OEM parts catalog establishes ET31 front, ET39 rear, and M14x1.25 wheel bolts. Hardware is 5x112 with a 66.6 mm center bore and 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0291875EN_US/the-first-ever-2020-bmw-x3-m-and-bmw-x4-m ; https://www.press.bmwgroup.com/usa/article/detail/T0334899EN_US/the-new-bmw-x3-m-competition-and-the-new-bmw-x4-m-competition ; https://www.bmw.com/content/dam/bmw/marketAU/common/images/BMW_X3_M_Competition_X4_M_Competition_Specification_Guide_F97_F98.pdf.asset.1646282974593.pdf ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2770&id=11EC-EUR-08_2020_F97N-BMW-X3_M');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_f97_x3m_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,
       source.package_name,source.market,source.is_default,source.front,source.rear,
       source.tire,source.bolt_pattern,source.center_bore,source.source_status,
       source.source_note
from bmw_f97_x3m_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F97' and trim in ('X3M','X3M Competition') and active
order by trim,is_default desc,year_start;
