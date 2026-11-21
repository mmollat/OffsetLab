-- Offset Lab Fitment
-- Pack 036: verified US-market Mitsubishi performance-car baselines.
--
-- Plain SQL only. Safe to re-run.
-- Removes duplicate Evo/Evolution labels and retains period-specific VR-4
-- factory packages instead of collapsing two generations into one setup.

-- These shorthand CT9A rows duplicate the canonical Mitsubishi model names.
-- No build submissions reference them.
update public.fitment_presets
set active = false
where make = 'Mitsubishi' and model = 'CT9A'
  and trim in ('Evo VIII', 'Evo IX');

update public.vehicle_trims
set active = false
where make = 'Mitsubishi' and model = 'CT9A'
  and trim in ('Evo VIII', 'Evo IX');

update public.vehicle_models
set year_start = case model
      when 'CT9A' then 2003
      when 'CZ4A' then 2008
      when 'D32A' then 1991
    end,
    year_end = case model
      when 'CT9A' then 2006
      when 'CZ4A' then 2015
      when 'D32A' then 1999
    end
where make = 'Mitsubishi' and model in ('CT9A', 'CZ4A', 'D32A');

update public.fitment_presets
set factory_front = '17x8 ET38',
    factory_rear = '17x8 ET38',
    factory_tire = '235/45R17 front / 235/45R17 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Mitsubishi' and model = 'CT9A'
  and trim in ('Evolution VIII', 'Evolution IX') and active is not false;

update public.fitment_presets
set factory_front = '18x8.5 ET38',
    factory_rear = '18x8.5 ET38',
    factory_tire = '245/40R18 front / 245/40R18 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Mitsubishi' and model = 'CZ4A'
  and trim in ('Evolution X', 'GSR', 'MR') and active is not false;

update public.fitment_presets
set factory_front = '18x8.5 ET46',
    factory_rear = '18x8.5 ET46',
    factory_tire = '245/40R18 front / 245/40R18 rear',
    bolt_pattern = '5x114.3',
    center_bore = '67.1mm'
where make = 'Mitsubishi' and model = 'D32A' and trim = 'VR-4'
  and active is not false;

-- Canonical CT9A and generic Evolution X OEM+ presets use a subtle 6 mm
-- outward change from factory. GSR/MR already add useful width.
update public.fitment_presets
set front = '17x8 +32', rear = '17x8 +32',
    front_tire = '235/45R17', rear_tire = '235/45R17'
where make = 'Mitsubishi' and model = 'CT9A'
  and trim in ('Evolution VIII', 'Evolution IX')
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '18x8.5 +32', rear = '18x8.5 +32',
    front_tire = '245/40R18', rear_tire = '245/40R18'
where make = 'Mitsubishi' and model = 'CZ4A' and trim = 'Evolution X'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '18x8.5 +40', rear = '18x8.5 +40',
    front_tire = '245/40R18', rear_tire = '245/40R18'
where make = 'Mitsubishi' and model = 'D32A' and trim = 'VR-4'
  and style = 'oemplus' and active is not false;

create temp table if not exists mitsubishi_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table mitsubishi_verified_baselines;

