-- Offset Lab Fitment
-- Pack 034: verified US-market Dodge LA Challenger and LD Charger baselines.
--
-- Plain SQL only. Safe to re-run.
-- Trim labels are generation-era labels, so each row uses the standard wheel
-- package for that named narrow- or widebody configuration.

update public.vehicle_models
set year_start = 2015, year_end = 2023
where make = 'Dodge' and model in ('LA', 'LD');

update public.fitment_presets
set factory_front = '20x9 ET25.5',
    factory_rear = '20x9 ET25.5',
    factory_tire = '245/45R20 front / 245/45R20 rear',
    bolt_pattern = '5x115',
    center_bore = '71.5mm'
where make = 'Dodge' and model in ('LA', 'LD') and trim = 'Scat Pack'
  and active is not false;

update public.fitment_presets
set factory_front = '20x9.5 ET18.5',
    factory_rear = '20x9.5 ET18.5',
    factory_tire = '275/40R20 front / 275/40R20 rear',
    bolt_pattern = '5x115',
    center_bore = '71.5mm'
where make = 'Dodge' and model in ('LA', 'LD') and trim = 'Hellcat'
  and active is not false;

update public.fitment_presets
set factory_front = '20x11 ET-2.5',
    factory_rear = '20x11 ET-2.5',
    factory_tire = '305/35R20 front / 305/35R20 rear',
    bolt_pattern = '5x115',
    center_bore = '71.5mm'
where make = 'Dodge' and model in ('LA', 'LD') and trim = 'Hellcat Widebody'
  and active is not false;

-- Narrow Hellcat OEM+ keeps the OE tire and moves the OE-width wheel 5.5 mm out.
update public.fitment_presets
set front = '20x9.5 +13', rear = '20x9.5 +13',
    front_tire = '275/40R20', rear_tire = '275/40R20'
where make = 'Dodge' and model in ('LA', 'LD') and trim = 'Hellcat'
  and style = 'oemplus' and active is not false;

-- Widebody OEM+ must retain the 11-inch/305 package rather than regress to a
-- narrow-body 9-inch/275 setup.
update public.fitment_presets
set front = '20x11 -7', rear = '20x11 -7',
    front_tire = '305/35R20', rear_tire = '305/35R20'
where make = 'Dodge' and model in ('LA', 'LD') and trim = 'Hellcat Widebody'
  and style = 'oemplus' and active is not false;

create temp table if not exists dodge_la_ld_verified_baselines (
  make text, model text, trim text, year_start int, year_end int,
  package_name text, market text, is_default boolean, front text, rear text,
  tire text, bolt_pattern text, center_bore text, source_status text,
  source_note text
) on commit drop;

truncate table dodge_la_ld_verified_baselines;

