-- Offset Lab Fitment
-- Pack 032: verified US-market Tesla factory baselines.
--
-- Plain SQL only. Safe to re-run.
-- Current standard packages are defaults; documented factory alternatives and
-- superseded packages are retained as non-default rows.

update public.vehicle_models
set year_start = case model
      when 'Model 3' then 2017
      when 'Model S' then 2021
      when 'Model X' then 2021
      when 'Model Y' then 2020
    end,
    year_end = null
where make = 'Tesla' and model in ('Model 3', 'Model S', 'Model X', 'Model Y');

-- Populate the card-level factory fields from the current/default package.
update public.fitment_presets
set factory_front = '18x8.5 ET38',
    factory_rear = '18x8.5 ET38',
    factory_tire = '235/45R18 front / 235/45R18 rear',
    bolt_pattern = '5x114.3',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model 3' and trim = 'RWD / Long Range'
  and active is not false;

update public.fitment_presets
set factory_front = '20x9 ET34',
    factory_rear = '20x10 ET45',
    factory_tire = '235/35R20 front / 275/30R20 rear',
    bolt_pattern = '5x114.3',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model 3' and trim = 'Performance'
  and active is not false;

update public.fitment_presets
set factory_front = '19x9.5 ET40',
    factory_rear = '19x10.5 ET45',
    factory_tire = '255/45R19 front / 285/40R19 rear',
    bolt_pattern = '5x120',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model S'
  and trim in ('Long Range', 'Plaid') and active is not false;

update public.fitment_presets
set factory_front = '20x9 ET40',
    factory_rear = '20x10 ET35',
    factory_tire = '265/45R20 front / 275/45R20 rear',
    bolt_pattern = '5x120',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model X'
  and trim in ('Long Range', 'Plaid') and active is not false;

update public.fitment_presets
set factory_front = '19x9.5 ET45',
    factory_rear = '19x9.5 ET45',
    factory_tire = '255/45R19 front / 255/45R19 rear',
    bolt_pattern = '5x114.3',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model Y' and trim = 'Long Range'
  and active is not false;

update public.fitment_presets
set factory_front = '21x9.5 ET40',
    factory_rear = '21x10.5 ET52',
    factory_tire = '255/35R21 front / 275/35R21 rear',
    bolt_pattern = '5x114.3',
    center_bore = '64.1mm'
where make = 'Tesla' and model = 'Model Y' and trim = 'Performance'
  and active is not false;

-- OEM+ must be a mild change from OEM, not an OEM package copied verbatim.
update public.fitment_presets
set front = '20x9 +29', rear = '20x10 +40',
    front_tire = '235/35R20', rear_tire = '275/30R20'
where make = 'Tesla' and model = 'Model 3' and trim = 'Performance'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '19x9.5 +35', rear = '19x10.5 +40',
    front_tire = '255/45R19', rear_tire = '285/40R19'
where make = 'Tesla' and model = 'Model S' and trim = 'Long Range'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '21x9.5 +35', rear = '21x10.5 +40',
    front_tire = '265/35R21', rear_tire = '295/30R21'
where make = 'Tesla' and model = 'Model S' and trim = 'Plaid'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '20x9 +35', rear = '20x10 +30',
    front_tire = '265/45R20', rear_tire = '275/45R20'
where make = 'Tesla' and model = 'Model X' and trim = 'Long Range'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '19x9.5 +38', rear = '19x9.5 +38',
    front_tire = '255/45R19', rear_tire = '255/45R19'
where make = 'Tesla' and model = 'Model Y' and trim = 'Long Range'
  and style = 'oemplus' and active is not false;

update public.fitment_presets
set front = '21x9.5 +35', rear = '21x10.5 +47',
    front_tire = '255/35R21', rear_tire = '275/35R21'
where make = 'Tesla' and model = 'Model Y' and trim = 'Performance'
  and style = 'oemplus' and active is not false;

create temp table if not exists tesla_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table tesla_verified_baselines;

