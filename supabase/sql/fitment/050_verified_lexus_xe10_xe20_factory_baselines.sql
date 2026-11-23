-- Offset Lab Fitment
-- Pack 050: verified first- and second-generation Lexus IS factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2001,year_end=2005
where make='Lexus' and model='XE10';
update public.vehicle_models set year_start=2006,year_end=2014
where make='Lexus' and model='XE20';

update public.fitment_presets
set factory_front='17x7 ET50',factory_rear='17x7 ET50',
    factory_tire='215/45R17 front / 215/45R17 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='XE10' and trim='IS300' and active is not false;

update public.fitment_presets
set factory_front='17x8 ET45',factory_rear='17x8 ET45',
    factory_tire='225/45R17 front / 245/45R17 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='XE20' and trim='IS250 / IS350'
  and active is not false;

update public.fitment_presets
set factory_front='19x8 ET45',factory_rear='19x9 ET55',
    factory_tire='225/40R19 front / 255/35R19 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='XE20' and trim='IS F' and active is not false;

create temp table if not exists lexus_xe_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table lexus_xe_verified_baselines;

insert into lexus_xe_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Lexus','XE10','IS300',2001,2005,'IS 300 17-inch production package','US',true,
 '17x7 ET50','17x7 ET50','215/45R17 front / 215/45R17 rear',
 '5x114.3','60.1mm','verified',
 'The Lexus 2001 IS brochure, specification sheet, and owner manual specify 17x7-inch wheels with 215/45ZR17 tires. The genuine Lexus parts catalog identifies the production wheel as 17x7JJ with offset 50. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://www.auto-brochures.com/makes/lexus/IS/Lexus_US%20IS_2001.pdf ; https://www.xr793.com/wp-content/uploads/2022/01/2001-Lexus-IS-Specs.pdf ; https://www.lexuspartsnow.com/parts-list/2002-lexus-is300/power_train_chassis/disc_wheel_wheel_cap.html'),
('Lexus','XE20','IS250 / IS350',2006,2013,
 'IS 250 / IS 350 RWD standard 17-inch production package','US',true,
 '17x8 ET45','17x8 ET45','225/45R17 front / 245/45R17 rear',
 '5x114.3','60.1mm','verified',
 'The Lexus 2006 IS brochure and owner manual specify 17x8-inch wheels with 225/45R17 front and 245/45R17 rear tires for the RWD IS 250 and IS 350. Genuine production wheel references identify ET45. Hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://www.auto-brochures.com/makes/lexus/IS/Lexus_US%20IS_2006.pdf ; https://xr793.com/wp-content/uploads/2025/01/2006-Lexus-IS.pdf ; https://www.carmanualsonline.info/lexus-is350-2006-scheduled-maintenance-guide-lexus-2006-is350-250-through-april-2006-prod-owner-s-manual-om53508u/?srch=tire+type ; https://oemwheelexperts.com/catalog/2006-2008-lexus-17x8-wheel-rim-4261153150-4261153240-oem-factory-all-silver.php'),
('Lexus','XE20','IS F',2008,2014,'IS F forged BBS production package','US',true,
 '19x8 ET45','19x9 ET55','225/40R19 front / 255/35R19 rear',
 '5x114.3','60.1mm','verified',
 'Lexus IS F launch specifications and the Lexus CPO equipment sheet specify forged BBS 19x8 front and 19x9 rear wheels with 225/40R19 and 255/35R19 tires. The production fitment is ET45 front and ET55 rear; hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://www.allcarcentral.com/lexus-pdf/Lexus_IS_F_Specs-2008.pdf ; https://cpo.lexus.jp/resource/pdf/isf_04.pdf ; https://rd-tanabe.com/item_wheel/01.pdf');

delete from public.fitment_factory_baselines
where make='Lexus' and model in ('XE10','XE20');

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from lexus_xe_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Lexus' and model in ('XE10','XE20') and active
order by model,trim;
