-- Offset Lab Fitment
-- Pack 091: verified BMW F87 M2, M2 Competition, and M2 CS baselines.
-- Uses BMW Group wheel matrices, product guides, and genuine wheel geometry.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set display_name='F87 M2',year_start=2016,year_end=2021
where make='BMW' and model='F87';

update public.fitment_presets
set bolt_pattern='5x120',center_bore='72.6mm',
    factory_front='19x9 ET29',factory_rear='19x10 ET40',
    factory_tire='245/35R19 front / 265/35R19 rear'
where make='BMW' and model='F87'
  and trim in ('M2','M2 Competition','M2 CS') and active is not false;

update public.fitment_presets
set front='19x9 ET24',rear='19x10 ET35',
    front_tire='245/35R19',rear_tire='265/35R19'
where make='BMW' and model='F87'
  and trim in ('M2','M2 Competition','M2 CS')
  and style='oemplus' and active is not false;

create temp table if not exists bmw_f87_m2_verified_baselines (
  make text,model text,trim text,year_start int,year_end int,package_name text,
  market text,is_default boolean,front text,rear text,tire text,
  bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table bmw_f87_m2_verified_baselines;

insert into bmw_f87_m2_verified_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
values
('BMW','F87','M2',2016,2018,'M2 standard 437M 19-inch package','North America/Europe',true,
 '19x9 ET29','19x10 ET40','245/35R19 front / 265/35R19 rear','5x120','72.6mm','verified',
 'BMW Group technical wheel documentation identifies the F87 M2 standard 437M package as 9Jx19 IS29 front and 10Jx19 IS40 rear with 245/35ZR19 and 265/35ZR19 tires. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://myair-bdr.bmwgroup.com/static/manual/RadReif/downloads/Rad-Reifen/M-GmbH/F87_2016.pdf ; https://www.press.bmwgroup.com/usa/article/detail/T0238507EN_US/the-all-new-2016-bmw-m2'),
('BMW','F87','M2 Competition',2019,2021,'M2 Competition standard 788M 19-inch package','North America/Europe',true,
 '19x9 ET29','19x10 ET40','245/35R19 front / 265/35R19 rear','5x120','72.6mm','verified',
 'BMW Group documentation identifies the F87 M2 Competition 788M package as 9Jx19 front and 10Jx19 rear with 245/35R19 and 265/35R19 tires. Genuine BMW wheel parts 36 10 8 093 987/988 establish ET29 front and ET40 rear. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0280302EN_US/the-first-ever-2019-bmw-m2-competition ; https://shop.bmw.co.uk/product/genuine-19-disc-wheel-light-alloy-jet-black-transl-9jx19-et-29-36-10-8-093-987 ; https://www.realoem.com/bmw/enUS/showparts?diagId=36_2537&id=2U72-EUR-10_2016_F87N_BMW_M2_Competition'),
('BMW','F87','M2 CS',2020,2020,'M2 CS standard 763M 19-inch package','North America/Europe',true,
 '19x9 ET29','19x10 ET40','245/35R19 front / 265/35R19 rear','5x120','72.6mm','verified',
 'BMW Group documentation identifies the F87 M2 CS 763M package as 9Jx19 front and 10Jx19 rear with 245/35R19 and 265/35R19 tires. BMW technical accessory documentation establishes ET29 front and ET40 rear. Hardware is 5x120 with a 72.6 mm center bore and M14x1.25 60-degree conical-seat wheel bolts. Sources: https://www.press.bmwgroup.com/usa/article/detail/T0302373EN_US/the-2020-bmw-m2-cs-coupe?language=en_US ; https://www.hubauer-shop.de/images/docs/de/SZ_019_02_17.pdf');

delete from public.fitment_factory_baselines
where make='BMW' and model='F87'
  and trim in ('M2','M2 Competition','M2 CS');

insert into public.fitment_factory_baselines
  (make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
   tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from bmw_f87_m2_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='BMW' and model='F87'
  and trim in ('M2','M2 Competition','M2 CS') and active
order by trim,is_default desc,year_start;