insert into tesla_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Tesla', 'Model 3', 'RWD / Long Range', 2024, null,
   '18-inch Photon standard package', 'US', true,
   '18x8.5 ET38', '18x8.5 ET38',
   '235/45R18 front / 235/45R18 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla Model 3 Owner''s Manual wheel-and-tire specification: 18x8.5J ET38 with 235/45R18 tires. Tesla specifies 175 Nm lug-nut torque; Model 3 hardware is 5x114.3, 64.1 mm hub bore, M14x1.5. Source: https://www.tesla.com/ownersmanual/model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model 3', 'RWD / Long Range', 2017, 2023,
   '18-inch Aero standard package', 'US', false,
   '18x8.5 ET40', '18x8.5 ET40',
   '235/45R18 front / 235/45R18 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla 2017-2023 Model 3 Owner''s Manual wheel-and-tire specification: 18x8.5J ET40 with 235/45R18 tires. Hardware is 5x114.3, 64.1 mm hub bore, M14x1.5; Tesla specifies 175 Nm lug torque. Source: https://www.tesla.com/ownersmanual/2017_2023_model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model 3', 'RWD / Long Range', 2024, null,
   '19-inch Nova factory option', 'US', false,
   '19x8.5 ET38', '19x8.5 ET38',
   '235/40R19 front / 235/40R19 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla Model 3 Owner''s Manual wheel-and-tire specification: optional 19x8.5J ET38 with 235/40R19 tires. Source: https://www.tesla.com/ownersmanual/model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model 3', 'Performance', 2024, null,
   '20-inch Warp staggered Performance package', 'US', true,
   '20x9 ET34', '20x10 ET45',
   '235/35R20 front / 275/30R20 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla Model 3 Owner''s Manual and 2024 Service Manual specify the Performance staggered package: 20x9J ET34 front with 235/35R20 and 20x10J ET45 rear with 275/30R20. Hardware is 5x114.3, 64.1 mm, M14x1.5; lug torque is 175 Nm. Sources: https://www.tesla.com/ownersmanual/model3/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html ; https://service.tesla.com/docs/Model3/ServiceManual/2024/en-au/air/GUID-B6813E31-8CD2-494E-80F5-497AEEAE1DE0.html'),
  ('Tesla', 'Model S', 'Long Range', 2021, null,
   '19-inch Tempest standard package', 'US', true,
   '19x9.5 ET40', '19x10.5 ET45',
   '255/45R19 front / 285/40R19 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model S Owner''s Manual specifies 19x9.5J ET40 front and 19x10.5J ET45 rear with 255/45R19 and 285/40R19 tires. Hardware is 5x120, 64.1 mm, M14x1.5; Tesla specifies 175 Nm lug torque. Source: https://www.tesla.com/ownersmanual/models/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model S', 'Long Range', 2021, null,
   '21-inch Arachnid factory option', 'US', false,
   '21x9.5 ET40', '21x10.5 ET45',
   '265/35R21 front / 295/30R21 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model S Owner''s Manual specifies the optional 21-inch staggered package: 21x9.5J ET40 front and 21x10.5J ET45 rear with 265/35R21 and 295/30R21 tires. Source: https://www.tesla.com/ownersmanual/models/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model S', 'Plaid', 2021, null,
   '19-inch Tempest standard package', 'US', true,
   '19x9.5 ET40', '19x10.5 ET45',
   '255/45R19 front / 285/40R19 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model S Owner''s Manual specifies 19x9.5J ET40 front and 19x10.5J ET45 rear with 255/45R19 and 285/40R19 tires for the current Model S range, including Plaid. Hardware is 5x120, 64.1 mm, M14x1.5; lug torque is 175 Nm. Source: https://www.tesla.com/ownersmanual/models/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model S', 'Plaid', 2021, null,
   '21-inch Arachnid factory option', 'US', false,
   '21x9.5 ET40', '21x10.5 ET45',
   '265/35R21 front / 295/30R21 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model S Owner''s Manual specifies the optional 21-inch staggered package: 21x9.5J ET40 front and 21x10.5J ET45 rear with 265/35R21 and 295/30R21 tires. Source: https://www.tesla.com/ownersmanual/models/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model X', 'Long Range', 2021, null,
   '20-inch Cyberstream standard package', 'US', true,
   '20x9 ET40', '20x10 ET35',
   '265/45R20 front / 275/45R20 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model X Owner''s Manual and Tesla Shop specify 20x9J ET40 front and 20x10J ET35 rear with 265/45R20 and 275/45R20 tires. Hardware is 5x120, 64.1 mm, M14x1.5; lug torque is 175 Nm. Sources: https://www.tesla.com/ownersmanual/modelx/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html ; https://shop.tesla.com/product/2021-2025-_-model-x-20_-cyberstream-wheel-and-winter-tire-package'),
  ('Tesla', 'Model X', 'Long Range', 2021, null,
   '22-inch Turbine factory option', 'US', false,
   '22x9 ET40', '22x10 ET35',
   '265/35R22 front / 285/35R22 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model X Owner''s Manual specifies the optional 22-inch staggered package: 22x9J ET40 front and 22x10J ET35 rear with 265/35R22 and 285/35R22 tires. Source: https://www.tesla.com/ownersmanual/modelx/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model X', 'Plaid', 2021, null,
   '20-inch Cyberstream standard package', 'US', true,
   '20x9 ET40', '20x10 ET35',
   '265/45R20 front / 275/45R20 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model X Owner''s Manual and Tesla Shop specify 20x9J ET40 front and 20x10J ET35 rear with 265/45R20 and 275/45R20 tires for the current Model X range, including Plaid. Hardware is 5x120, 64.1 mm, M14x1.5; lug torque is 175 Nm. Sources: https://www.tesla.com/ownersmanual/modelx/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html ; https://shop.tesla.com/product/2021-2025-_-model-x-20_-cyberstream-wheel-and-winter-tire-package'),
  ('Tesla', 'Model X', 'Plaid', 2021, null,
   '22-inch Turbine factory option', 'US', false,
   '22x9 ET40', '22x10 ET35',
   '265/35R22 front / 285/35R22 rear', '5x120', '64.1mm', 'verified',
   'Tesla Model X Owner''s Manual specifies the optional 22-inch staggered package: 22x9J ET40 front and 22x10J ET35 rear with 265/35R22 and 285/35R22 tires. Source: https://www.tesla.com/ownersmanual/modelx/en_mo/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model Y', 'Long Range', 2020, null,
   '19-inch Gemini standard package', 'US', true,
   '19x9.5 ET45', '19x9.5 ET45',
   '255/45R19 front / 255/45R19 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla Model Y Owner''s Manual specifies 19x9.5J ET45 wheels with 255/45R19 tires. Hardware is 5x114.3, 64.1 mm, M14x1.5; Tesla specifies 175 Nm lug torque. Source: https://www.tesla.com/ownersmanual/modely/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model Y', 'Long Range', 2020, null,
   '20-inch Induction factory option', 'US', false,
   '20x9.5 ET45', '20x9.5 ET45',
   '255/40R20 front / 255/40R20 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla Model Y Owner''s Manual specifies the optional 20x9.5J ET45 package with 255/40R20 tires. Source: https://www.tesla.com/ownersmanual/modely/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model Y', 'Performance', 2025, null,
   '21-inch staggered Performance package', 'US', true,
   '21x9.5 ET40', '21x10.5 ET52',
   '255/35R21 front / 275/35R21 rear', '5x114.3', '64.1mm', 'verified',
   'Current Tesla Model Y Owner''s Manual specifies the staggered Performance package: 21x9.5J ET40 front with 255/35R21 and 21x10.5J ET52 rear with 275/35R21. Hardware is 5x114.3, 64.1 mm, M14x1.5; lug torque is 175 Nm. Source: https://www.tesla.com/ownersmanual/modely/en_us/GUID-FDDB10EF-FFA9-46EB-B8CC-03614AE92B6B.html'),
  ('Tesla', 'Model Y', 'Performance', 2020, 2024,
   '21-inch Uberturbine Performance package', 'US', false,
   '21x9.5 ET40', '21x10.5 ET48',
   '255/35R21 front / 275/35R21 rear', '5x114.3', '64.1mm', 'verified',
   'Tesla 2020-2024 Model Y Owner''s Manual and Service Manual specify 21x9.5J ET40 front and 21x10.5J ET48 rear with 255/35R21 and 275/35R21 tires. Sources: https://www.tesla.com/ownersmanual/2020_2024_modely/en_il/Owners_Manual.pdf ; https://service.tesla.com/docs/ModelY/ServiceManual/en-us/GUID-6B20CACF-C224-4B28-9592-7BEB02E9AEB6.html');

delete from public.fitment_factory_baselines existing
where existing.make = 'Tesla'
  and existing.model in ('Model 3', 'Model S', 'Model X', 'Model Y')
  and existing.trim in ('RWD / Long Range', 'Performance', 'Long Range', 'Plaid');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from tesla_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Tesla' and active
order by model, trim, is_default desc, year_start desc;