insert into dodge_la_ld_verified_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
values
  ('Dodge', 'LA', 'Scat Pack', 2015, 2023,
   '20-inch narrow-body Scat Pack standard package', 'US', true,
   '20x9 ET25.5', '20x9 ET25.5',
   '245/45R20 front / 245/45R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge Challenger product specifications and brochures specify a square 20x9-inch wheel and 245/45ZR20 tire package as standard for narrow-body R/T Scat Pack. Genuine Mopar wheel interchange/markings for Scat Pack wheels, including parts 5LD39VXWAA and 6CT34VXWAA, specify ET25.5, 5x115, and 71.5 mm center bore. The Dodge owner manual specifies M14x1.50 fasteners. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2023_DG_Challenger_ChallengerSRT_SP.pdf ; https://cdn.dealereprocess.org/cdn/brochures/dodge/ca/2023-challenger.pdf ; https://www.finishlinewheels.com/collections/dodge-charger-factory-rims ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Challenger/5548538_23_LA_OM_EN_USC_DIGITAL_E2.pdf'),
  ('Dodge', 'LA', 'Hellcat', 2015, 2023,
   '20-inch narrow-body SRT Hellcat standard package', 'US', true,
   '20x9.5 ET18.5', '20x9.5 ET18.5',
   '275/40R20 front / 275/40R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge Challenger SRT specifications identify the standard narrow-body Hellcat package as square 20x9.5 forged wheels with 275/40ZR20 tires. Genuine Mopar Hellcat wheel markings/interchange for parts including 2C072DX9AA specify ET18.5, 5x115, and 71.5 mm center bore. The Dodge owner manual specifies M14x1.50 fasteners. Sources: https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2023_DG_Challenger_ChallengerSRT_SP.pdf ; https://www.dodge.com/assets/pdf/brochure/dodge-performance2017.pdf ; https://www.finishlinewheels.com/collections/dodge-charger-factory-rims ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Challenger/5548538_23_LA_OM_EN_USC_DIGITAL_E2.pdf'),
  ('Dodge', 'LA', 'Hellcat Widebody', 2018, 2023,
   '20-inch Hellcat Widebody standard package', 'US', true,
   '20x11 ET-2.5', '20x11 ET-2.5',
   '305/35R20 front / 305/35R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge''s Challenger Widebody specification identifies square 20x11 forged wheels and 305/35ZR20 Pirelli tires. Genuine Mopar Widebody wheel 6TF27TRMAA and related factory wheels are marked ET-2.5, 5x115, with 71.5 mm center bore. The Dodge owner manual specifies M14x1.50 fasteners. Sources: https://cdn.dealereprocess.org/cdn/brochures/dodge/2023-challenger.pdf ; https://s3.amazonaws.com/chryslermedia.iconicweb.com/mediasite/specs/2023_DG_Challenger_ChallengerSRT_SP.pdf ; https://olmstedautomotive.com/products/20-23-dodge-challenger-charger-srt-20x11-wheel-20-rim-mopar-6tf27trmaa-18k ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Challenger/5548538_23_LA_OM_EN_USC_DIGITAL_E2.pdf'),
  ('Dodge', 'LD', 'Scat Pack', 2015, 2023,
   '20-inch narrow-body Scat Pack standard package', 'US', true,
   '20x9 ET25.5', '20x9 ET25.5',
   '245/45R20 front / 245/45R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge Charger product specifications identify the narrow-body R/T Scat Pack package as square 20x9-inch wheels with 245/45ZR20 tires. Genuine Mopar Scat Pack wheel interchange/markings for parts 5LD39VXWAA and 6CT34VXWAA specify ET25.5, 5x115, and 71.5 mm center bore. The 2023 Charger owner manual specifies M14x1.50 fasteners and 130 ft-lb/176 Nm torque. Sources: https://www.finishlinewheels.com/collections/dodge-charger-factory-rims ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Charger/5735565_23_LD_OM_EN_USC_DIGITAL_E3.pdf'),
  ('Dodge', 'LD', 'Hellcat', 2015, 2019,
   '20-inch narrow-body SRT Hellcat standard package', 'US', true,
   '20x9.5 ET18.5', '20x9.5 ET18.5',
   '275/40R20 front / 275/40R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge Charger SRT specifications identify the narrow-body Hellcat package as square 20x9.5 forged wheels with 275/40ZR20 tires. Genuine Mopar Hellcat wheel markings/interchange for parts including 2C072DX9AA and 5LD40JS2AA specify ET18.5, 5x115, and 71.5 mm center bore. The Charger owner manual specifies M14x1.50 fasteners. Sources: https://www.finishlinewheels.com/collections/dodge-charger-factory-rims ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Charger/5735565_23_LD_OM_EN_USC_DIGITAL_E3.pdf'),
  ('Dodge', 'LD', 'Hellcat Widebody', 2020, 2023,
   '20-inch Hellcat Widebody standard package', 'US', true,
   '20x11 ET-2.5', '20x11 ET-2.5',
   '305/35R20 front / 305/35R20 rear', '5x115', '71.5mm', 'verified',
   'Dodge''s Charger Hellcat Widebody package uses square 20x11 forged wheels with 305/35ZR20 tires. Genuine Mopar Widebody wheel 6TF27TRMAA and related factory wheels are marked ET-2.5, 5x115, with 71.5 mm center bore. The 2023 Charger owner manual specifies M14x1.50 fasteners and 130 ft-lb/176 Nm torque. Sources: https://blog.stellantisnorthamerica.com/2023/07/25/limited-edition-mopar-23-dodge-challenger-and-dodge-charger-models-coming-to-us-and-canada/ ; https://olmstedautomotive.com/products/20-23-dodge-challenger-charger-srt-20x11-wheel-20-rim-mopar-6tf27trmaa-18k ; https://vehicleinfo.mopar.com/assets/publications/en-us/Dodge/2023/Charger/5735565_23_LD_OM_EN_USC_DIGITAL_E3.pdf');

delete from public.fitment_factory_baselines existing
where existing.make = 'Dodge' and existing.model in ('LA', 'LD')
  and existing.trim in ('Scat Pack', 'Hellcat', 'Hellcat Widebody');

insert into public.fitment_factory_baselines (
  make, model, trim, year_start, year_end, package_name, market, is_default,
  front, rear, tire, bolt_pattern, center_bore, source_status, source_note
)
select make, model, trim, year_start, year_end, package_name, market,
  is_default, front, rear, tire, bolt_pattern, center_bore, source_status,
  source_note
from dodge_la_ld_verified_baselines;

select model, trim, year_start, year_end, package_name, is_default, front,
  rear, tire, bolt_pattern, center_bore, source_status
from public.fitment_factory_baselines
where make = 'Dodge' and model in ('LA', 'LD') and active
order by model, trim, is_default desc, year_start desc;
