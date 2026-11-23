-- Offset Lab Fitment
-- Pack 046: verified Chevrolet Corvette C5-C8 factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set
 year_start=case model when 'C5' then 1997 when 'C6' then 2005 when 'C7' then 2014 when 'C8' then 2020 end,
 year_end=case model when 'C5' then 2004 when 'C6' then 2013 when 'C7' then 2019 when 'C8' then 2026 end
where make='Chevrolet' and model in ('C5','C6','C7','C8');

-- Default factory fields use the latest/base production package represented by each UI trim.
update public.fitment_presets set factory_front='17x8.5 ET58',factory_rear='18x9.5 ET65',factory_tire='245/45R17 front / 275/40R18 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C5' and trim='Base' and active is not false;
update public.fitment_presets set factory_front='17x9.5 ET54',factory_rear='18x10.5 ET58',factory_tire='265/40R17 front / 295/35R18 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C5' and trim='Z06' and active is not false;
update public.fitment_presets set factory_front='18x8.5 ET56',factory_rear='19x10 ET79',factory_tire='245/40R18 front / 285/35R19 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C6' and trim='Base' and active is not false;
update public.fitment_presets set factory_front='18x9.5 ET40',factory_rear='19x12 ET59',factory_tire='275/35R18 front / 325/30R19 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C6' and trim='Z06' and active is not false;
update public.fitment_presets set factory_front='19x10 ET40',factory_rear='20x12 ET59',factory_tire='285/30R19 front / 335/25R20 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C6' and trim='ZR1' and active is not false;
update public.fitment_presets set factory_front='18x8.5 ET56',factory_rear='19x10 ET79',factory_tire='245/40R18 front / 285/35R19 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C7' and trim='Stingray' and active is not false;
update public.fitment_presets set factory_front='19x10 ET43',factory_rear='20x12 ET59',factory_tire='285/30R19 front / 335/25R20 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C7' and trim='Z06' and active is not false;
update public.fitment_presets set factory_front='19x10.5 ET42',factory_rear='20x12 ET59',factory_tire='285/30R19 front / 335/25R20 rear',bolt_pattern='5x120.65',center_bore='70.3mm'
where make='Chevrolet' and model='C7' and trim='ZR1' and active is not false;
update public.fitment_presets set factory_front='19x8.5 ET52',factory_rear='20x11 ET64',factory_tire='245/35R19 front / 305/30R20 rear',bolt_pattern='5x120',center_bore='66.9mm'
where make='Chevrolet' and model='C8' and trim='Stingray' and active is not false;
update public.fitment_presets set factory_front='20x10 ET35',factory_rear='21x13 ET40',factory_tire='275/30R20 front / 345/25R21 rear',bolt_pattern='5x120',center_bore='66.9mm'
where make='Chevrolet' and model='C8' and trim in ('Z06','E-Ray') and active is not false;

-- OEM+ retains each production size/tire and moves the wheel outward about 6 mm.
update public.fitment_presets set front='17x8.5 +52',rear='18x9.5 +59',front_tire='245/45R17',rear_tire='275/40R18' where make='Chevrolet' and model='C5' and trim='Base' and style='oemplus' and active is not false;
update public.fitment_presets set front='17x9.5 +48',rear='18x10.5 +52',front_tire='265/40R17',rear_tire='295/35R18' where make='Chevrolet' and model='C5' and trim='Z06' and style='oemplus' and active is not false;
update public.fitment_presets set front='18x8.5 +50',rear='19x10 +73',front_tire='245/40R18',rear_tire='285/35R19' where make='Chevrolet' and model='C6' and trim='Base' and style='oemplus' and active is not false;
update public.fitment_presets set front='18x9.5 +34',rear='19x12 +53',front_tire='275/35R18',rear_tire='325/30R19' where make='Chevrolet' and model='C6' and trim='Z06' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x10 +34',rear='20x12 +53',front_tire='285/30R19',rear_tire='335/25R20' where make='Chevrolet' and model='C6' and trim='ZR1' and style='oemplus' and active is not false;
update public.fitment_presets set front='18x8.5 +50',rear='19x10 +73',front_tire='245/40R18',rear_tire='285/35R19' where make='Chevrolet' and model='C7' and trim='Stingray' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x10 +37',rear='20x12 +53',front_tire='285/30R19',rear_tire='335/25R20' where make='Chevrolet' and model='C7' and trim='Z06' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x10.5 +36',rear='20x12 +53',front_tire='285/30R19',rear_tire='335/25R20' where make='Chevrolet' and model='C7' and trim='ZR1' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x8.5 +46',rear='20x11 +58',front_tire='245/35R19',rear_tire='305/30R20' where make='Chevrolet' and model='C8' and trim='Stingray' and style='oemplus' and active is not false;
update public.fitment_presets set front='20x10 +29',rear='21x13 +34',front_tire='275/30R20',rear_tire='345/25R21' where make='Chevrolet' and model='C8' and trim in ('Z06','E-Ray') and style='oemplus' and active is not false;

