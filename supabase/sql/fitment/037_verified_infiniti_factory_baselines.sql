-- Offset Lab Fitment
-- Pack 037: verified US-market Infiniti factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Uses the standard/base package for generic trims and the distinct factory
-- performance package for Red Sport trims. The Q60 is CV37, not V37.

-- This V37 row duplicates the canonical CV37 Q60 Red Sport row. No submitted
-- builds reference the incorrect model/trim combination.
update public.fitment_presets
set active = false
where make = 'Infiniti' and model = 'V37' and trim = 'Q60 Red Sport';

update public.vehicle_trims
set active = false
where make = 'Infiniti' and model = 'V37' and trim = 'Q60 Red Sport';

update public.vehicle_models
set year_start = case model
      when 'V35' then 2003
      when 'V36' then 2008
      when 'V37' then 2014
      when 'CV37' then 2017
    end,
    year_end = case model
      when 'V35' then 2007
      when 'V36' then 2013
      when 'V37' then 2024
      when 'CV37' then 2022
    end
where make = 'Infiniti' and model in ('V35', 'V36', 'V37', 'CV37');

update public.fitment_presets
set factory_front = case trim
      when 'G35 Coupe' then '17x7.5 ET30'
      when 'G35 Sedan' then '17x7 ET45'
    end,
    factory_rear = case trim
      when 'G35 Coupe' then '17x8 ET33'
      when 'G35 Sedan' then '17x7 ET45'
    end,
    factory_tire = case trim
      when 'G35 Coupe' then '225/50R17 front / 235/50R17 rear'
      when 'G35 Sedan' then '215/55R17 front / 215/55R17 rear'
    end,
    bolt_pattern = '5x114.3', center_bore = '66.1mm'
where make = 'Infiniti' and model = 'V35'
  and trim in ('G35 Coupe', 'G35 Sedan') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'G37 Coupe' then '18x8 ET43'
      when 'G37 Sedan' then '17x7.5 ET45'
    end,
    factory_rear = case trim
      when 'G37 Coupe' then '18x8 ET43'
      when 'G37 Sedan' then '17x7.5 ET45'
    end,
    factory_tire = case trim
      when 'G37 Coupe' then '225/50R18 front / 225/50R18 rear'
      when 'G37 Sedan' then '225/55R17 front / 225/55R17 rear'
    end,
    bolt_pattern = '5x114.3', center_bore = '66.1mm'
where make = 'Infiniti' and model = 'V36'
  and trim in ('G37 Coupe', 'G37 Sedan') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'Q50' then '18x7.5 ET45'
      when 'Q50 Red Sport' then '19x9 ET47'
    end,
    factory_rear = case trim
      when 'Q50' then '18x7.5 ET45'
      when 'Q50 Red Sport' then '19x9.5 ET50'
    end,
    factory_tire = case trim
      when 'Q50' then '225/50R18 front / 225/50R18 rear'
      when 'Q50 Red Sport' then '245/40R19 front / 265/35R19 rear'
    end,
    bolt_pattern = '5x114.3', center_bore = '66.1mm'
where make = 'Infiniti' and model = 'V37'
  and trim in ('Q50', 'Q50 Red Sport') and active is not false;

update public.fitment_presets
set factory_front = case trim
      when 'Q60' then '19x9 ET40'
      when 'Q60 Red Sport' then '20x9 ET40'
    end,
    factory_rear = case trim
      when 'Q60' then '19x9 ET40'
      when 'Q60 Red Sport' then '20x9.5 ET47'
    end,
    factory_tire = case trim
      when 'Q60' then '255/40R19 front / 255/40R19 rear'
      when 'Q60 Red Sport' then '255/35R20 front / 275/30R20 rear'
    end,
    bolt_pattern = '5x114.3', center_bore = '66.1mm'
where make = 'Infiniti' and model = 'CV37'
  and trim in ('Q60', 'Q60 Red Sport') and active is not false;

-- Red Sport begins with a staggered 20-inch factory package. Keep OEM+ on
-- that diameter and make the change subtle rather than downsizing to 19-inch.
update public.fitment_presets
set front = '20x9 +35', rear = '20x9.5 +42',
    front_tire = '255/35R20', rear_tire = '275/30R20'
where make = 'Infiniti' and model = 'CV37' and trim = 'Q60 Red Sport'
  and style = 'oemplus' and active is not false;

create temp table if not exists infiniti_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table infiniti_verified_baselines;

