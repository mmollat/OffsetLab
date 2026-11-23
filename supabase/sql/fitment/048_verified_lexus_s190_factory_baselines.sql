-- Offset Lab Fitment
-- Pack 048: verified third-generation Lexus GS factory baselines.
-- Plain SQL only and safe to re-run.

update public.vehicle_models
set year_start = 2006, year_end = 2011
where make = 'Lexus' and model = 'S190';

-- The combined catalog entry spans several US-market powertrains. Display the
-- standard GS 350 package by default and retain the V8 package as a verified
-- alternate below.
update public.fitment_presets
set factory_front = '17x7.5 ET45',
    factory_rear = '17x7.5 ET45',
    factory_tire = '225/50R17 front / 225/50R17 rear',
    bolt_pattern = '5x114.3',
    center_bore = '60.1mm'
where make = 'Lexus'
  and model = 'S190'
  and trim = 'GS350 / GS430 / GS460'
  and active is not false;

create temp table if not exists lexus_s190_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table lexus_s190_verified_baselines;

insert into lexus_s190_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
('Lexus','S190','GS350 / GS430 / GS460',2007,2011,
 'GS 350 standard 17-inch production package','US',true,
 '17x7.5 ET45','17x7.5 ET45',
 '225/50R17 front / 225/50R17 rear','5x114.3','60.1mm','verified',
 'The Lexus 2011 GS brochure specifies the standard GS 350 17x7.5-inch wheel with 225/50R17 tires; genuine Lexus wheel 4261A-30100 is cataloged as 17x7.5J. The production wheel is ET45, and S190 hardware is 5x114.3 with a 60.1 mm center bore and M12x1.5 lug nuts. Sources: https://autocatalogarchive.com/wp-content/uploads/2017/02/Lexus-GS-2011-USA.pdf ; https://www.lexuspartsnow.com/parts-list/2011-lexus-gs350/power_train_chassis/disc_wheel_wheel_cap.html ; https://wheelpcd.co.uk/fitment-guide/lexus/gs/2011/'),
('Lexus','S190','GS350 / GS430 / GS460',2006,2011,
 'GS 430 / GS 460 standard 18-inch production package','US',false,
 '18x8 ET45','18x8 ET45',
 '245/40R18 front / 245/40R18 rear','5x114.3','60.1mm','verified',
 'Lexus Canada specifications and Lexus US brochures specify 18x8-inch wheels with 245/40R18 tires for the GS 430 and GS 460. The genuine Lexus parts catalog identifies the 18x8J production wheel, and the production wheel is ET45. Hardware is 5x114.3 with a 60.1 mm center bore and M12x1.5 lug nuts. Sources: https://media.lexus.ca/content/dam/media-lexus/general/unassigned/20145/2006GS430_RWD_En.pdf ; https://xr793.com/wp-content/uploads/2022/01/2006-Lexus-GS.pdf ; https://www.lexuspartsnow.com/parts-list/2006-lexus-gs430/power_train_chassis/disc_wheel_wheel_cap.html ; https://wheelpcd.co.uk/fitment-guide/lexus/gs/2011/');

delete from public.fitment_factory_baselines
where make = 'Lexus' and model = 'S190';

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market, is_default,
       front, rear, tire, bolt_pattern, center_bore, source_status, source_note
from lexus_s190_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front, rear,
       tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Lexus' and model = 'S190' and active
order by is_default desc, year_start;
