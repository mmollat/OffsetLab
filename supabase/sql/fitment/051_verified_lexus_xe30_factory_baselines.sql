-- Offset Lab Fitment
-- Pack 051: verified third-generation Lexus IS factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models set year_start=2014,year_end=2027
where make='Lexus' and model='XE30';

-- The combined trim spans the original XE30 and its later refreshes. The
-- earliest US-market base production package is the displayed default; later
-- factory packages remain available as verified alternatives below.
update public.fitment_presets
set factory_front='17x7.5 ET45',factory_rear='17x7.5 ET45',
    factory_tire='225/45R17 front / 225/45R17 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='XE30' and trim='IS250 / IS300 / IS350'
  and active is not false;

update public.fitment_presets
set factory_front='19x8.5 ET45',factory_rear='19x9.5 ET60',
    factory_tire='235/40R19 front / 265/35R19 rear',
    bolt_pattern='5x114.3',center_bore='60.1mm'
where make='Lexus' and model='XE30' and trim='IS500' and active is not false;

create temp table if not exists lexus_xe30_verified_baselines (
 make text,model text,trim text,year_start int,year_end int,package_name text,
 market text,is_default boolean,front text,rear text,tire text,
 bolt_pattern text,center_bore text,source_status text,source_note text
) on commit drop;
truncate table lexus_xe30_verified_baselines;

insert into lexus_xe30_verified_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
values
('Lexus','XE30','IS250 / IS300 / IS350',2014,2020,
 'IS 250 / IS 300 / IS 350 standard 17-inch production package','US',true,
 '17x7.5 ET45','17x7.5 ET45','225/45R17 front / 225/45R17 rear',
 '5x114.3','60.1mm','verified',
 'The Lexus 2014 IS owner manual and Lexus equipment documentation specify the standard 17x7.5J wheel with 225/45R17 tires. The production wheel is ET45; hardware is 5x114.3, 60.1 mm with M12x1.5 lug nuts. Sources: https://www.carmanualsonline.info/lexus-is350-2014-owner-s-manual-lexus-2014-is250-is350-owners-manual-om53758u/51 ; https://cpo.lexus.jp/resource/pdf/is_11.pdf ; https://pressroom.lexus.com/lexus-third-generation-is-sport-sedan-2014/'),
('Lexus','XE30','IS250 / IS300 / IS350',2021,2025,
 'IS 300 standard 18-inch refresh production package','US',false,
 '18x8.5 ET45','18x8.5 ET45','235/45R18 front / 235/45R18 rear',
 '5x114.3','60.1mm','verified',
 'Lexus 2022 specifications and the owner manual specify the refreshed IS 300 standard 18x8.5J wheel with 235/45R18 tires. The production wheel is ET45. Refreshed cars use 5x114.3, a 60.1 mm center bore, M14x1.5 wheel bolts and 140 N-m torque. Sources: https://motorfrontier.com/wp-content/uploads/2022/10/2022_Lexus_IS_Specifications.pdf ; https://manual.lexus.jp/pdf/is/IS500-IS350-IS300_OM_JP_M53F81_1_2208.pdf'),
('Lexus','XE30','IS250 / IS300 / IS350',2026,2027,
 'IS 350 F SPORT production package','US',false,
 '19x8.5 ET45','19x9.5 ET60','235/40R19 front / 265/35R19 rear',
 '5x114.3','60.1mm','verified',
 'Lexus USA specifies staggered 235/40R19 front and 265/35R19 rear tires for the 2026-2027 IS 350 F SPORT. The carried-over production wheels are 19x8.5 ET45 front and 19x9.5 ET60 rear. Hardware is 5x114.3, 60.1 mm with M14x1.5 wheel bolts. Sources: https://pressroom.lexus.com/2026-lexus-is-perfecting-the-sport-sedan/ ; https://pressroom.lexus.com/2027-lexus-is-turns-heads-with-new-envious-special-appearance-package/'),
('Lexus','XE30','IS500',2022,2025,
 'IS 500 F SPORT Performance production package','US',true,
 '19x8.5 ET45','19x9.5 ET60','235/40R19 front / 265/35R19 rear',
 '5x114.3','60.1mm','verified',
 'The Lexus 2022 IS brochure, specification sheet, owner manual and genuine parts catalog specify 19x8.5J front and 19x9.5J rear wheels with 235/40R19 and 265/35R19 tires for the IS 500. Production offsets are ET45 front and ET60 rear. Hardware is 5x114.3, 60.1 mm with M14x1.5 wheel bolts torqued to 140 N-m. Sources: https://www.lexus.com/content/dam/lexus/documents/brochures/models/2022/MY22-Lexus-IS-Brochure.pdf ; https://motorfrontier.com/wp-content/uploads/2022/10/2022_Lexus_IS_Specifications.pdf ; https://cdn.dealereprocess.org/cdn/servicemanuals/lexus/2022-is350.pdf ; https://www.lexuspartsnow.com/parts-list/2022-lexus-is500/power_train_chassis/disc_wheel_wheel_cap.html');

delete from public.fitment_factory_baselines
where make='Lexus' and model='XE30';

insert into public.fitment_factory_baselines
(make,model,trim,year_start,year_end,package_name,market,is_default,front,rear,
 tire,bolt_pattern,center_bore,source_status,source_note)
select make,model,trim,year_start,year_end,package_name,market,is_default,front,
       rear,tire,bolt_pattern,center_bore,source_status,source_note
from lexus_xe30_verified_baselines;

select model,trim,year_start,year_end,package_name,is_default,front,rear,tire,
       bolt_pattern,center_bore,source_status
from public.fitment_factory_baselines
where make='Lexus' and model='XE30' and active
order by trim,is_default desc,year_start;
