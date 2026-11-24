-- Offset Lab Fitment
-- Pack 107: verified BMW G60 540i and G90 M5 factory baselines.
-- Also corrects the current M5 chassis assignment from G60 to G90.
-- Uses official BMW technical/accessory documentation and BMW OEM parts data.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='G60 5 Series Sedan',year_start=2024,year_end=2026
where make='BMW' and model='G60';

insert into public.vehicle_models
  (make,model,active,sort_order,display_name,year_start,year_end)
select 'BMW','G90',true,
       coalesce((select max(sort_order) from public.vehicle_models where make='BMW'),0)+1,
       'G90 M5 Sedan',2025,2026
where not exists (
  select 1 from public.vehicle_models where make='BMW' and model='G90'
);

update public.vehicle_models
set display_name='G90 M5 Sedan',year_start=2025,year_end=2026,active=true
where make='BMW' and model='G90';

update public.vehicle_trims
set model='G90'
where make='BMW' and model='G60' and trim='M5';

update public.fitment_presets
set model='G90'
where make='BMW' and model='G60' and trim='M5';

update public.fitment_presets
set bolt_pattern='5x112',center_bore='66.6mm',
    factory_front='19x8.5 ET29',factory_rear='19x8.5 ET29',
    factory_tire='245/45R19 front / 245/45R19 rear'
where make='BMW' and model='G60' and trim='540i' and active is not false;

-- Keep OEM+ visibly different from factory while preserving the G60 tire diameter.
update public.fitment_presets
set front='20x9 ET25',rear='20x10 ET41',
    front_tire='255/40R20',rear_tire='285/35R20'
where make='BMW' and model='G60' and trim='540i' and style='oemplus' and active is not false;

update public.fitment_presets
set bolt_pattern='5x132',center_bore='66.6mm',
    factory_front='20x10.5 ET28',factory_rear='21x11 ET28',
    factory_tire='285/40R20 front / 295/35R21 rear'
where make='BMW' and model='G90' and trim='M5' and active is not false;

-- G90 recommendations replace the old generic G60 values, which were narrower than stock.
update public.fitment_presets
set front='20x10.5 ET23',rear='21x11 ET23',
    front_tire='285/40R20',rear_tire='295/35R21'
where make='BMW' and model='G90' and trim='M5' and style='oemplus' and active is not false;

update public.fitment_presets
set front='21x10.5 ET23',rear='21x11.5 ET25',
    front_tire='295/35R21',rear_tire='305/35R21'
where make='BMW' and model='G90' and trim='M5' and style='flush' and active is not false;

update public.fitment_presets
set front='22x11 ET20',rear='22x12 ET25',
    front_tire='305/30R22',rear_tire='315/30R22'
where make='BMW' and model='G90' and trim='M5' and style='aggressive' and active is not false;

create temp table if not exists bmw_g60_g90_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_g60_g90_verified_baselines;

insert into bmw_g60_g90_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','G60','540i',2024,2026,'Standard 933/934 19-inch package','United States',true,'19x8.5 ET29','19x8.5 ET29','245/45R19 front / 245/45R19 rear','5x112','66.6mm','verified','BMW North America specifies the G60 540i xDrive standard 19-inch package as 19x8.5 front and rear with 245/45R19 tires. The official BMW G60 accessory catalog identifies styles 933 and 934 as 8.5Jx19 ET29. OEM hardware uses 5x112, a 66.6 mm center bore, and M14x1.25 60-degree conical-seat bolts. Sources: https://www.press.bmwgroup.com/usa/article/attachment/T0418778EN_US/624323 ; https://www.bmw.co.jp/content/dam/bmw/marketJP/bmw_co_jp/pdf/topics/service-and-accessory/catalod_dl/original/BMW_ACC_5Series_G60G61G68_250509_WEB.pdf.asset.1746773636057.pdf'),
('BMW','G90','M5',2025,2026,'Standard 951M forged-wheel package','United States',true,'20x10.5 ET28','21x11 ET28','285/40R20 front / 295/35R21 rear','5x132','66.6mm','verified','BMW North America identifies the G90 M5 standard style 951M package as 20x10.5 front and 21x11 rear with 285/40ZR20 and 295/35ZR21 tires. The official BMW G90/G99 accessory catalog specifies ET28 front and rear. BMW OEM parts data confirms M14x1.25 bolts; the 5x132 pattern is confirmed by the TÜV application documentation for the G90 M5. The center bore is 66.6 mm and the bolt seat is 60-degree conical. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0443395EN_US/the-all-new-2025-bmw-m5 ; https://www.bmw.co.jp/content/dam/bmw/marketJP/bmw_co_jp/pdf/topics/service-and-accessory/catalod_dl/original/ACC_M5_G90G99_250305_WEB.pdf.asset.1741141228373.pdf ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_3059&id=81FK-EUR-11_2022_G90_BMW-M5 ; https://breyton.com/uploads/files/Application%20List/5029.pdf');

update public.fitment_factory_baselines target
set year_start=source.year_start,year_end=source.year_end,market=source.market,
    is_default=source.is_default,front=source.front,rear=source.rear,tire=source.tire,
    bolt_pattern=source.bolt_pattern,center_bore=source.center_bore,
    source_status=source.source_status,source_note=source.source_note,active=true
from bmw_g60_g90_verified_baselines source
where target.make=source.make and target.model=source.model
  and target.trim=source.trim and target.package_name=source.package_name;

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select source.make,source.model,source.trim,source.year_start,source.year_end,source.package_name,source.market,source.is_default,source.front,source.rear,source.tire,source.bolt_pattern,source.center_bore,source.source_status,source.source_note
from bmw_g60_g90_verified_baselines source
where not exists (
  select 1 from public.fitment_factory_baselines target
  where target.make=source.make and target.model=source.model
    and target.trim=source.trim and target.package_name=source.package_name
);

select model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model in ('G60','G90') and active
order by model,trim,is_default desc,year_start;