create temp table if not exists chevrolet_corvette_verified_baselines(make text,model text,trim text,year_start int,year_end int,package_name text,market text,is_default boolean,front text,rear text,tire text,bolt_pattern text,center_bore text,source_status text,source_note text) on commit drop;
truncate table chevrolet_corvette_verified_baselines;
insert into chevrolet_corvette_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
values
('Chevrolet','C5','Base',2000,2004,'C5 base late production package','US',true,'17x8.5 ET58','18x9.5 ET65','245/45R17 front / 275/40R18 rear','5x120.65','70.3mm','verified','GM-era C5 wheel/tire records and OEM reference documentation specify the 2000-2004 base package at 17x8.5 ET58 and 18x9.5 ET65 with 245/45ZR17 and 275/40ZR18 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C5_Tire_Reference_Guide-a.pdf'),
('Chevrolet','C5','Base',1997,1999,'C5 base early production package','US',false,'17x8.5 ET56','18x9.5 ET61','245/45R17 front / 275/40R18 rear','5x120.65','70.3mm','verified','The C5 OEM reference guide records the early 1997-1999 package at 17x8.5 ET56 and 18x9.5 ET61 with 245/45ZR17 and 275/40ZR18 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C5_Tire_Reference_Guide-a.pdf'),
('Chevrolet','C5','Z06',2001,2004,'C5 Z06 production package','US',true,'17x9.5 ET54','18x10.5 ET58','265/40R17 front / 295/35R18 rear','5x120.65','70.3mm','verified','The C5 OEM reference guide specifies Z06 17x9.5 ET54 and 18x10.5 ET58 wheels with 265/40ZR17 and 295/35ZR18 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C5_Tire_Reference_Guide-a.pdf'),
('Chevrolet','C6','Base',2005,2013,'C6 base production package','US',true,'18x8.5 ET56','19x10 ET79','245/40R18 front / 285/35R19 rear','5x120.65','70.3mm','verified','The C6 OEM reference guide specifies 18x8.5 ET56 and 19x10 ET79 wheels with 245/40ZR18 and 285/35ZR19 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C6_Tire_Reference_Guide.pdf'),
('Chevrolet','C6','Z06',2006,2013,'C6 Z06 production package','US',true,'18x9.5 ET40','19x12 ET59','275/35R18 front / 325/30R19 rear','5x120.65','70.3mm','verified','The C6 OEM reference guide specifies Z06 18x9.5 ET40 and 19x12 ET59 wheels with 275/35ZR18 and 325/30ZR19 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C6_Tire_Reference_Guide.pdf'),
('Chevrolet','C6','ZR1',2009,2013,'C6 ZR1 production package','US',true,'19x10 ET40','20x12 ET59','285/30R19 front / 335/25R20 rear','5x120.65','70.3mm','verified','Chevrolet ZR1 production records and genuine Speedline wheel data specify 19x10 ET40 and 20x12 ET59 with 285/30ZR19 and 335/25ZR20 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Sources: https://www.corvetteactioncenter.com/specs/c6/corvette-zr1-registry/index.php/2009/showprofile.php?id=1451-2010-corvette-zr1-957 ; https://image.mamotorworksmedia.com/production/website/articlefiles/TechTipFiles/C6_Tire_Reference_Guide.pdf'),
('Chevrolet','C7','Stingray',2014,2019,'C7 Stingray non-Z51 production package','US',true,'18x8.5 ET56','19x10 ET79','245/40R18 front / 285/35R19 rear','5x120.65','70.3mm','verified','The C7 OEM reference guide specifies non-Z51 Stingray 18x8.5 ET56 and 19x10 ET79 wheels with 245/40R18 and 285/35R19 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Source: https://image.mamotorworksmedia.com/production/website/ArticleFiles/TechTipFiles/C7_Tire_Reference_Guide.pdf'),
('Chevrolet','C7','Z06',2015,2019,'C7 Z06 production package','US',true,'19x10 ET43','20x12 ET59','285/30R19 front / 335/25R20 rear','5x120.65','70.3mm','verified','Chevrolet C7 Z06 literature specifies 19x10 and 20x12 wheels with 285/30ZR19 and 335/25ZR20 tires; OEM wheel records specify ET43 front and ET59 rear. Hardware is 5x120.65, 70.3 mm, M12x1.5. Sources: https://dgv4.xr793.org/wp-content/uploads/2018/09/2019-Chevrolet-Corvette.pdf ; https://ccimages.corvettecentral.com/pdf/c7catalog-corvettecentral.pdf'),
('Chevrolet','C7','ZR1',2019,2019,'C7 ZR1 production package','US',true,'19x10.5 ET42','20x12 ET59','285/30R19 front / 335/25R20 rear','5x120.65','70.3mm','verified','The Chevrolet 2019 order guide specifies ZR1 19x10.5 front and 20x12 rear wheels; OEM wheel documentation establishes ET42 and ET59 with 285/30ZR19 and 335/25ZR20 tires. Hardware is 5x120.65, 70.3 mm, M12x1.5. Sources: https://www.corvetteactioncenter.com/specs/c7-corvette/2019-corvette/2019-corvette-order-guide.pdf ; https://ccimages.corvettecentral.com/pdf/c7catalog-corvettecentral.pdf'),
('Chevrolet','C8','Stingray',2020,2026,'C8 Stingray production package','US',true,'19x8.5 ET52','20x11 ET64','245/35R19 front / 305/30R20 rear','5x120','66.9mm','verified','Chevrolet C8 brochures specify 19x8.5 and 20x11 wheels with 245/35ZR19 and 305/30ZR20 tires. Genuine GM 84428096/84428100 wheels establish ET52 front and ET64 rear; hardware is 5x120, 66.9 mm, M14x1.5. Sources: https://stingraychevroletcorvette.com/wp-content/uploads/pictures/docs/2023-chevrolet-corvette-ebrochure.pdf ; https://www.finishlinewheels.com/collections/chevrolet-corvette-oem-wheels'),
('Chevrolet','C8','Z06',2023,2026,'C8 Z06 production package','US',true,'20x10 ET35','21x13 ET40','275/30R20 front / 345/25R21 rear','5x120','66.9mm','verified','Chevrolet Z06 production data specifies 20x10 and 21x13 wheels with 275/30ZR20 and 345/25ZR21 tires; OEM wheel documentation establishes ET35 front and ET40 rear. Hardware is 5x120, 66.9 mm, M14x1.5. Sources: https://www.corvetteblogger.com/docs/2025CorvetteOrderGuide.pdf ; https://ccimages.corvettecentral.com/pdf/c8_catalog_corvettecentral.pdf'),
('Chevrolet','C8','E-Ray',2024,2026,'C8 E-Ray production package','US',true,'20x10 ET35','21x13 ET40','275/30R20 front / 345/25R21 rear','5x120','66.9mm','verified','Chevrolet E-Ray production data specifies the widebody 20x10 and 21x13 package with 275/30R20 and 345/25R21 Michelin all-season tires; OEM wheel documentation establishes ET35/ET40. Hardware is 5x120, 66.9 mm, M14x1.5. Sources: https://www.corvetteblogger.com/docs/2025CorvetteOrderGuide.pdf ; https://ccimages.corvettecentral.com/pdf/c8_catalog_corvettecentral.pdf');

delete from public.fitment_factory_baselines where make='Chevrolet' and model in ('C5','C6','C7','C8');
insert into public.fitment_factory_baselines(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note from chevrolet_corvette_verified_baselines;
select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status from public.fitment_factory_baselines where make='Chevrolet' and model in ('C5','C6','C7','C8') and active order by model,trim,is_default desc,year_start;
