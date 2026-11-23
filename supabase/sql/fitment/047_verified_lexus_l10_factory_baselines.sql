-- Offset Lab Fitment
-- Pack 047: verified fourth-generation Lexus GS factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2013,year_end=2020 where make='Lexus' and model='L10';

update public.fitment_presets set factory_front='17x7.5 ET45',factory_rear='17x7.5 ET45',factory_tire='225/50R17 front / 225/50R17 rear',bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='L10' and trim='GS350' and active is not false;
update public.fitment_presets set factory_front='19x8 ET45',factory_rear='19x9 ET60',factory_tire='235/40R19 front / 265/35R19 rear',bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='L10' and trim='GS350 / GS F Sport' and active is not false;
update public.fitment_presets set factory_front='19x9 ET50',factory_rear='19x10 ET41',factory_tire='255/35R19 front / 275/35R19 rear',bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='L10' and trim in ('GS F','GSF') and active is not false;

update public.fitment_presets set front='17x7.5 +39',rear='17x7.5 +39',front_tire='225/50R17',rear_tire='225/50R17' where make='Lexus' and model='L10' and trim='GS350' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x8 +39',rear='19x9 +54',front_tire='235/40R19',rear_tire='265/35R19' where make='Lexus' and model='L10' and trim='GS350 / GS F Sport' and style='oemplus' and active is not false;
update public.fitment_presets set front='19x9 +44',rear='19x10 +35',front_tire='255/35R19',rear_tire='275/35R19' where make='Lexus' and model='L10' and trim in ('GS F','GSF') and style='oemplus' and active is not false;

create temp table if not exists lexus_l10_verified_baselines(make text,model text,trim text,year_start int,year_end int,package_name text,market text,is_default boolean,front text,rear text,tire text,bolt_pattern text,center_bore text,source_status text,source_note text) on commit drop;
truncate table lexus_l10_verified_baselines;
insert into lexus_l10_verified_baselines(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
values
('Lexus','L10','GS350',2013,2020,'GS 350 17-inch base production package','US',true,'17x7.5 ET45','17x7.5 ET45','225/50R17 front / 225/50R17 rear','5x114.3','60.1mm','verified','Lexus USA product information and Lexus College technical training specify the standard GS 350 17x7.5 ET45 wheel with 225/50R17 tires. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://pressroom.lexus.com/lexus-allnew-2013-gs350-august2012/ ; https://manuals.plus/m/8262a3bccfae77520b0502a6e48f01e07e71840ceee2df9dcec51fcda2b220f4.pdf'),
('Lexus','L10','GS350 / GS F Sport',2013,2020,'GS 350 RWD F SPORT production package','US',true,'19x8 ET45','19x9 ET60','235/40R19 front / 265/35R19 rear','5x114.3','60.1mm','verified','Lexus USA and Lexus College documentation explicitly specify the RWD F SPORT 19x8 ET45 front and 19x9 ET60 rear wheels with 235/40R19 and 265/35R19 tires. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://xr793.com/wp-content/uploads/2021/05/2013-Lexus-GS-V2.pdf ; https://manuals.plus/m/8262a3bccfae77520b0502a6e48f01e07e71840ceee2df9dcec51fcda2b220f4.pdf'),
('Lexus','L10','GS F',2016,2020,'GS F forged BBS production package','US',true,'19x9 ET50','19x10 ET41','255/35R19 front / 275/35R19 rear','5x114.3','60.1mm','verified','Lexus USA GS F launch data specifies 19x9 front and 19x10 rear forged wheels with 255/35R19 and 275/35R19 Michelin tires. Genuine BBS-made Lexus wheels 42611-30F60/30F70 are marked ET50 front and ET41 rear; hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://pressroom.lexus.com/lexus-2015-naias-gs-f-sedan-debut/ ; https://lexus.oempartsonline.com/v-2017-lexus-gs-f--base--5-0l-v8-gas/suspension--wheels'),
('Lexus','L10','GSF',2016,2020,'GS F forged BBS production package','US',true,'19x9 ET50','19x10 ET41','255/35R19 front / 275/35R19 rear','5x114.3','60.1mm','verified','This duplicate catalog label represents the same Lexus GS F model. Lexus USA specifies 19x9 and 19x10 forged wheels with 255/35R19 and 275/35R19 tires; genuine BBS-made wheels are ET50/ET41. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://pressroom.lexus.com/lexus-2015-naias-gs-f-sedan-debut/ ; https://www.originalwheels.com/lexus-wheels/gs-f2019rims.php');

delete from public.fitment_factory_baselines where make='Lexus' and model='L10';
insert into public.fitment_factory_baselines(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,tire,bolt_pattern,center_bore,source_status,source_note from lexus_l10_verified_baselines;
select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,bolt_pattern,center_bore,source_status from public.fitment_factory_baselines where make='Lexus' and model='L10' and active order by trim;