insert into mitsubishi_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Mitsubishi', 'CT9A', 'Evolution VIII', 2003, 2005,
   '17-inch Enkei standard package', 'US', true,
   '17x8 ET38', '17x8 ET38',
   '235/45R17 front / 235/45R17 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s 2003 US Lancer Evolution VIII technical/service manual, Group 31, specifies 17x8JJ aluminum wheels, 38 mm offset, 114.3 mm PCD, and P235/45R17 93W tires. Mitsubishi hardware uses a 67.1 mm hub bore and M12x1.5 wheel nuts. Sources: https://www.manualslib.com/manual/1556147/Mitsubishi-Motors-Lancer-Evolution-Viii-2003.html ; https://www.tuningevo.club/manuals/EVO_8/2003_Lancer_Evo_8_Technical_Infomation_Manual.pdf'),
  ('Mitsubishi', 'CT9A', 'Evolution IX', 2006, 2006,
   '17-inch Enkei standard package', 'US', true,
   '17x8 ET38', '17x8 ET38',
   '235/45R17 front / 235/45R17 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s Lancer Evolution IX service manual wheel-and-tire specification gives 17x8JJ aluminum wheels, 38 mm offset, 114.3 mm PCD, and 235/45R17 93W tires. Mitsubishi hardware uses a 67.1 mm hub bore and M12x1.5 wheel nuts. Source: https://zinref.ru/avtomobili/Mitsubishi/190_010_00_Mitsubishi_Lancer_Evolution_IX_service_manual_english/565.htm'),
  ('Mitsubishi', 'CZ4A', 'Evolution X', 2008, 2015,
   '18-inch factory package', 'US', true,
   '18x8.5 ET38', '18x8.5 ET38',
   '245/40R18 front / 245/40R18 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s Evolution X service manual specifies 18x8.5JJ wheels, 38 mm offset, 114.3 mm PCD, and 245/40R18 93Y tires for both GSR and MR. The generic Evolution X row therefore uses the shared factory dimensions. Hardware uses a 67.1 mm hub bore and M12x1.5 wheel nuts. Source: https://zinref.ru/avtomobili/Mitsubishi/195_020_00_Mitsubishi_Evolution_X_manual_2008_english/081.htm'),
  ('Mitsubishi', 'CZ4A', 'GSR', 2008, 2015,
   '18-inch Enkei GSR standard package', 'US', true,
   '18x8.5 ET38', '18x8.5 ET38',
   '245/40R18 front / 245/40R18 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s Evolution X service manual explicitly specifies the GSR aluminum package as 18x8.5JJ, 38 mm offset, 114.3 mm PCD, with 245/40R18 93Y tires. Hardware uses a 67.1 mm hub bore and M12x1.5 wheel nuts. Source: https://zinref.ru/avtomobili/Mitsubishi/195_020_00_Mitsubishi_Evolution_X_manual_2008_english/081.htm'),
  ('Mitsubishi', 'CZ4A', 'MR', 2008, 2015,
   '18-inch BBS MR standard package', 'US', true,
   '18x8.5 ET38', '18x8.5 ET38',
   '245/40R18 front / 245/40R18 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s Evolution X service manual explicitly specifies the MR BBS package as 18x8.5JJ, 38 mm offset, 114.3 mm PCD, with 245/40R18 93Y tires. Hardware uses a 67.1 mm hub bore and M12x1.5 wheel nuts. Source: https://zinref.ru/avtomobili/Mitsubishi/195_020_00_Mitsubishi_Evolution_X_manual_2008_english/081.htm'),
  ('Mitsubishi', 'D32A', 'VR-4', 1994, 1999,
   '18-inch later VR-4 factory package', 'US', true,
   '18x8.5 ET46', '18x8.5 ET46',
   '245/40R18 front / 245/40R18 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi 3000GT service information and OEM wheel markings specify the later VR-4 package as 18x8.5J ET46 with 245/40ZR18 tires. Hardware is 5x114.3 with a 67.1 mm hub bore and M12x1.5 wheel nuts. Sources: https://www.carmanualsonline.info/mitsubishi-3000gt-1991-service-manual/?srch=spare+tire ; https://www.youtube.com/watch?v=q-jJWKYxSpo'),
  ('Mitsubishi', 'D32A', 'VR-4', 1991, 1993,
   '17-inch early VR-4 factory package', 'US', false,
   '17x8.5 ET46', '17x8.5 ET46',
   '245/45R17 front / 245/45R17 rear', '5x114.3', '67.1mm', 'verified',
   'Mitsubishi''s 1991 3000GT service manual wheel-and-tire table specifies the turbo/VR-4 package as 17x8.5J, 46 mm offset, with 245/45ZR17 tires. Hardware is 5x114.3 with a 67.1 mm hub bore and M12x1.5 wheel nuts. Source: https://www.carmanualsonline.info/mitsubishi-3000gt-1991-service-manual/?srch=spare+tire');

delete from public.fitment_factory_baselines existing
where existing.make = 'Mitsubishi'
  and existing.model in ('CT9A', 'CZ4A', 'D32A');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from mitsubishi_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Mitsubishi' and active
order by model, trim, is_default desc, year_start desc;
