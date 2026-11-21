-- Offset Lab Fitment
-- Pack 045: verified sixth-generation Chevrolet Camaro factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2016,year_end=2024
where make='Chevrolet' and model='Alpha';

update public.fitment_presets set factory_front='20x8.5 ET25',factory_rear='20x9.5 ET39',
 factory_tire='245/40R20 front / 275/35R20 rear',bolt_pattern='5x120',center_bore='66.9mm'
where make='Chevrolet' and model='Alpha' and trim='SS' and active is not false;

update public.fitment_presets set factory_front='20x10 ET20',factory_rear='20x11 ET43',
 factory_tire='285/30R20 front / 305/30R20 rear',bolt_pattern='5x120',center_bore='66.9mm'
where make='Chevrolet' and model='Alpha' and trim in ('SS 1LE','ZL1') and active is not false;

update public.fitment_presets set factory_front='19x11 ET11',factory_rear='19x12 ET41',
 factory_tire='305/30R19 front / 325/30R19 rear',bolt_pattern='5x120',center_bore='66.9mm'
where make='Chevrolet' and model='Alpha' and trim='ZL1 1LE' and active is not false;

update public.fitment_presets set front='20x8.5 +19',rear='20x9.5 +33',front_tire='245/40R20',rear_tire='275/35R20'
where make='Chevrolet' and model='Alpha' and trim='SS' and style='oemplus' and active is not false;
update public.fitment_presets set front='20x10 +14',rear='20x11 +37',front_tire='285/30R20',rear_tire='305/30R20'
where make='Chevrolet' and model='Alpha' and trim in ('SS 1LE','ZL1') and style='oemplus' and active is not false;
update public.fitment_presets set front='19x11 +5',rear='19x12 +35',front_tire='305/30R19',rear_tire='325/30R19'
where make='Chevrolet' and model='Alpha' and trim='ZL1 1LE' and style='oemplus' and active is not false;

create temp table if not exists chevrolet_alpha_verified_baselines(
 make text,model text,trim text,year_start int,year_end int,package_name text,market text,is_default boolean,
 front text,rear text,tire text,bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table chevrolet_alpha_verified_baselines;
insert into chevrolet_alpha_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
values
('Chevrolet','Alpha','SS',2016,2024,'20-inch SS production package','US',true,'20x8.5 ET25','20x9.5 ET39','245/40R20 front / 275/35R20 rear','5x120','66.9mm','verified',
 'Chevrolet Camaro product literature identifies the SS 20x8.5 front and 20x9.5 rear package with 245/40R20 and 275/35R20 tires. Genuine GM wheels 23415316/23415317 are documented at ET25 front and ET39 rear; hardware is 5x120, 66.9 mm with M14x1.5 lug nuts. Sources: https://xr793.com/wp-content/uploads/2019/11/2020-Chevrolet-Camaro.pdf ; https://www.hawksmotorsports.com/2019-2024-camaro-ss-20-hyper-black-wheels-front-rear-used-oem-gm-23415316-23415317/'),
('Chevrolet','Alpha','SS 1LE',2017,2024,'SS 1LE track production package','US',true,'20x10 ET20','20x11 ET43','285/30R20 front / 305/30R20 rear','5x120','66.9mm','verified',
 'Chevrolet Camaro product literature identifies the SS 1LE forged 20x10 front and 20x11 rear package with 285/30R20 and 305/30R20 Goodyear tires. Genuine GM wheels 23355791/23355802 are documented at ET20 front and ET43 rear; hardware is 5x120, 66.9 mm with M14x1.5 lug nuts. Sources: https://xr793.com/wp-content/uploads/2019/11/2020-Chevrolet-Camaro.pdf ; https://wildhammermotorsports.com/16-24-camaro-ss-1le-oem-wheel-kit-includes-4-front-rear-general-motors/'),
('Chevrolet','Alpha','ZL1',2017,2024,'20-inch ZL1 production package','US',true,'20x10 ET20','20x11 ET43','285/30R20 front / 305/30R20 rear','5x120','66.9mm','verified',
 'Chevrolet product information specifies forged 20x10 front and 20x11 rear ZL1 wheels with 285/30R20 and 305/30R20 tires. Genuine GM wheels 23442882/23442883 are marked ET20 front and ET43 rear; hardware is 5x120, 66.9 mm with M14x1.5 lug nuts. Sources: https://www.automobilrevue.cz/priloha/5c52e04a77969/2019-chevrolet-camaro-zl1-product-guide-071618-5c7513e929f7f.pdf ; https://xr793.com/wp-content/uploads/2019/11/2020-Chevrolet-Camaro.pdf'),
('Chevrolet','Alpha','ZL1 1LE',2018,2024,'ZL1 1LE Extreme Track Performance package','US',true,'19x11 ET11','19x12 ET41','305/30R19 front / 325/30R19 rear','5x120','66.9mm','verified',
 'Chevrolet ZL1 product information specifies forged 19x11 front and 19x12 rear ZL1 1LE wheels with 305/30R19 and 325/30R19 Goodyear Eagle F1 Supercar 3R tires. Genuine GM production wheel markings/catalog data establish ET11 front and ET41 rear; hardware is 5x120, 66.9 mm with M14x1.5 lug nuts. Sources: https://www.automobilrevue.cz/priloha/5c52e04a77969/2019-chevrolet-camaro-zl1-product-guide-071618-5c7513e929f7f.pdf ; https://xr793.com/wp-content/uploads/2019/11/2020-Chevrolet-Camaro.pdf');

delete from public.fitment_factory_baselines where make='Chevrolet' and model='Alpha';
insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note
from chevrolet_alpha_verified_baselines;
select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines where make='Chevrolet' and model='Alpha' and active order by trim;
