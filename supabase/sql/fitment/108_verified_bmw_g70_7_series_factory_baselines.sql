-- Offset Lab Fitment
-- Pack 108: verified BMW G70 740i and 760i factory baselines.
-- Uses BMW North America ordering/launch documentation, the official BMW accessory
-- catalog, and BMW OEM parts data. Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G70 7 Series Sedan',year_start=2023,year_end=2026
where make='BMW' and model='G70';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='20x9 ET24',factory_rear='20x10.5 ET44',
    factory_tire='255/45R20 front / 285/40R20 rear'
where make='BMW' and model='G70' and trim in ('740i','760i') and active is not false;

-- Preserve the G70's approximately 29-inch factory tire diameter in each recommendation.
update public.fitment_presets
set front='21x9 ET20',rear='21x10.5 ET40',
    front_tire='255/40R21',rear_tire='285/35R21'
where make='BMW' and model='G70' and trim in ('740i','760i')
  and style='oemplus' and active is not false;

update public.fitment_presets
set front='22x9.5 ET22',rear='22x11 ET38',
    front_tire='265/35R22',rear_tire='305/30R22'
where make='BMW' and model='G70' and trim in ('740i','760i')
  and style='flush' and active is not false;

update public.fitment_presets
set front='22x10 ET18',rear='22x11.5 ET34',
    front_tire='275/35R22',rear_tire='315/30R22'
where make='BMW' and model='G70' and trim in ('740i','760i')
  and style='aggressive' and active is not false;

create temp table if not exists bmw_g70_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g70_verified_baselines;

insert into bmw_g70_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G70','740i',2023,2026,'Standard 907M 20-inch all-season package','United States',true,'20x9 ET24','20x10.5 ET44','255/45R20 front / 285/40R20 rear','5x112','66.6mm','verified','BMW North America identifies style 907M as the standard G70 740i package: 20x9 front and 20x10.5 rear with 255/45R20 and 285/40R20 all-season non-run-flat tires. The official BMW G70 accessory catalog specifies ET24 front and ET44 rear. BMW OEM parts data specifies M14x1.25 wheel bolts; hardware is 5x112 with a 66.6 mm center bore and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0382613EN_US/the-new-bmw-7-series ; https://www.bmw.co.jp/content/dam/bmw/marketJP/bmw_co_jp/pdf/topics/service-and-accessory/catalod_dl/original/ACC_7Series_G70_2025Jan_V3_WEB.pdf.asset.1735277684014.pdf ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2845&id=22EH-EUR-03-2025-G70-BMW-740i'),
('BMW','G70','760i',2023,2026,'Standard 907M 20-inch all-season package','United States',true,'20x9 ET24','20x10.5 ET44','255/45R20 front / 285/40R20 rear','5x112','66.6mm','verified','BMW North America identifies style 907M as the standard G70 760i xDrive package: 20x9 front and 20x10.5 rear with 255/45R20 and 285/40R20 all-season non-run-flat tires. The official BMW G70 accessory catalog specifies ET24 front and ET44 rear. BMW OEM parts data specifies M14x1.25 wheel bolts; hardware is 5x112 with a 66.6 mm center bore and 60-degree conical seats. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0382613EN_US/the-new-bmw-7-series ; https://www.bmw.co.jp/content/dam/bmw/marketJP/bmw_co_jp/pdf/topics/service-and-accessory/catalod_dl/original/ACC_7Series_G70_2025Jan_V3_WEB.pdf.asset.1735277684014.pdf ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2845&id=22EH-EUR-03-2025-G70-BMW-740i');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g70_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_g70_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='G70' and active
order by trim,is_default desc,year_start;