insert into infiniti_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Infiniti', 'V35', 'G35 Coupe', 2003, 2007,
   '17-inch standard coupe package', 'US', true,
   '17x7.5 ET30', '17x8 ET33',
   '225/50R17 front / 235/50R17 rear', '5x114.3', '66.1mm', 'verified',
   'The Infiniti G35 owner manual wheel-and-tire table specifies the coupe 17-inch package as 17x7.5 ET30 front and 17x8 ET33 rear with P225/50R17 and P235/50R17 tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Sources: https://cdn.dealereprocess.org/cdn/servicemanuals/infiniti/2006-g35.pdf ; https://www.nicoclub.com/service-manual?fsm_download=G35+G37+Q40%2FG35%2FCoupe%2F2007%2Fgi.pdf'),
  ('Infiniti', 'V35', 'G35 Sedan', 2003, 2006,
   '17-inch standard sedan package', 'US', true,
   '17x7 ET45', '17x7 ET45',
   '215/55R17 front / 215/55R17 rear', '5x114.3', '66.1mm', 'verified',
   'The Infiniti G35 owner manual wheel-and-tire table specifies the sedan standard package as 17x7 ET45 with P215/55R17 tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Source: https://cdn.dealereprocess.org/cdn/servicemanuals/infiniti/2006-g35.pdf'),
  ('Infiniti', 'V36', 'G37 Coupe', 2008, 2013,
   '18-inch standard coupe package', 'US', true,
   '18x8 ET43', '18x8 ET43',
   '225/50R18 front / 225/50R18 rear', '5x114.3', '66.1mm', 'verified',
   'The Infiniti G owner manual lists the standard coupe package as 18x8 ET43 with P225/50R18 tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Source: https://cdn.dealereprocess.org/cdn/servicemanuals/infiniti/2012-g37sedan.pdf'),
  ('Infiniti', 'V36', 'G37 Sedan', 2009, 2013,
   '17-inch standard sedan package', 'US', true,
   '17x7.5 ET45', '17x7.5 ET45',
   '225/55R17 front / 225/55R17 rear', '5x114.3', '66.1mm', 'verified',
   'The Infiniti G owner manual lists the standard sedan package as 17x7.5 ET45 with P225/55R17 tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Source: https://cdn.dealereprocess.org/cdn/servicemanuals/infiniti/2012-g37sedan.pdf'),
  ('Infiniti', 'V37', 'Q50', 2022, 2024,
   '18-inch later Q50 standard package', 'US', true,
   '18x7.5 ET45', '18x7.5 ET45',
   '225/50R18 front / 225/50R18 rear', '5x114.3', '66.1mm', 'verified',
   'Infiniti Q50 owner manuals specify the later standard package as 18x7.5 ET45 with P225/50R18 run-flat tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Sources: https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q50/2021/2021-infiniti-q50-owner-manual.pdf ; https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q50/2024/2024-infiniti-q50-owner-manual.pdf'),
  ('Infiniti', 'V37', 'Q50', 2014, 2021,
   '17-inch earlier Q50 standard package', 'US', false,
   '17x7.5 ET45', '17x7.5 ET45',
   '225/55R17 front / 225/55R17 rear', '5x114.3', '66.1mm', 'verified',
   'Infiniti Q50 owner manuals specify the earlier standard package as 17x7.5 ET45 with P225/55R17 run-flat tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Sources: https://admin.owners.infinitiusa.com/content/manualsandguides/Q50/2016/2016-Q50-owner-manual-and-maintenance-info.pdf ; https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q50/2021/2021-infiniti-q50-owner-manual.pdf'),
  ('Infiniti', 'V37', 'Q50 Red Sport', 2016, 2024,
   '19-inch Red Sport 400 RWD package', 'US', true,
   '19x9 ET47', '19x9.5 ET50',
   '245/40R19 front / 265/35R19 rear', '5x114.3', '66.1mm', 'verified',
   'Infiniti Q50 owner manuals specify the staggered 19-inch package as 19x9 ET47 front and 19x9.5 ET50 rear with 245/40R19 and 265/35R19 tires; Infiniti''s US brochure identifies the staggered package with Red Sport 400 RWD. AWD uses 19x9 square. Shared hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Sources: https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q50/2021/2021-infiniti-q50-owner-manual.pdf ; https://www.infinitiusa.com/content/dam/Infiniti/US/vehicle-brochures/2021/2021-infiniti-q50-brochure-en.pdf'),
  ('Infiniti', 'CV37', 'Q60', 2017, 2022,
   '19-inch standard Q60 package', 'US', true,
   '19x9 ET40', '19x9 ET40',
   '255/40R19 front / 255/40R19 rear', '5x114.3', '66.1mm', 'verified',
   'Infiniti Q60 owner manuals specify the standard 19-inch package as 19x9 ET40 with P255/40R19 run-flat tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Source: https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q60_coupe/2021/2021-infiniti-q60-owner-manual.pdf'),
  ('Infiniti', 'CV37', 'Q60 Red Sport', 2017, 2022,
   '20-inch Red Sport RWD package', 'US', true,
   '20x9 ET40', '20x9.5 ET47',
   '255/35R20 front / 275/30R20 rear', '5x114.3', '66.1mm', 'verified',
   'Infiniti Q60 owner manuals specify the staggered 20-inch package as 20x9 ET40 front and 20x9.5 ET47 rear with 255/35R20 and 275/30R20 tires. Shared Nissan/Infiniti hub hardware is 5x114.3, 66.1 mm, with M12x1.25 wheel nuts. Source: https://www.infinitiusa.com/content/dam/Infiniti/US/manuals_guides/q60_coupe/2021/2021-infiniti-q60-owner-manual.pdf');

delete from public.fitment_factory_baselines existing
where existing.make = 'Infiniti'
  and existing.model in ('V35', 'V36', 'V37', 'CV37');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from infiniti_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Infiniti' and active
order by model, trim, is_default desc, year_start desc;
