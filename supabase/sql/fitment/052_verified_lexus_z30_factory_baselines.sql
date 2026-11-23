-- Offset Lab Fitment
-- Pack 052: verified first-generation Lexus SC factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=1992,year_end=2000
where make='Lexus' and model='Z30';

update public.fitment_presets
set factory_front='16x6.5 ET50',factory_rear='16x6.5 ET50',
    factory_tire='225/55R16 front / 225/55R16 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='Z30' and trim='SC300' and active is not false;

update public.fitment_presets
set factory_front='16x7 ET50',factory_rear='16x7 ET50',
    factory_tire='225/55R16 front / 225/55R16 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='Z30' and trim='SC400' and active is not false;

create temp table if not exists lexus_z30_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table lexus_z30_verified_baselines;

insert into lexus_z30_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Lexus','Z30','SC300',1995,2000,'SC 300 16-inch production package','US',true,
 '16x6.5 ET50','16x6.5 ET50','225/55R16 front / 225/55R16 rear',
 '5x114.3','60.1mm','verified',
 'The Lexus 1997 SC specification sheet and owner manual specify 16x6.5-inch wheels with 225/55R16 tires for the SC 300. The genuine Lexus wheel catalog identifies production wheel 42611-24300 as 16x6.5JJ with offset 50. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts torqued to 103 N-m. Sources: https://xr793.org/wp-content/uploads/2022/01/1997-Lexus-SC-Specs.pdf ; https://www.manualowl.com/am/Lexus/1997-SC%20300/Manual/6098 ; https://www.lexuspartsnow.com/parts-list/1997-lexus-sc300/power_train_chassis/disc_wheel_wheel_cap.html'),
('Lexus','Z30','SC400',1992,2000,'SC 400 16-inch production package','US',true,
 '16x7 ET50','16x7 ET50','225/55R16 front / 225/55R16 rear',
 '5x114.3','60.1mm','verified',
 'Lexus 1992 and 1997 SC specification sheets and the owner manual specify 16x7-inch wheels with 225/55R16 tires for the SC 400. Production references identify ET50. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts torqued to 103 N-m. Sources: https://xr793.com/wp-content/uploads/2022/01/1992-Lexus-SC-Specs.pdf ; https://xr793.org/wp-content/uploads/2022/01/1997-Lexus-SC-Specs.pdf ; https://www.manualowl.com/am/Lexus/1997-SC%20400/Manual/6100?page=222');

delete from public.fitment_factory_baselines
where make='Lexus' and model='Z30';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from lexus_z30_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Lexus' and model='Z30' and active
order by trim;
